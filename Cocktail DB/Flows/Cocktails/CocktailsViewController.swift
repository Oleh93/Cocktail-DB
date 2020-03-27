//
//  ViewController.swift
//  Cocktail DB
//
//  Created by Oleh Mykytyn on 26.03.2020.
//  Copyright © 2020 Oleh Mykytyn. All rights reserved.
//

import UIKit
import MBProgressHUD

private enum Constants {
    static var heightForRow = 100
    static var paginationReserve = 3
}

final class CocktailsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak private var drinksTableView: UITableView!
    
    // MARK: - Properties
    
    var cocktailsCoordinatorProtocol: CocktailsCoordinatorProtocol?
    
    var drinksDict: [String: [Drink]] = [:] {
        didSet { DispatchQueue.main.async {
            if !self.drinksDict.isEmpty {
                    self.drinksTableView.reloadData()
                }
            }
        }
    }
    var categories: [String] = []
    
    var categoriesToShow: [String] = [] {
        didSet { DispatchQueue.main.async {
                self.loadFirstSection()

                self.stopProgressHud()
            }
        }
        willSet { DispatchQueue.main.async { self.startProgressHud(with: "Loading...") } }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startProgressHud(with: "Loading...")
        setupTableView()
        setupTableViewCell()
        title = "Drinks"
                
        API.shared.fetchCategories { (result) in
            switch result {
            case .success(let data):
                self.categories = data.drinks.compactMap({ $0.strCategory })
                
                if DataManager.shared.categoriesToShow == nil {
                    DataManager.shared.categoriesToShow = self.categories
                }
                self.categoriesToShow = DataManager.shared.categoriesToShow!
                self.stopProgressHud()
                
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
    
    func setupCategoriesButton(active: Bool) {
        let item = UIBarButtonItem(title: "Categories", style: .plain, target: self, action: #selector(categoriesButtonTapped))
        item.isEnabled = true ? active: false
        navigationItem.rightBarButtonItem = item
    }
    
    @objc func categoriesButtonTapped() {
        cocktailsCoordinatorProtocol?.navigateToCategories(categories: categories, completion: { (selectedCategories) in
            self.categoriesToShow = selectedCategories
        })
    }
    
    func loadFirstSection() {
        if categoriesToShow.isEmpty { drinksTableView.reloadData(); return }
        API.shared.fetchDrinks(category: categoriesToShow[0]) { (result) in
            switch result {
            case .success(let data):
                self.drinksDict[self.categoriesToShow[0]] = data.drinks
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func startProgressHud(with title: String) {
        setupCategoriesButton(active: false)
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = title
    }
    
    func stopProgressHud() {
        MBProgressHUD.hide(for: view, animated: true)
        setupCategoriesButton(active: true)
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
        return drinksDict[category]?.count ?? 0
    }
    
    //swiftlint:disable force_cast
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CocktailsTableViewCell", for: indexPath) as! CocktailsTableViewCell

        guard let drinks = drinksDict[categoriesToShow[indexPath.section]] else { return cell}
        
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let currentCategory = categoriesToShow[indexPath.section]
        if indexPath.section == categoriesToShow.count - 1 { return }
        let nextCategory = categoriesToShow[indexPath.section + 1]
        
        if let currentDrinks = drinksDict[currentCategory] {
            if indexPath.row == currentDrinks.count - Constants.paginationReserve {
                API.shared.fetchDrinks(category: nextCategory) { (result) in
                    switch result {
                    case .success(let data):
                        if self.drinksDict[nextCategory] == nil {
                            self.drinksDict[nextCategory] = data.drinks
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        } else {
            API.shared.fetchDrinks(category: currentCategory) { (result) in
                switch result {
                case .success(let data):
                    if self.drinksDict[nextCategory] == nil {
                        self.drinksDict[currentCategory] = data.drinks
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
