//
//  StationNearMeTableViewController.swift
//  StationFinderByLocation
//
//  Created by ChetanMN on 2/2/2023.
//

import Foundation
import UIKit
import CoreLocation
import SwiftUI
import Swinject

protocol StationsNearMeViewControllerDelegate {
    func StationsNearMeViewControllerDidGetAllStations(stationsNearMe: [StationsNearMe])
    
    func WeatherInfoNearMeViewControllerDidWeatherInfo(weatherNearMe: [WeatherInfoNearMe])
}

class StationsNearMeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    let cellID = "cellID"
    let tableTitle = "Stations Near Me"
    var stationsNearMe = [StationsNearMe]() {
        didSet {
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    var weatherInfoNearMe = [WeatherInfoNearMe]()
    
    let container = Container()
    var activityIndicator = UIActivityIndicatorView(style: .large)

    private var viewModel: StationsNearMeViewModelInterface
    private var currentLocation: CurrentLocationModel
    
    init(viewModel: StationsNearMeViewModelInterface,
         currentLocation: CurrentLocationModel) {
        self.viewModel = viewModel
        self.currentLocation = currentLocation

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        viewModel.delegate = self
        
        self.title = tableTitle.localizedCapitalized
        activityIndicator.startAnimating()
        viewModel.getWeatherAndStationsInfoNearMe(currentLocation: currentLocation)
        setupTableView()
        
        container.register(StationsNearMeViewModelInterface.self, factory: { resolver in
            return StationsNearMeViewModel(getAllStationsNearMeUseCase: resolver.resolve(StationsNearMeViewModelInterface.self) as! GetAllStationsNearMeUseCase)
            })
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.view.tintColor = UIColor.black
    }
    
    func setupTableView() {
         view.addSubview(tableView)
        
        let nib = UINib(nibName: "StationNearMeTableViewCell", bundle: Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: cellID )

         tableView.allowsSelection = true
         tableView.isUserInteractionEnabled = true
         tableView.translatesAutoresizingMaskIntoConstraints = false
         tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
         tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
         tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
         tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
     }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationsNearMe.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as? StationNearMeTableViewCell else {
            fatalError()
        }
        let item = stationsNearMe[indexPath.row]
        cell.stationsNearMe = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIHostingController(rootView: DepartureWeatherView(
            departure: stationsNearMe[indexPath.row].nextDepartures,
            currentWeather: weatherInfoNearMe[0].weather,
            placeName: "\(weatherInfoNearMe[0].city), \(weatherInfoNearMe[0].state)"))
        present(vc, animated: true)
    }
}

extension StationsNearMeTableViewController: StationsNearMeViewControllerDelegate {
    
    func StationsNearMeViewControllerDidGetAllStations(stationsNearMe: [StationsNearMe]) {
        self.stationsNearMe = stationsNearMe
    }
    
    func WeatherInfoNearMeViewControllerDidWeatherInfo(weatherNearMe: [WeatherInfoNearMe]) {
        self.weatherInfoNearMe = weatherNearMe
    }
}



