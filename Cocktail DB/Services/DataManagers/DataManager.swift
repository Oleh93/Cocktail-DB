//
//  DataManager.swift
//  Cocktail DB
//
//  Created by Oleh Mykytyn on 27.03.2020.
//  Copyright © 2020 Oleh Mykytyn. All rights reserved.
//

import Foundation

final class DataManager {
    static let shared = DataManager()
    
    private let userDefaults = UserDefaults.standard
}

extension DataManager {
    private var categoriesToShowKey: String {"categoriesToShow.Key"}

    var categoriesToShow: [String]? {
        set { userDefaults.set(newValue, forKey: categoriesToShowKey)}
        get { userDefaults.stringArray(forKey: categoriesToShowKey)}
    }
}
