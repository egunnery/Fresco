//
//  BeerDetailsTests.swift
//  FrescoTests
//
//  Created by Eoin Gunnery on 01/10/2022.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
@testable import Fresco

class BeerDetailsTests: XCTestCase {
    
    var mockCoordinator: MockCoordinator!
    var mockViewModel: BeerDetailsViewModel!
    var schedular: ConcurrentDispatchQueueScheduler!
    
    let beer = Beer()

    override func setUpWithError() throws {
        self.mockCoordinator = MockCoordinator(window: nil, navigationController: nil)
        self.mockViewModel = BeerDetailsViewModel(beer: beer, coordinator: mockCoordinator)
        self.schedular = ConcurrentDispatchQueueScheduler(qos: .default)
    }

    func test_view_model_outputs() throws {
        let descriptionText = mockViewModel.descriptionText.asObservable().subscribe(on: schedular)
        XCTAssertEqual(try descriptionText.toBlocking(timeout: 1.0).first(), "description")
        
        let abvText = mockViewModel.abvText.asObservable().subscribe(on: schedular)
        XCTAssertEqual(try abvText.toBlocking(timeout: 1.0).first(), "ABV 1.0")
        
        let hopTitle = mockViewModel.hopTitle.asObservable().subscribe(on: schedular)
        XCTAssertEqual(try hopTitle.toBlocking(timeout: 1.0).first(), "HOPS")
        
        let maltTitle = mockViewModel.maltTitle.asObservable().subscribe(on: schedular)
        XCTAssertEqual(try maltTitle.toBlocking(timeout: 1.0).first(), "MALTS")
        
    }
}
