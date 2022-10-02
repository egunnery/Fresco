//
//  IngredientView.swift
//  Fresco
//
//  Created by Eoin Gunnery on 29/09/2022.
//

import UIKit
import RxSwift

class IngredientView: UIView {
    
    /// The ingredient to set up the view for
    let ingredient: Ingredient
    
    /// The `UIView` to contain the labels and image
    private let containerView: UIView
    
    /// Label containing the name of the ingredient
    private let nameLabel: UILabel
    
    /// Label containing the weight value of the ingredient
    private let valueLabel: UILabel
    
    /// Label containing the unit of weight for the ingredient
    private let unitLabel: UILabel
    
    /// The arrow to indicate action
    private let rightArrowImage: UIImageView
    
    
    /// Initialiser for the ingredient view
    ///
    /// - Parameter ingredient: The ingredient to set up the view for
    init(ingredient: Ingredient) {
        self.ingredient = ingredient
        self.containerView = UIView(frame: .zero)
        self.nameLabel = UILabel()
        self.valueLabel = UILabel()
        self.unitLabel = UILabel()
        let image = UIImage(systemName: "chevron.right")
        self.rightArrowImage = UIImageView(image: image)
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
        updateValues(ingredient: ingredient)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Method to set up the UI
    private func setupUI() {
        isUserInteractionEnabled = true
        backgroundColor = .white
        addSubview(containerView)
        rightArrowImage.contentMode = .scaleAspectFit
        containerView.addSubview(nameLabel)
        containerView.addSubview(valueLabel)
        containerView.addSubview(unitLabel)
        containerView.addSubview(rightArrowImage)
    }
    
    /// Method to setup constraints
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
        valueLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(10)
        }
        unitLabel.snp.makeConstraints { make in
            make.leading.equalTo(valueLabel.snp.trailing).offset(5)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(10)
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        rightArrowImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(25)
            make.height.equalTo(25)
            make.leading.greaterThanOrEqualTo(nameLabel.snp.leading)
            make.trailing.equalToSuperview()
        }
    }
    
    
    /// Method to update the labels of the view with the ingredient details
    ///
    /// - Parameter ingredient: The ingredient to update the view for
    func updateValues(ingredient: Ingredient) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        
        let nameAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .bold),
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle
        ]
        let ingredientAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle
        ]
        let ingredientNameAttributedString = NSAttributedString(string: ingredient.name, attributes: nameAttributes)
        nameLabel.attributedText = ingredientNameAttributedString
        
        
        let ingredientValueAttributedString = NSAttributedString(string: String(ingredient.amount.value), attributes: ingredientAttributes)
        valueLabel.attributedText = ingredientValueAttributedString
        
        
        let ingredientUnitAttributedString = NSAttributedString(string: ingredient.amount.unit.rawValue, attributes: ingredientAttributes)
        unitLabel.attributedText = ingredientUnitAttributedString
    }
}
