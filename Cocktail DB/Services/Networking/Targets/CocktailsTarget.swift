//
//  CocktailsTarget.swift
//  Cocktail DB
//
//  Created by Oleh Mykytyn on 26.03.2020.
//  Copyright © 2020 Oleh Mykytyn. All rights reserved.
//

import Foundation
import Moya

enum CocktailsTarget {
    case categories
    case cocktails(category: String)
}

extension CocktailsTarget: TargetType {
    var baseURL: URL {
        return URL(string: "https://www.thecocktaildb.com/api/json/v1/1")!
    }
    
    var path: String {
        switch self {
        case .categories:
            return "/list.php"
        case .cocktails:
            return "/filter.php"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .categories:
            return .get
        case .cocktails:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .categories:
            return .requestParameters(parameters: ["c": "list"],
                                      encoding: URLEncoding.queryString)
        case .cocktails(category: let category):
            return .requestParameters(parameters: ["c": category],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var validationType: ValidationType {
        .successCodes
    }
}
