//
//  PokemonService.swift
//  PokemonTest
//
//  Created by Breno Marques on 04/03/26.
//

import Foundation

protocol PokemonServiceProtocol {
    func fetchPokemon(id: Int) async throws -> Pokemon
}

final class PokemonService: PokemonServiceProtocol {
    
    private let baseUrl: URL
    private let session: URLSession
    
    init(baseUrl: URL, session: URLSession = .shared) {
        self.baseUrl = baseUrl
        self.session = session
    }
    
    func fetchPokemon(id: Int) async throws -> Pokemon {
        let url = baseUrl.appending(path: "pokemon/\(id)")
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(Pokemon.self, from: data)
    }
}
