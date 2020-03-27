//
//  ApplicationCoordinator.swift
//  Cocktail DB
//
//  Created by Oleh Mykytyn on 26.03.2020.
//  Copyright © 2020 Oleh Mykytyn. All rights reserved.
//

import Foundation
import UIKit

final class ApplicationCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showCocktails()
        print("app coordinator started")
    }
}

// MARK: - Cocktails Flow

private extension ApplicationCoordinator {
    func showCocktails() {
        let cocktailsCoordinator = CocktailsCoordinator(navigationController: navigationController)
        childCoordinators.append(cocktailsCoordinator)
        cocktailsCoordinator.start()
    }
}
