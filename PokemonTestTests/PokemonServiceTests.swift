//
//  PokemonTestTests.swift
//  PokemonTestTests
//
//  Created by Breno Marques on 04/03/26.
//

import XCTest
@testable import PokemonTest

final class PokemonServiceTests: XCTestCase {
    
    private var sut: PokemonService!
    private var session: URLSession!

    override func setUp() {
        super.setUp()
        session = createMockSession()
        let baseUrl = URL(string: "https://pokeapi.co/api/v2/")!
        sut = PokemonService(baseUrl: baseUrl, session: session)
        
        trackForMemoryLeaks(sut)
    }
    
    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        session = nil
        sut = nil
        super.tearDown()
    }

    @MainActor
    func test_pokemonService_whenValidRequest_shouldReturnPokemon() async throws {
        let expectedData = Pokemon(id: 1, name: "bulbasaur")
        let mockData = try JSONEncoder().encode(expectedData)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            
            return (response, mockData)
        }
        
        let pokemon = try await sut.fetchPokemon(id: 1)
        
        XCTAssertEqual(pokemon, expectedData, "The pokemon should be the same as the one returned by the API")
    }
    
    func test_pokemonService_whenBadResponse_shouldThrow() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            )!
            
            return (response, Data())
        }
        
        do {
            let _ = try await sut.fetchPokemon(id: 1)
            XCTFail("Should throw an error")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
    
    private func createMockSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: config)
    }

}
