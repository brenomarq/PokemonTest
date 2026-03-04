//
//  PokemonViewModel.swift
//  PokemonTest
//
//  Created by Breno Marques on 04/03/26.
//

import Combine

@MainActor
final class PokemonViewModel: ObservableObject {
    
    @Published var pokemon: Pokemon? = nil
    
    private let pokemonService: any PokemonServiceProtocol
    
    init(pokemonService: any PokemonServiceProtocol) {
        self.pokemonService = pokemonService
    }
    
    func fetchPokemon(id: Int) async {
        let pokemon = try? await pokemonService.fetchPokemon(id: id)
        self.pokemon = pokemon
    }
    
}
