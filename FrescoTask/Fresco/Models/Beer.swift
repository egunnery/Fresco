//
//  Beer.swift
//  Fresco
//
//  Created by Eoin Gunnery on 26/09/2022.
//

import Foundation
import UIKit

// BeerCompact
struct BeerCompact {
    let beerName: String
    let beerImage: UIImage
    let beerABV: Double
    
    init(beerName: String, beerImage: UIImage, beerABV: Double) {
        self.beerName = beerName
        self.beerImage = beerImage
        self.beerABV = beerABV
    }
}

// MARK: - Beer
public struct Beer: Codable {
    public let id: Int
    public let name: String
    public let tagline: String
    public let firstBrewed: String
    public let description: String
    public let imageURL: String
    public let abv: Double
    public let ibu: Double?
    public let targetFg: Int
    public let targetOg: Double
    public let ebc: Int?
    public let srm: Double?
    public let ph: Double?
    public let attenuationLevel: Double
    public let volume: Volume
    public let boilVolume: Volume
    public let method: Method
    public let ingredients: Ingredients
    public let foodPairing: [String]
    public let brewersTips: String
    public let contributedBy: ContributedBy

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case tagline
        case firstBrewed = "first_brewed"
        case description
        case imageURL = "image_url"
        case abv
        case ibu
        case targetFg = "target_fg"
        case targetOg = "target_og"
        case ebc
        case srm
        case ph
        case attenuationLevel = "attenuation_level"
        case volume
        case boilVolume = "boil_volume"
        case method
        case ingredients
        case foodPairing = "food_pairing"
        case brewersTips = "brewers_tips"
        case contributedBy = "contributed_by"
    }
    
    /// An initialiser that attempts to decode the property.
    ///
    /// - Parameter decoder: The decoder.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

    id = try container.decode(Int.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
    tagline = try container.decode(String.self, forKey: .tagline)
    firstBrewed = try container.decode(String.self, forKey: .firstBrewed)
    description = try container.decode(String.self, forKey: .description)
    imageURL = try container.decode(String.self, forKey: .imageURL)
    abv = try container.decode(Double.self, forKey: .abv)
    ibu = try? container.decode(Double.self, forKey: .ibu)
    targetFg = try container.decode(Int.self, forKey: .targetFg)
    targetOg = try container.decode(Double.self, forKey: .targetOg)
    ebc = try? container.decode(Int.self, forKey: .ebc)
    srm = try? container.decode(Double.self, forKey: .srm)
    ph = try? container.decode(Double.self, forKey: .ph)
    attenuationLevel = try container.decode(Double.self, forKey: .attenuationLevel)
    volume = try container.decode(Volume.self, forKey: .volume)
    boilVolume = try container.decode(Volume.self, forKey: .boilVolume)
    method = try container.decode(Method.self, forKey: .method)
    ingredients = try container.decode(Ingredients.self, forKey: .ingredients)
    foodPairing = try container.decode([String].self, forKey: .foodPairing)
    brewersTips = try container.decode(String.self, forKey: .brewersTips)
    contributedBy = try container.decode(ContributedBy.self, forKey: .contributedBy)
    }
    
    #if DEBUG
    public init() {
        self.id = 1
        self.name = "name"
        self.tagline = "tagline"
        self.firstBrewed = "first brewed"
        self.description = "description"
        self.imageURL = "imageURL"
        self.abv = 1.0
        self.ibu = 1.0
        self.targetFg = 1
        self.targetOg = 1.0
        self.ebc = nil
        self.srm = nil
        self.ph = nil
        self.attenuationLevel = 1.0
        self.volume = Volume(value: 1.0, unit: .kilograms)
        self.boilVolume = Volume(value: 1.0, unit: .kilograms)
        self.method = Method(mashTemp: [], fermentation: Fermentation(temp: Volume(value: 1.0, unit: .kilograms)), twist: nil)
        let malt = Malt(name: "Malt", amount: Volume(value: 1.0, unit: .kilograms))
        let hop = Hop(name: "Hop", amount: Volume(value: 1.0, unit: .kilograms), add: .dryHop, attribute: .aroma)
        self.ingredients = Ingredients(malt: [malt], hops: [hop], yeast: "yeast")
        self.foodPairing = []
        self.brewersTips = "tips"
        self.contributedBy = .aliSkinnerAliSkinner
    }
    #endif
}

// MARK: - Volume
public struct Volume: Codable {
    public let value: Double
    public let unit: Unit
}

public enum Unit: String, Codable {
    case celsius = "celsius"
    case grams = "grams"
    case kilograms = "kilograms"
    case litres = "litres"
}


public enum ContributedBy: String, Codable {
    case aliSkinnerAliSkinner = "Ali Skinner <AliSkinner>"
    case samMasonSamjbmason = "Sam Mason <samjbmason>"
}

// MARK: - Ingredients
public struct Ingredients: Codable {
    public let malt: [Malt]
    public let hops: [Hop]
    public let yeast: String
}

protocol Ingredient {
    var name: String { get }
    var amount: Volume { get }
}

// MARK: - Hop
public struct Hop: Codable {
    public let name: String
    public let amount: Volume
    public let add: Add
    public let attribute: Attribute
}

extension Hop: Ingredient {}

// MARK: - Malt
public struct Malt: Codable {
    public let name: String
    public let amount: Volume
}

extension Malt: Ingredient {}

public enum Add: String, Codable {
    case dryHop = "dry hop"
    case end = "end"
    case middle = "middle"
    case start = "start"
}

public enum Attribute: String, Codable {
    case aroma = "aroma"
    case attributeFlavour = "Flavour"
    case bitter = "bitter"
    case flavour = "flavour"
}

// MARK: - Method
public struct Method: Codable {
    public let mashTemp: [MashTemp]
    public let fermentation: Fermentation
    public let twist: String?

    enum CodingKeys: String, CodingKey {
        case mashTemp = "mash_temp"
        case fermentation
        case twist
    }
}

// MARK: - Fermentation
public struct Fermentation: Codable {
    public let temp: Volume
}

// MARK: - MashTemp
public struct MashTemp: Codable {
    public let temp: Volume
    public let duration: Int?
}

