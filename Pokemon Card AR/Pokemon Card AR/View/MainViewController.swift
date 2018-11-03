//
//  MainViewController.swift
//  Pokemon Card AR
//
//  Created by Victor S Melo on 02/11/18.
//  Copyright © 2018 Victor Melo. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {
    
    var pokemons: [Pokemon] = PokemonFactory.getAllModels()
    let numberOfCellsPerRow: CGFloat = 4
    
    @IBOutlet weak var cardsCollectionView: UICollectionView!
    
    override func viewDidLoad() {

    }
    
    private func present3dModel(_ pokemon: Pokemon) {
        performSegue(withIdentifier: "presentARModel", sender: pokemon.assetFileName)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? Present3dModelViewController, let assetName = sender as? String {
            vc.pokemon3dAssetName = assetName
        }
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "pokemonCardCell", for: indexPath) as? PokemonCardCell) ?? PokemonCardCell()
        
        cell.configure(name: pokemons[indexPath.row].name, photo: pokemons[indexPath.row].photo)
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = (collectionView.frame.size.width-10)/2
        let cellHeight = cellWidth*1.333
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPokemon = pokemons[indexPath.row]
        present3dModel(selectedPokemon)
    }
}
