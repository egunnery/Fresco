//
//  UILabel+RxUpdateText.swift
//  Fresco
//
//  Created by Eoin Gunnery on 30/09/2022.
//

import UIKit
import RxSwift

extension Reactive where Base: UILabel {
    
    /// Binding to upate the text of a label and make it a tad nicer 
    public var text: Binder<String?> {
        return Binder(self.base) { label, text in
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 18),
                .foregroundColor: UIColor.black
            ]
            let attrString = NSAttributedString(string: text ?? "", attributes: attributes)
            label.attributedText = attrString
        }
    }
    
    /// Binding to update the text of a label and make it a tad nicer and bold
    public var boldText: Binder<String?> {
        return Binder(self.base) { label, text in
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 18, weight: .bold),
                .foregroundColor: UIColor.black
            ]
            let attrString = NSAttributedString(string: text ?? "", attributes: attributes)
            label.attributedText = attrString
        }
    }
}
