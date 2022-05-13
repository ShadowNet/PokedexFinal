//
//  PokeModel.swift
//  PokedexFinal
//
//  Created by Redghy on 5/7/22.
//
// where all the magic is stored.
import Foundation

struct pokeModel: Decodable{
    let abilities: [Ability]
    let base_experience: Int
    let forms: [basicData]
    let game_indices: [gameIndex]
    let height: Int
    let held_items: [heldItem]
    let id: Int
    let is_default: Bool
    let location_area_encounters: String
    let moves: [Move]
    let name: String
    let order: Int
    let past_types: [basicData]
    let species: basicData
    let sprites: Sprites
    let stats: [Stat]
    let types: [Types]
    let weight: Int
}

struct Ability: Decodable {
    let ability: basicData
    let is_hidden: Bool
    let slot: Int
}

struct gameIndex: Decodable {
    let game_index: Int
    let version: basicData
}

struct heldItem: Decodable {
    let item: basicData
    let version_details: [versionDetails]
}

struct versionDetails: Decodable {
    let rarity: Int
    let version: basicData
}

struct Move: Decodable {
    let move: basicData
}

struct versionGroupDetails: Decodable {
    let level_learned_at: Int
    let move_learn_method: basicData
    let version_group: basicData
}

struct Sprites: Decodable {
    let back_default: String?
    let back_female: String?
    let back_shiny: String?
    let back_shiny_female: String?
    let front_default: String?
    let front_female: String?
    let front_shiny: String?
    let front_shiny_female: String?
    //let other: OtherData
}

struct otherData: Decodable {
    let nexus: Nexus
    let home: Home
}

struct Nexus: Decodable {
    let front_default: String?
    let front_female: String?
}

struct Home: Decodable {
    let front_default: String?
    let front_female: String?
    let front_shiny: String?
    let front_shiny_female: String?
}

struct Stat: Decodable {
    let base_stat: Int
    let effort: Int
    let stat: basicData
    
}

struct Types: Decodable{
    let slot: Int
    let type: basicData
}
