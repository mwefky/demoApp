//
//  NearByModel.swift
//  NearBy App
//
//  Created by mina wefky on 7/10/20.
//  Copyright © 2020 mina wefky. All rights reserved.
//

import Foundation


// MARK: - NearBy
struct NearBy: Codable {
    let meta: Meta
    let response: Response?
}

// MARK: - Meta
struct Meta: Codable {
    let code: Int

    enum CodingKeys: String, CodingKey {
        case code
    }
}

// MARK: - Response
struct Response: Codable {
    let venues: [Venue]?
}

// MARK: - Venue
struct Venue: Codable {
    let name: String
    let location: Location
    let categories: [Category]

    enum CodingKeys: String, CodingKey {
        case name, location, categories
    }
}

// MARK: - Category
struct Category: Codable {
    let name, pluralName, shortName: String
    let icon: Icon
}

// MARK: - Icon
struct Icon: Codable {
    let iconPrefix: String
    let suffix: String

    enum CodingKeys: String, CodingKey {
        case iconPrefix = "prefix"
        case suffix
    }
}

// MARK: - Location
struct Location: Codable {
    let address: String?
    let distance: Int
}



