//
//  MockStreamAPI.swift
//  Fresco
//
//  Created by Eoin Gunnery on 29/09/2022.
//

import Foundation

class MockStreamAPI {
    
    
    /// Method to decode the mock csv of weight events
    ///
    /// - Returns: An array of `WeightEvent`
    func getCSVData() -> [WeightEvent] {
        guard let path = Bundle.main.path(forResource: "input_long", ofType: "csv") else {
            return []
        }
        do {
            let content = try String(contentsOfFile: path)
            var result: [WeightEvent] = []
            let rows = content.components(separatedBy: "\n")
            // quick way of not worrying about the names in the first row and the useless last one
            for row in 1...150 {
                let rowWithoutWhitespace = rows[row].replacingOccurrences(of: " ", with: "")
                let columns = rowWithoutWhitespace.components(separatedBy: ",")
                let timestamp: Int = Int(columns[1]) ?? 0
                let weight: Int = Int(columns[2]) ?? 0
                let event = WeightEvent(timestamp: timestamp, weight: weight)
                result.append(event)
            }
            return result
        }
        catch {
            return []
        }
    }
    
    /// Method to create a stream of weight events
    ///
    /// - Returns: a stream of `WeightEvent`
    func makeAsyncSequence() -> AsyncStream<WeightEvent> {
        let events = getCSVData()
        return AsyncStream(WeightEvent.self) { continuation in
            for event in events {
                continuation.yield(event)
            }
        }
    }
}
