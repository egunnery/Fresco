//
//  UIImage+URL.swift
//  Fresco
//
//  Created by Eoin Gunnery on 26/09/2022.
//

import Foundation
import UIKit

extension UIImage {
    
    /// Convenience initialiser to directly retrieve an image from a given url
    ///
    /// - Parameter imageURL: The url to retrieve the image from
    convenience init?(imageURL: String) {
        guard let url = URL(string: imageURL) else { return nil }
        
        do {
            self.init(data: try Data(contentsOf: url))
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}
