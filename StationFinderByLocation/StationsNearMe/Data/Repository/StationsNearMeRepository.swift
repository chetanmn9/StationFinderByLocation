//
//  StationsNearMeRepository.swift
//  StationFinderByLocation
//
//  Created by ChetanMN on 2/2/2023.
//

import Foundation
import RxSwift
import CoreLocation

protocol StationsNearMeRepositoryInterface {
    func allStationsNearMe(currentLocation: CurrentLocationModel) -> Observable<StationsNearMeResponse>
}

class StationsNearMeRepository: StationsNearMeRepositoryInterface {
    private let stationsNearMeClient: StationsNearMeClientInterface

    init(stationsNearMeClient: StationsNearMeClientInterface) {
        self.stationsNearMeClient = stationsNearMeClient
    }

    func allStationsNearMe(currentLocation: CurrentLocationModel) -> Observable<StationsNearMeResponse> {
        return stationsNearMeClient.getAllStationsNearMe(currentLocation: currentLocation)
    }
}
