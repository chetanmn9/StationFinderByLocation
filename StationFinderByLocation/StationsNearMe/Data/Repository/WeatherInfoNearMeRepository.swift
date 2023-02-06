//
//  WeatherInfoNearMeClientRepository.swift
//  StationFinderByLocation
//
//  Created by ChetanMN on 5/2/2023.
//

import Foundation
import RxSwift

protocol WeatherInfoNearMeRepositoryInterface {
    func getWeatherInfoNearMe(currentLocation: CurrentLocationModel) -> Observable<WeatherInfoNearMeResponse>
}

class WeatherInfoNearMeRepository: WeatherInfoNearMeRepositoryInterface {
    
    private let weatherInfoNearMeClient: WeatherInfoNearMeClientInterface

    init(weatherInfoNearMeClient: WeatherInfoNearMeClientInterface) {
        self.weatherInfoNearMeClient = weatherInfoNearMeClient
    }

    func getWeatherInfoNearMe(currentLocation: CurrentLocationModel) -> Observable<WeatherInfoNearMeResponse> {
        return weatherInfoNearMeClient.getWeatherInfoNearMeClient(currentLocation: currentLocation)
    }
}
