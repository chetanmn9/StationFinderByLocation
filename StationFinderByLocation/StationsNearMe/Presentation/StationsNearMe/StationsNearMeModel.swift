//
//  StationsNearMeModel.swift
//  StationFinderByLocation
//
//  Created by ChetanMN on 2/2/2023.
//

import Foundation
import UIKit

public struct StationsNearMe {
    
    var stationName: String
    var nextDepartures: [Departure]
    
    
}

public struct Departure: Identifiable {
    public let id = UUID()
    var time: String
}

public struct WeatherInfoNearMe {
    
    var city: String
    var state: String
    var weather: String
    
}
