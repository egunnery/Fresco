//
//  BeerTableViewCell.swift
//  Fresco
//
//  Created by Eoin Gunnery on 26/09/2022.
//

import UIKit
import SnapKit

class BeerTableViewCell: UITableViewCell {
    
    /// The `UIView` to contain the labels and image
    private let container: UIView
    
    /// The image of the beer
    private var beerImageView: UIImageView
    
    /// Labe containing the beer name
    private var beerName: UILabel
    
    /// Label containing the beer strength
    private var beerABV: UILabel
    
    /// Reusable identifier for the cell
    public static let reuseIdentifier = "beerCell"
    
    
    /// Initialiser for the beer table view cell
    ///
    /// - Parameters:
    ///   - style: The style of the cell
    ///   - reuseIdentifier: The reusable identifer for the cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.container = UIView(frame: .zero)
        self.beerImageView = UIImageView(image: UIImage(named: "questionmark"))
        self.beerName = UILabel(frame: .zero)
        self.beerABV = UILabel(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Method to set up the UI
    func setupUI() {
        addSubview(container)
        selectionStyle = .none
        container.addSubview(beerImageView)
        beerImageView.layer.borderWidth = 2
        beerImageView.layer.masksToBounds = false
        let borderColor = UIColor.systemGray
        beerImageView.layer.borderColor = borderColor.withAlphaComponent(0.5).cgColor
        beerImageView.layer.cornerRadius = 50
        beerImageView.clipsToBounds = true
        beerImageView.contentMode = .scaleAspectFit
        beerName.numberOfLines = 0
        container.addSubview(beerName)
        container.addSubview(beerABV)
    }
    
    /// Method to setup constraints
    func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(130)
        }
        beerImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        beerName.snp.makeConstraints { make in
            make.leading.equalTo(beerImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
        }
        beerABV.snp.makeConstraints { make in
            make.leading.equalTo(beerName.snp.leading)
            make.top.equalTo(beerName.snp.bottom).offset(5)
            make.trailing.equalTo(beerName.snp.trailing)
        }
    }
    
    /// Method to update the labels of the view with the beer details
    ///
    /// - Parameter beerCompact: The beer to update the view for
    func updateValues(beerCompact: BeerCompact) {
        beerImageView.image = beerCompact.beerImage

        let beerNameAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 22),
            .foregroundColor: UIColor.black
        ]
        let beerNameAttributedString = NSAttributedString(string: beerCompact.beerName, attributes: beerNameAttributes)
        beerName.attributedText = beerNameAttributedString
        
        let beerABVAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor.gray
        ]
        let beerABVAttributedString = NSAttributedString(string: "ABV: \(beerCompact.beerABV)", attributes: beerABVAttributes)
        beerABV.attributedText = beerABVAttributedString
    }
}
