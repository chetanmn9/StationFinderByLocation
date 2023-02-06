//
//  WeatherInfoNearMe.swift
//  StationFinderByLocation
//
//  Created by ChetanMN on 5/2/2023.
//

import Foundation
import RxSwift
import CoreLocation

protocol WeatherInfoNearMeClientInterface {
    func getWeatherInfoNearMeClient(currentLocation: CurrentLocationModel) -> Observable<WeatherInfoNearMeResponse>
}

class WeatherInfoNearMeClient: WeatherInfoNearMeClientInterface {
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()

    func getWeatherInfoNearMeClient(currentLocation: CurrentLocationModel) -> Observable<WeatherInfoNearMeResponse> {
        Observable<WeatherInfoNearMeResponse>.create { observer in
            guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "WEATHER_NEAR_ME_API_KEY") as? String else {
                observer.onError(NetworkError.genericError)
                return Disposables.create()
                
            }
            guard let url = URL(string: "https://weather.hereapi.com/v3/report?products=observation&apiKey=\(apiKey)&location=\(currentLocation.coordinates.latitude),\(currentLocation.coordinates.longitude)") else {
                observer.onError(NetworkError.genericError)
                return Disposables.create()
            }
            
            let request = URLRequest(url: url)

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    let response = try JSONDecoder().decode(WeatherInfoNearMeResponse.self, from: data ?? Data())
                    observer.onNext(response)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}
