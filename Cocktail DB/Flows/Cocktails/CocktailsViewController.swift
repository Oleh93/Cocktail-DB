//
//  ViewController.swift
//  Cocktail DB
//
//  Created by Oleh Mykytyn on 26.03.2020.
//  Copyright © 2020 Oleh Mykytyn. All rights reserved.
//

import UIKit

private enum Constants {
    static var heightForRow = 100
}

final class CocktailsViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var drinksTableView: UITableView!
    
    // MARK: - Properties
    var cocktailsCoordinatorProtocol: CocktailsCoordinatorProtocol?
    
    var drinks: [String: [Drink]] = [:] {
        didSet {
            DispatchQueue.main.async { self.drinksTableView.reloadData() }
        }
    }
    var categories: [String] = []
    var categoriesToShow: [String] = [] {
        didSet {
            DispatchQueue.main.async { self.drinksTableView.reloadData() }
        }
    }

    // MARK: - Lifecycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupTableView()
        setupTableViewCell()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Drinks"
        
        setupCategoriesButton()
        
        API.shared.fetchCategories { (result) in
            switch result {
            case .success(let data):
                self.categories = data.drinks.compactMap({ $0.strCategory })

                if DataManager.shared.categoriesToShow == nil {
                    DataManager.shared.categoriesToShow = self.categories
                }
                self.categoriesToShow = DataManager.shared.categoriesToShow!
                
                print("categories success")
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - Private

private extension CocktailsViewController {
    func setupTableView() {
        let nib = UINib.init(nibName: "CocktailsTableViewCell", bundle: nil)
        self.drinksTableView.register(nib, forCellReuseIdentifier: "CocktailsTableViewCell")
    }
    
    func setupTableViewCell() {
        drinksTableView.delegate = self
        drinksTableView.dataSource = self
    }
    
    func setupCategoriesButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Categories", style: .plain, target: self, action: #selector(categoriesButtonTapped))
    }
    
    @objc func categoriesButtonTapped() {
        cocktailsCoordinatorProtocol?.navigateToCategories(categories: categories, completion: { (selectedCategories) in
            self.categoriesToShow = selectedCategories
        })
    }
}

// MARK: - UITableViewDataSource

extension CocktailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        categoriesToShow.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        categoriesToShow[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = categoriesToShow[section]
        return drinks[category]?.count ?? 0
    }
    
    //swiftlint:disable force_cast
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CocktailsTableViewCell", for: indexPath) as! CocktailsTableViewCell
        guard let drinks = drinks[categoriesToShow[indexPath.section]] else { return cell}
        
        cell.configure(drink: drinks[indexPath.row])
        return cell
    }
    //swiftlint:enable force_cast
}

// MARK: - UITableViewDelegate

extension CocktailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(Constants.heightForRow)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let category = categoriesToShow[section]

        if drinks[category] == nil {
            API.shared.fetchDrinks(category: category) { (result) in
                switch result {
                case .success(let data):
                    print("success")
                    self.drinks[category] = data.drinks
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
