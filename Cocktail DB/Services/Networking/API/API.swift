//
//  API.swift
//  Cocktail DB
//
//  Created by Oleh Mykytyn on 26.03.2020.
//  Copyright © 2020 Oleh Mykytyn. All rights reserved.
//

import Foundation
import Moya

class API {
    static let shared = API()
    
    private let provider: MoyaProvider<MultiTarget>
    
    init(provider: MoyaProvider<MultiTarget> = .init()) {
        self.provider = provider
    }
}

// MARK: - Private

private extension API {
    func performRequest<T: Decodable>(target: TargetType, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        provider.request(MultiTarget(target)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(type.self)
                    completion(.success(data))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Categories

extension API {
    func fetchCategories(completion: @escaping (Result<Categories, Error>) -> Void) {
        performRequest(target: CocktailsTarget.categories, type: Categories.self, completion: completion)
    }
}

// MARK: - Cocktails

extension API {
    func fetchDrinks(category: String, completion: @escaping (Result<Drinks, Error>) -> Void) {
        performRequest(target: CocktailsTarget.cocktails(category: category), type: Drinks.self, completion: completion)
    }
}
