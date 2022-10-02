//
//  WeighTests.swift
//  FrescoTests
//
//  Created by Eoin Gunnery on 01/10/2022.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
@testable import Fresco

class WeighTests: XCTestCase {
    
    var mockCoordinator: MockCoordinator!
    var mockViewModel: WeighViewModel!
    var schedular: ConcurrentDispatchQueueScheduler!
    
    let malt = Malt(name: "malt", amount: Volume(value: 1.5, unit: .kilograms))

    override func setUpWithError() throws {
        self.mockCoordinator = MockCoordinator(window: nil, navigationController: nil)
        self.mockViewModel = WeighViewModel(ingredient: malt, coordinator: mockCoordinator)
        self.schedular = ConcurrentDispatchQueueScheduler(qos: .default)
    }

    func test_view_model_outputs() throws {
        let comparisonWeightEvent = WeightEvent(timestamp: 300, weight: 2600)
        let weightEvent = mockViewModel.weightEvent.asObservable().subscribe(on: schedular)
        XCTAssertEqual(try weightEvent.toBlocking(timeout: 2.0).first(), comparisonWeightEvent)
        
        let targetWeightText = mockViewModel.targetWeightText.asObservable().subscribe(on: schedular)
        XCTAssertEqual(try targetWeightText.toBlocking(timeout: 1.0).first(), "1.5 kilograms")
        
        let doneButtonTitle = mockViewModel.doneButtonTitle.asObservable().subscribe(on: schedular)
        XCTAssertEqual(try doneButtonTitle.toBlocking(timeout: 1.0).first(), "Done")
    }
}
