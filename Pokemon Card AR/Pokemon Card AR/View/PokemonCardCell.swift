//
//  PokemonCardCell.swift
//  Pokemon Card AR
//
//  Created by Victor S Melo on 02/11/18.
//  Copyright © 2018 Victor Melo. All rights reserved.
//

import UIKit

class PokemonCardCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    public func configure(name: String, photo: UIImage) {
        self.nameLabel.text = name
        self.photoImageView.image = photo
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
    }
}
