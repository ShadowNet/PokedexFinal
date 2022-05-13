//
//  NetworkManager.swift
//  PokedexFinal
//
//  Created by Redghy on 5/5/22.
//

import UIKit
// network manager class that fetches the data needed
class networkManager {
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared){
        self.session = session
    }
}

extension networkManager {
    
    func engagePokemon(poke_set: Int,completion: @escaping (Result<pokeList, Error>) -> Void){
        
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?offset=\(poke_set)&limit=30") else {
            completion(.failure(networkError.badURL))
            return
        }
        
        self.session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200..<300).contains(httpResponse.statusCode) {
                completion(.failure(networkError.badServerResponse(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(networkError.badData))
                return
            }
            
            do {
                let pokeList = try JSONDecoder().decode(pokeList.self, from: data)
                
                completion(.success(pokeList))
            }
            catch {
                completion(.failure(networkError.decodeError("\(error)")))
            }
        }.resume()
    }
    
    func pokemonAttributes(url_string: String, completion: @escaping (Result<pokeModel, Error>) -> Void){
        
        guard let url = URL(string: url_string) else {
                completion(.failure(networkError.badURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200..<300).contains(httpResponse.statusCode) {
                completion(.failure(networkError.badServerResponse(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(networkError.badData))
                return
            }
            
            do {
                let pokeList = try JSONDecoder().decode(pokeModel.self, from: data)
                
                completion(.success(pokeList))
            }
            catch {
                completion(.failure(networkError.decodeError("\(error)")))
            }
            
        }
        
        task.resume()
    }
    
    func pokeImage(url_string: String, completion: @escaping (Result<Data, Error>) -> Void){
        guard let url = URL(string: url_string) else {
                completion(.failure(networkError.badURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200..<300).contains(httpResponse.statusCode) {
                completion(.failure(networkError.badServerResponse(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(networkError.badData))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}
