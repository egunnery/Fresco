//
//  BeerAPIType.swift
//  Fresco
//
//  Created by Eoin Gunnery on 26/09/2022.
//

import Foundation

public protocol BeerAPIType {
    
    /// Method to fetch all beers.
    ///
    /// - Parameter completionHander: Completion handler for the result containing either `AllResults` or an `Error`.
    func fetchBeers(completionHander: @escaping (Result <[Beer], Error>) -> Void)
}
