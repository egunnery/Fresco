//
//  BeerAPI.swift
//  Fresco
//
//  Created by Eoin Gunnery on 26/09/2022.
//

import Foundation
import UIKit

class BeerAPI: BeerAPIType {
    
    /// Method to fetch all beers.
    ///
    /// - Parameter completionHander: Completion handler for the result containing either `AllResults` or an `Error`.
    func fetchBeers(completionHander: @escaping (Result<[Beer], Error>) -> Void) {
        let jsonDecoder = JSONDecoder()
        let url = URL(string: "https://api.punkapi.com/v2/beers")!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let beers = try jsonDecoder.decode([Beer].self, from: data)
                    completionHander(.success(beers))
                } catch {
                    assertionFailure("Decodable error")
                }
            } else if let error = error {
                completionHander(.failure(error))
            }
        }
        task.resume()
    }
}
