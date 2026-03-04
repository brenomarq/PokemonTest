//
//  ContentView.swift
//  PokemonTest
//
//  Created by Breno Marques on 04/03/26.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var vm: PokemonViewModel
    
    init() {
        let service = PokemonService(baseUrl: URL(string: "https://pokeapi.co/api/v2/")!)
        _vm = StateObject(wrappedValue: PokemonViewModel(pokemonService: service))
    }
    
    var body: some View {
        VStack {
            if let pokemon = vm.pokemon {
                Text("Who's this pokemon?")
                    .font(.headline)
                Text("Pokemon name: \(pokemon.name)")
            }
        }
        .padding()
        .task {
            await vm.fetchPokemon(id: 1)
        }
    }
}
