//
//  DepartureWeatherView.swift
//  StationFinderByLocation
//
//  Created by ChetanMN on 3/2/2023.
//

import SwiftUI

struct DepartureWeatherView: View {
    @State var departure = [Departure]()
    @State var currentWeather = String()
    @State var placeName = String()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text(placeName)
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                Text("\(currentWeather)\u{00B0}")
                    .font(.system(size: 36, weight: .bold))
                List {
                    Section(header: Text("Next Depature Time")) {
                        ForEach(departure) { departure in
                            Text(departure.time.dateTimeTransformer(
                                departure: departure.time,
                                datePrefix: 10,
                                timePrefix: 8))
                        }
                    }.headerProminence(.increased)
                }.listStyle(.insetGrouped)
            }.navigationTitle("Station Details")
        }
    }
}

struct DepartureWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        DepartureWeatherView()
    }
}

extension String {
    
    func dateTimeTransformer(departure: String, datePrefix: Int, timePrefix: Int) -> String {
        
        let dateTime = departure.components(separatedBy: "T")
        let date = dateTime[0]
        let time = dateTime[1]
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let dateFormatterSet = DateFormatter()
        dateFormatterSet.dateFormat = "MMM dd, yyyy"
        
        let timeFormatterGet = DateFormatter()
        timeFormatterGet.dateFormat = "HH:mm:ss"
        let timeFormatterSet = DateFormatter()
        timeFormatterSet.dateFormat = "h:mm a"
        
        if let date = dateFormatterGet.date(from: String(date.prefix(datePrefix))),
            let time = timeFormatterGet.date(from: String(time.prefix(timePrefix))) {
            return dateFormatterSet.string(from: date) + "\n" + timeFormatterSet.string(from: time)
        }

        return self
    }
}
