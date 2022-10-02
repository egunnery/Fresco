//
//  BrowserViewModel.swift
//  Fresco
//
//  Created by Eoin Gunnery on 26/09/2022.
//

import Foundation
import RxSwift
import RxCocoa

class BrowserViewModel {
    
    /// The instance of the `BeerAPI` layer
    private let api: BeerAPIType
    
    /// The coordinator for navigation
    private let coordinator: Coordinator
    
    /// The beers retrieved from the api
    var beers = [Beer]()
    
    /// Initialiser for the view model
    ///
    /// - Parameters:
    ///   - api: The api for the network call
    ///   - coordinator: The coordinator for navigation
    init(api: BeerAPIType, coordinator: Coordinator) {
        self.api = api
        self.coordinator = coordinator
    }
    
    /// Method to fetch all beers from the api
    ///
    /// - Returns: A `Single` containing an array of beers
    func getBeers() -> Single<[Beer]> {
        return Single.create { [weak self] single in
            self?.api.fetchBeers { result  in
                switch result {
                case let .success(beers):
                    self?.beers = beers
                    single(.success(beers))
                case let .failure(error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    /// Method to navigate to the beer details screen
    ///
    /// - Parameters:
    ///   - indexPath: The index path of the selected cell
    func didTapCell(at indexPath: IndexPath) {
        let selectedBeer = beers[indexPath.row]
        coordinator.showBeerDetails(for: selectedBeer)
    }
}
