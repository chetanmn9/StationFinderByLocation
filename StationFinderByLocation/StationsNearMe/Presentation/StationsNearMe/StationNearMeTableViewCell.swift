//
//  StationNearMeTableViewCelll.swift
//  StationFinderByLocation
//
//  Created by ChetanMN on 5/2/2023.
//

import UIKit

class StationNearMeTableViewCell: UITableViewCell {
    
    var stationsNearMe : StationsNearMe? {
        didSet {
            stationName.text = stationsNearMe?.stationName
        }
    }
    
    @IBOutlet weak var stationName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stationName.textColor = .black
        stationName.font = UIFont.boldSystemFont(ofSize: 16)
        stationName.lineBreakMode = .byWordWrapping
        stationName.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
        stationName.contentMode = .scaleToFill
        stationName.textAlignment = .left
        stationName.numberOfLines = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

