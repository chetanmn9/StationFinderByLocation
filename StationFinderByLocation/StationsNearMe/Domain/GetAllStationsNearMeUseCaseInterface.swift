//
//  GetAllStationsNearMeUseCaseInterface.swift
//  StationFinderByLocation
//
//  Created by ChetanMN on 2/2/2023.
//

import RxSwift
import Swinject

protocol GetAllStationsNearMeUseCaseInterface {
    func execute(currentLocation: CurrentLocationModel) -> Observable<[StationsNearMe]>
    
    func executeWeatherInfoNearMe(currentLocation: CurrentLocationModel) -> Observable<[WeatherInfoNearMe]>
    
}

class GetAllStationsNearMeUseCase: GetAllStationsNearMeUseCaseInterface {
    
    let stationsNearMeRepository: StationsNearMeRepositoryInterface
    let weatherInfoNearMeRepositoryInterface: WeatherInfoNearMeRepositoryInterface

    init(stationsNearMeRepository: StationsNearMeRepositoryInterface,
         weatherInfoNearMeRepositoryInterface: WeatherInfoNearMeRepositoryInterface) {
        self.stationsNearMeRepository = stationsNearMeRepository
        self.weatherInfoNearMeRepositoryInterface = weatherInfoNearMeRepositoryInterface
    }

    func execute(currentLocation: CurrentLocationModel) -> Observable<[StationsNearMe]> {
        
        
        return stationsNearMeRepository.allStationsNearMe(currentLocation: currentLocation).map({
            var stationsNearMe = [StationsNearMe]()
            var nextDepartures = [Departure]()
            
            
            for (_, item) in $0.boards.enumerated() {
                for (_, dep) in item.departures.enumerated() {
                    nextDepartures.append(Departure(time: dep.time))
                }
                stationsNearMe.append(StationsNearMe(stationName: item.place?.name ?? "No Value",
                                                     nextDepartures: nextDepartures)
            )}
            return stationsNearMe
        })
        
    }
    
    func executeWeatherInfoNearMe(currentLocation: CurrentLocationModel) -> Observable<[WeatherInfoNearMe]> {
        
        return weatherInfoNearMeRepositoryInterface.getWeatherInfoNearMe(currentLocation: currentLocation).map({
            var weatherInfoNearMe = [WeatherInfoNearMe]()
            for place in $0.places {
                for observation in place.observations {
                    weatherInfoNearMe.append(WeatherInfoNearMe(city: observation.place.address.city,
                                                               state: observation.place.address.state,
                                                               weather: String(Int(observation.temperature))))
                }
            }
            return weatherInfoNearMe
        })
    }
}

