//
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by Estevan Feliz on 4/12/18.
//  Copyright © 2018 Feliz Studios. All rights reserved.
//

import Foundation

class WeatherLocation: Codable {
    var name: String
    var coordinates: String
    
    init(name: String, coordinates: String) {
        self.name = name
        self.coordinates = coordinates
    }
}
