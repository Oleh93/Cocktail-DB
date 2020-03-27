//
//  ViewControllerFactory.swift
//  Cocktail DB
//
//  Created by Oleh Mykytyn on 26.03.2020.
//  Copyright © 2020 Oleh Mykytyn. All rights reserved.
//

import Foundation
import UIKit

//swiftlint:disable force_cast
struct ViewControllerType {
    let storyboardName: String
    let storyboardId: String
    
    init(storyboard name: String, viewController id: String) {
        self.storyboardName = name
        self.storyboardId = id
    }
}

final class ViewControllerFactory {
    static let shared = ViewControllerFactory()
    
    private init() {}
    
    private func createViewController(for type: ViewControllerType) -> UIViewController {
        let sb = UIStoryboard(name: type.storyboardName, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: type.storyboardId)
        return vc
    }
}

// MARK: - Cocktails Flow

extension ViewControllerFactory {
    func cocktailsViewController() -> CocktailsViewController {
        let vc = createViewController(
            for: ViewControllerType(
                storyboard: "Cocktails",
                viewController: "CocktailsViewController"
            )
        )
        return vc as! CocktailsViewController
    }
}

// MARK: - Categories Flow

extension ViewControllerFactory {
    func categoriesViewController() -> CategoriesViewController {
        let vc = createViewController(
            for: ViewControllerType(
                storyboard: "Categories",
                viewController: "CategoriesViewController"
            )
        )
        return vc as! CategoriesViewController
    }
}
//swiftlint:enable force_cast
