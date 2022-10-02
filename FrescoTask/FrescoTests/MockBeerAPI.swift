//
//  MockBeerAPI.swift
//  FrescoTests
//
//  Created by Eoin Gunnery on 01/10/2022.
//

import Foundation
@testable import Fresco

class MockBeerAPI: BeerAPIType {
    
    func fetchBeers(completionHander: @escaping (Result<[Beer], Error>) -> Void) {
        getJson { result in
            switch result {
            case let .success(result):
                completionHander(.success(result))
            case let .failure(error):
                completionHander(.failure(error))
            }
        }
    }
    
    func getJson(completionHander: @escaping (Result<[Beer], Error>) -> Void) {
        let jsonDecoder = JSONDecoder()
        guard let path = Bundle(for: type(of: self)).path(forResource: "beer_success", ofType: "json") else {
            return
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let beers = try! jsonDecoder.decode([Beer].self, from: data)
            completionHander(.success(beers))
        } catch {
            completionHander(.failure(error))
        }
    }
}
