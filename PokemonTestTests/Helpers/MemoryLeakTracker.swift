//
//  MemoryLeakTracker.swift
//  PokemonTestTests
//
//  Created by Breno Marques on 04/03/26.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(
        _ instance: AnyObject,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        addTeardownBlock { [weak instance] in
            DispatchQueue.main.async {
                XCTAssertNil(
                    instance,
                    "A possible memory leak was detected.",
                    file: file,
                    line: line
                )
            }
        }
    }
}
