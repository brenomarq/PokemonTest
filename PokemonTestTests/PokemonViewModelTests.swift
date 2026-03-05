//
//  PokemonViewModelTests.swift
//  PokemonTestTests
//
//  Created by Breno Marques on 04/03/26.
//

import XCTest
@testable import PokemonTest

final class MockPokemonService: PokemonServiceProtocol {
    
    var shouldThrow: Bool = false
    var expectedValue: Pokemon
    
    init(expectedValue: Pokemon? = nil) {
        self.expectedValue = expectedValue ?? Pokemon(id: 1, name: "bulbasaur")
    }
    
    func fetchPokemon(id: Int) async throws -> Pokemon {
        if shouldThrow { throw URLError(.badServerResponse) }
        
        return expectedValue
    }
}

@MainActor
final class PokemonViewModelTests: XCTestCase {
    
    private var sut: PokemonViewModel!
    private var service: MockPokemonService!

    override func setUp() {
        super.setUp()
        service = MockPokemonService()
        sut = PokemonViewModel(pokemonService: service)
        
        trackForMemoryLeaks(sut)
    }

    override func tearDown() {
        sut = nil
        service = nil
        super.tearDown()
    }

    func test_fetchPokemon_success_setsPokemon() async {
        XCTAssertNil(sut.pokemon)
        
        // When
        await sut.fetchPokemon(id: 1)
        
        // Then
        XCTAssertEqual(sut.pokemon, service.expectedValue, "The published pokemon should match the expected value")
    }
    
    func test_fetchPokemon_failure_keepsPokemonNil() async {
        // Given
        service.shouldThrow = true
        
        // When
        await sut.fetchPokemon(id: 1)
        
        // Then
        XCTAssertNil(sut.pokemon, "The published pokemon should be nil when the response is invalid")
    }
}
