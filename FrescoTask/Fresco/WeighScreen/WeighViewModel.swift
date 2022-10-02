//
//  WeighViewModel.swift
//  Fresco
//
//  Created by Eoin Gunnery on 26/09/2022.
//

import Foundation
import RxSwift
import RxCocoa

class WeighViewModel {
    
    /// The coordinator for navigation
    private let coordinator: Coordinator
    
    /// The subscription to the stream task
    private var subscription: Task<(), Error>!
    
    /// Publish relay to notify of new events
    private let _weightEvent = PublishRelay<WeightEvent?>()
    /// The singal to update events from
    lazy var weightEvent: Signal = {
        return _weightEvent.asSignal()
    }()
    
    /// The ingredient the weight events are based on (when not mocked)
    let ingredient: Ingredient
    
    /// Behavior relay to replay latest string value for the target weight
    private let _targetWeightText = BehaviorRelay<String?>(value: nil)
    /// Driver to bind the replayed value to the UI
    var targetWeightText: Driver<String?> {
        _targetWeightText.asDriver()
    }
    
    /// Behavior relay to replay latest string value for the done button
    private let _doneButtonTitle = BehaviorRelay<String>(value: "Done")
    /// Driver to bind the replayed value to the UI
    var doneButtonTitle: Driver<String> {
        _doneButtonTitle.asDriver()
    }

    /// Initialiser for the view model
    ///
    /// - Parameters:
    ///   - ingredient: The ingredient that the weight values are for
    ///   - coordinator: The coordinator for navigation
    init(ingredient: Ingredient, coordinator: Coordinator) {
        self.ingredient = ingredient
        self.coordinator = coordinator
        let targetWeightValue = ingredient.amount.value
        let targetWeightUnit = ingredient.amount.unit.rawValue
        _targetWeightText.accept("\(targetWeightValue) " + targetWeightUnit)
        streamWeightValues()
    }
    
    /// Method to mock the stream of weight values
    func streamWeightValues() {
        let api = MockStreamAPI()
        subscription = Task {
            for await weightEvent in api.makeAsyncSequence() {
                try await Task.sleep(nanoseconds: 500_000_000)
                _weightEvent.accept(weightEvent)
            }
        }
    }
    
    /// Method to navigatate back to the beer details screen
    ///
    /// - Parameter viewController: The view controller to pop back from
    func navigateBackToDetailsScreen(viewController: UIViewController) {
        coordinator.navgateBack(viewController: viewController)
    }
}

