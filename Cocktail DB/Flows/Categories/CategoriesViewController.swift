//
//  CategoriesViewController.swift
//  Cocktail DB
//
//  Created by Oleh Mykytyn on 26.03.2020.
//  Copyright © 2020 Oleh Mykytyn. All rights reserved.
//

import Foundation
import UIKit

final class CategoriesViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var categoriesTableView: UITableView!
    
    // MARK: - Properties
    
    var categories: [String] = []
    private var selectedCategoriesIndexes: [Int] = []
    var completion: (([String]) -> Void)?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        
        setupTableView()
        setupTableViewCell()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let selectedCategories = getSelectedCategories()
        DataManager.shared.categoriesToShow = selectedCategories
        completion?(selectedCategories)
    }
}

// MARK: - Private

private extension CategoriesViewController {
    func setupTableView() {
        let nib = UINib.init(nibName: "CategoriesTableViewCell", bundle: nil)
        self.categoriesTableView.register(nib, forCellReuseIdentifier: "CategoriesTableViewCell")
    }
    
    func setupTableViewCell() {
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
    }
    
    func setupSaveButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
    }
    
    @objc func saveButtonTapped() {
        print("save tapped")
    }
    
    func getSelectedCategories() -> [String] {
        var selectedCategories: [String] = []
        for i in selectedCategoriesIndexes {
            selectedCategories.append(categories[i])
        }
        return selectedCategories
    }
}

// MARK: - UITableViewDataSource

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    //swiftlint:disable force_cast
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesTableViewCell", for: indexPath) as! CategoriesTableViewCell
        
        let category = categories[indexPath.row]
        
        cell.categoryLabel.text = category
        
        if DataManager.shared.categoriesToShow?.contains(category) == true {
            cell.accessoryType = .checkmark
            selectedCategoriesIndexes.append(indexPath.row)
        }
        //swiftlint:enable force_cast

        return cell
    }
}

// MARK: - UITableViewDelegate

extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CategoriesTableViewCell {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                if let index = selectedCategoriesIndexes.firstIndex(of: indexPath.row) {
                    selectedCategoriesIndexes.remove(at: index)
                }
            } else {
                cell.accessoryType = .checkmark
                selectedCategoriesIndexes.append(indexPath.row)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
