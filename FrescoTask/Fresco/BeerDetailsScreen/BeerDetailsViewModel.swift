//
//  BeerDetailsViewModel.swift
//  Fresco
//
//  Created by Eoin Gunnery on 26/09/2022.
//

import Foundation
import RxCocoa

class BeerDetailsViewModel {
    
    /// The beer to display the details for
    let beer: Beer
    
    /// The coordinator for navigation
    private let coordinator: Coordinator
    
    /// Behavior relay to replay latest string value for the description
    private let _descriptionText = BehaviorRelay<String?>(value: nil)
    /// Driver to bind the replayed value to the UI
    var descriptionText: Driver<String?> {
        _descriptionText.asDriver()
    }
    
    /// Behavior relay to replay latest string value for the beer strength
    private let _abvText = BehaviorRelay<String?>(value: nil)
    /// Driver to bind the replayed value to the UI
    var abvText: Driver<String?> {
        _abvText.asDriver()
    }
    
    /// Behavior relay to replay latest string value for the hop title
    private let _hopTitle = BehaviorRelay<String>(value: "HOPS")
    /// Driver to bind the replayed value to the UI
    var hopTitle: Driver<String> {
        _hopTitle.asDriver()
    }
    
    /// Behavior relay to replay latest string value for the malt title
    private let _maltTitle = BehaviorRelay<String>(value: "MALTS")
    /// Driver to bind the replayed value to the UI
    var maltTitle: Driver<String> {
        _maltTitle.asDriver()
    }
    
    /// Initialiser for the view model
    ///
    /// - Parameters:
    ///   - beer: The beer to display the details for
    ///   - coordinator: The coordinator for navigation
    init(beer: Beer, coordinator: Coordinator) {
        self.beer = beer
        self.coordinator = coordinator
        setupScreen(beer: beer)
    }
    
    /// Method to update labels with beer parameter
    ///
    /// - Parameter beer: The beer for the details
    func setupScreen(beer: Beer) {
        _descriptionText.accept(beer.description)
        _abvText.accept("ABV \(String(beer.abv))")
    }
    
    /// Method to navigatate to the weigh screen
    ///
    /// - Parameter ingredient: The ingredient to weigh
    func goToWeighScreen(ingredient: Ingredient) {
        coordinator.showWeighScreen(for: ingredient)
    }
}
