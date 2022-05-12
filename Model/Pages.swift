//
//  Pages.swift
//  PokedexFinal
//
//  Created by Redghy on 5/7/22.
//

import Foundation

struct pokeList: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [basicData]
    
    
}

struct basicData: Decodable {
    let name: String
    let url: String
}

