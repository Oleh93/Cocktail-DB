//
//  CocktailsTableViewCell.swift
//  Cocktail DB
//
//  Created by Oleh Mykytyn on 26.03.2020.
//  Copyright © 2020 Oleh Mykytyn. All rights reserved.
//

import UIKit
import SDWebImage

final class CocktailsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet private weak var imgView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    // MARK: - Methods

    func configure(drink: Drink) {
        nameLabel.text = drink.strDrink
        if let strURL = drink.strDrinkThumb {
            imgView.sd_setImage(with: URL(string: strURL))
        }
    }
}
