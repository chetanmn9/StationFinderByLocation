//
//  StationsNearMeClient.swift
//  StationFinderByLocation
//
//  Created by ChetanMN on 2/2/2023.
//

import Foundation
import RxSwift
import CoreLocation

protocol StationsNearMeClientInterface {
    func getAllStationsNearMe(currentLocation: CurrentLocationModel) -> Observable<StationsNearMeResponse>
}

class StationsNearMeClient: StationsNearMeClientInterface {
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()

    func getAllStationsNearMe(currentLocation: CurrentLocationModel) -> Observable<StationsNearMeResponse> {
        Observable<StationsNearMeResponse>.create { observer in
            guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "STATIONS_NEAR_ME_API_KEY") as? String else {
                observer.onError(NetworkError.genericError)
                return Disposables.create()
                
            }
            guard let url = URL(string: "https://transit.hereapi.com/v8/departures?in=\(currentLocation.coordinates.latitude),\(currentLocation.coordinates.longitude);r=500&apiKey=\(apiKey)") else {  
                observer.onError(NetworkError.genericError)
                return Disposables.create()
            }
            
            let request = URLRequest(url: url)

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    let response = try JSONDecoder().decode(StationsNearMeResponse.self, from: data ?? Data())
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


public enum NetworkError: Error {
    case genericError
}
