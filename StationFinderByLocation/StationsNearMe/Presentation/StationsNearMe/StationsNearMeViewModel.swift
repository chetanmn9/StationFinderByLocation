//
//  StationsNearMeViewModel.swift
//  StationFinderByLocation
//
//  Created by ChetanMN on 2/2/2023.
//

import Foundation
import RxSwift
import CoreLocation


protocol StationsNearMeViewModelInterface {
    
    func getWeatherAndStationsInfoNearMe(currentLocation: CurrentLocationModel)
    
    var delegate: StationsNearMeViewControllerDelegate? { get set }
    
}

class StationsNearMeViewModel: StationsNearMeViewModelInterface {
    
    var delegate: StationsNearMeViewControllerDelegate?
    private let getAllStationsNearMeUseCase: GetAllStationsNearMeUseCase
    private let disposeBag = DisposeBag()
    
    var StationsNearMeModel: [StationsNearMe] = []
    
    init(getAllStationsNearMeUseCase: GetAllStationsNearMeUseCase) {
        self.getAllStationsNearMeUseCase = getAllStationsNearMeUseCase
    }
    
    func getWeatherAndStationsInfoNearMe(currentLocation: CurrentLocationModel) {
        disposeBag.insert(
            Observable.zip(getAllStationsNearMeUseCase.execute(currentLocation: currentLocation), getAllStationsNearMeUseCase.executeWeatherInfoNearMe(currentLocation: currentLocation))
                .observe(on: MainScheduler.instance)
                .subscribe(
                    onNext: { [weak self] (stationsNearMe, weatherInfoNearMe) in
                        guard let self = self else { return }
                        self.delegate?.StationsNearMeViewControllerDidGetAllStations(stationsNearMe: stationsNearMe)
                        self.delegate?.WeatherInfoNearMeViewControllerDidWeatherInfo(weatherNearMe: weatherInfoNearMe)
                    }
                )
        )
    }
}
