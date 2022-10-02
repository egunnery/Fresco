//
//  WeightEvent.swift
//  Fresco
//
//  Created by Eoin Gunnery on 01/10/2022.
//

import Foundation

struct WeightEvent: Equatable {
    let timestamp: Int
    let weight: Int
    
    init(timestamp: Int, weight: Int) {
        self.timestamp = timestamp
        self.weight = weight
    }
}
