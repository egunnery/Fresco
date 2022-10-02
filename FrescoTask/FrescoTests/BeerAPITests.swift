//
//  BeerAPITests.swift
//  FrescoTests
//
//  Created by Eoin Gunnery on 26/09/2022.
//


import XCTest
import RxTest
import RxBlocking
@testable import Fresco

class BeerAPITests: XCTestCase {
    
    var mockAPI: BeerAPIType!
    var mockCoordinator: MockCoordinator!

    override func setUpWithError() throws {
        self.mockAPI = MockBeerAPI()
        self.mockCoordinator = MockCoordinator(window: nil, navigationController: nil)
    }

    func test_api_fetch_results() throws {
        let expectation = expectation(description: #function)
        mockAPI.fetchBeers { result in
            switch result {
            case let .success(beers):
                XCTAssertEqual(beers.count, 25)
                let firstBeer = beers.first
                XCTAssertEqual(firstBeer?.name, "Buzz")
                XCTAssertEqual(firstBeer?.imageURL, "https://images.punkapi.com/v2/keg.png")
                XCTAssertEqual(firstBeer?.abv, 4.5)
                XCTAssertEqual(firstBeer?.ingredients.malt.count, 3)
                XCTAssertEqual(firstBeer?.ingredients.hops.count, 5)
            case let .failure(error):
                XCTFail("Should not get an error here. Error: \(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 15)
    }
}

class MockCoordinator: Coordinator {

}
