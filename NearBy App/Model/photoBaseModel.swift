//
//  photoBaseModel.swift
//  NearBy App
//
//  Created by mina wefky on 7/11/20.
//  Copyright © 2020 mina wefky. All rights reserved.
//

import Foundation

// MARK: - PhotoBaseModel
struct PhotoBaseModel: Codable {
    let response: PhotoResponse
}

// MARK: - Response
struct PhotoResponse: Codable {
    let photos: Photos
}

// MARK: - Photos
struct Photos: Codable {
    let count: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let itemPrefix: String
    let suffix: String
    let width, height: Int
    let user: User

    enum CodingKeys: String, CodingKey {
        case itemPrefix = "prefix"
        case suffix, width, height, user
    }
}

// MARK: - User
struct User: Codable {
    let id, firstName, lastName: String
    let photo: Photo
}

// MARK: - Photo
struct Photo: Codable {
    let photoPrefix: String
    let suffix: String

    enum CodingKeys: String, CodingKey {
        case photoPrefix = "prefix"
        case suffix
    }
}
