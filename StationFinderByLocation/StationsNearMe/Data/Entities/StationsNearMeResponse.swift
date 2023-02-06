//
//  StationsNearMeResponse.swift
//  StationFinderByLocation
//
//  Created by ChetanMN on 2/2/2023.
//


import Foundation

struct StationsNearMeResponse: Codable {
    let boards: [boards]
}

struct boards: Codable {
    let place: place?
    let departures: [departures]
}

struct place: Codable {
    let name: String
}

struct departures: Codable {
    let time: String
}
