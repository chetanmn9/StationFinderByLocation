//
//  WeatherInfoNearMe.swift
//  StationFinderByLocation
//
//  Created by ChetanMN on 5/2/2023.
//

import Foundation

struct WeatherInfoNearMeResponse: Codable {
    let places: [places]
}

struct places: Codable {
    let observations: [observations]
}

struct observations: Codable {
    let place: placeName
    let temperature: Double
}

struct placeName: Codable {
    let address: address
}

struct address: Codable {
    let state: String
    let city: String
}
