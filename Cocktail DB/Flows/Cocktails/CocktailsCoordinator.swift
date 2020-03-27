//
//  CocktailsCoordinator.swift
//  Cocktail DB
//
//  Created by Oleh Mykytyn on 26.03.2020.
//  Copyright © 2020 Oleh Mykytyn. All rights reserved.
//

import Foundation
import UIKit

protocol CocktailsCoordinatorProtocol: Coordinator {
    func navigateToCategories(categories: [String], completion: (([String]) -> Void)?)
}

final class CocktailsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = ViewControllerFactory.shared.cocktailsViewController()
        vc.cocktailsCoordinatorProtocol = self
        navigationController.pushViewController(vc, animated: false)
    }
}

extension CocktailsCoordinator: CocktailsCoordinatorProtocol {
    func navigateToCategories(categories: [String], completion: (([String]) -> Void)?) {
        let vc = ViewControllerFactory.shared.categoriesViewController()
        
        vc.categories = categories
        vc.completion = completion
        
        navigationController.pushViewController(vc, animated: true)
    }
}
