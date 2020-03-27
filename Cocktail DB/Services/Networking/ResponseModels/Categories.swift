//
//  CategoriesResponse.swift
//  Cocktail DB
//
//  Created by Oleh Mykytyn on 26.03.2020.
//  Copyright © 2020 Oleh Mykytyn. All rights reserved.
//

import Foundation

struct Categories: Decodable {
    let drinks: [Category]
}

struct Category: Decodable {
    var strCategory: String?
}
