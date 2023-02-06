//
//  ViewController.swift
//  StationFinderByLocation
//
//  Created by ChetanMN on 2/2/2023.
//

import UIKit
import CoreLocation
import Swinject

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let container = Container()
    var currentLocation: CurrentLocationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        let findStationsNearMeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 220, height: 50))
        view.addSubview(findStationsNearMeButton)
        findStationsNearMeButton.center = view.center
        findStationsNearMeButton.setTitle("Find stations near me", for: .normal)
        findStationsNearMeButton.backgroundColor = .systemBlue
        findStationsNearMeButton.addTarget(self, action: #selector(didTapFindStationsByLocation), for: .touchUpInside)
        findStationsNearMeButton.layer.cornerRadius = 25
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.startUpdatingLocation()
            }
        }
                
        container.register(StationsNearMeClientInterface.self) { _ in
            return StationsNearMeClient()
        }
        
        container.register(WeatherInfoNearMeClientInterface.self) { _ in
            return WeatherInfoNearMeClient()
        }

        container.register(StationsNearMeRepositoryInterface.self) { resolver in
            return StationsNearMeRepository(stationsNearMeClient: resolver.resolve(StationsNearMeClientInterface.self)!)
        }
        
        container.register(WeatherInfoNearMeRepositoryInterface.self) { resolver in
            return WeatherInfoNearMeRepository(weatherInfoNearMeClient: resolver.resolve(WeatherInfoNearMeClientInterface.self)!)
        }

        container.register(GetAllStationsNearMeUseCaseInterface.self) { resolver in
            return GetAllStationsNearMeUseCase(stationsNearMeRepository: resolver.resolve(StationsNearMeRepositoryInterface.self)!, weatherInfoNearMeRepositoryInterface: resolver.resolve(WeatherInfoNearMeRepositoryInterface.self)!)
        }

        container.register(StationsNearMeViewModelInterface.self) { resolver in
            return StationsNearMeViewModel(getAllStationsNearMeUseCase: resolver.resolve(GetAllStationsNearMeUseCaseInterface.self) as! GetAllStationsNearMeUseCase)
        }
        currentLocation = getCurrentlocation()
        container.register(StationsNearMeTableViewController.self) { resolver in
            let vc = StationsNearMeTableViewController(viewModel: resolver.resolve(StationsNearMeViewModelInterface.self)!, currentLocation: self.currentLocation!)
            return vc
        }
    }
    
    
    @objc func didTapFindStationsByLocation() {

        if currentLocation == nil {
            let alert = UIAlertController(title: "Alert", message: "We cannot find near by Station, please share your current location.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard let vc = container.resolve(StationsNearMeTableViewController.self) else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getCurrentlocation() -> CurrentLocationModel? {
        let currentLocation = CurrentLocationModel(coordinates: CLLocationManager().location!.coordinate)
        return currentLocation
    }

}

