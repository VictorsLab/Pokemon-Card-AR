//
//  PokemonFactory.swift
//  Pokemon Card AR
//
//  Created by Victor S Melo on 02/11/18.
//  Copyright © 2018 Victor Melo. All rights reserved.
//

import Foundation
import UIKit

/**
 Represents each pokemon. To successfully create a pokemon, you should add a photo for it in Assets.xcassets, and
 add a 3d model in art.scnassets.
 */
enum PokemonFactory: String, CaseIterable {
    case Pikachu
    case Squirtle
    case Bulbasaur
    case Blastoise
    case Charizard
    case Venusaur
    
    func model() -> Pokemon {
        guard let photo = UIImage(named: "Profile/\(self.rawValue)") else {
            print("[Error]: \(self.rawValue) has no image")
            return Pokemon.init(name: self.rawValue, photo: UIImage(), assetFileName: self.rawValue)
        }
        
        return Pokemon.init(name: self.rawValue, photo: photo, assetFileName: self.rawValue)
    }
    
    // Return all pokemon models
    static func getAllModels() -> [Pokemon] {
        return PokemonFactory.allCases.map { $0.model() }
    }
}
