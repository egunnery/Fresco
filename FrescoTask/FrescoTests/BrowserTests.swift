//
//  BrowserTests.swift
//  FrescoTests
//
//  Created by Eoin Gunnery on 01/10/2022.
//

import XCTest
import RxTest
import RxBlocking
@testable import Fresco

class BrowserTests: XCTestCase {
    
    var mockAPI: BeerAPIType!
    var mockCoordinator: MockCoordinator!
    var mockViewModel: BrowserViewModel!

    override func setUpWithError() throws {
        self.mockAPI = MockBeerAPI()
        self.mockCoordinator = MockCoordinator(window: nil, navigationController: nil)
        self.mockViewModel = BrowserViewModel(api: mockAPI, coordinator: mockCoordinator)
    }

    func test_view_model_get_all_beers() throws {
        let single = mockViewModel.getBeers()
        let beers = try single.toBlocking(timeout: 5.0).first()
        XCTAssertEqual(beers?.count, 25)
        let firstBeer = beers?.first
        XCTAssertEqual(firstBeer?.name, "Buzz")
        XCTAssertEqual(firstBeer?.imageURL, "https://images.punkapi.com/v2/keg.png")
        XCTAssertEqual(firstBeer?.abv, 4.5)
        XCTAssertEqual(firstBeer?.ingredients.malt.count, 3)
        XCTAssertEqual(firstBeer?.ingredients.hops.count, 5)
    }
}
