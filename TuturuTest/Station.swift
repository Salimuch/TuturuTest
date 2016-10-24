//
//  Station.swift
//  TuturuTest
//
//  Created by Артем on 08/10/2016.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class City {
    
    let cityID: Int
    let cityName: String
    let country: String
    let district: String
    let region: String
    let pointLongitude: Double
    let pointLatitude: Double
    
    init(jsonCity: JSON) {
        self.cityID = jsonCity[CityJsonKey.cityID].intValue
        self.cityName = jsonCity[CityJsonKey.cityName].stringValue
        self.country = jsonCity[CityJsonKey.country].stringValue
        self.district = jsonCity[CityJsonKey.district].stringValue
        self.region = jsonCity[CityJsonKey.region].stringValue
        self.pointLongitude = jsonCity[CityJsonKey.point][CityJsonKey.longitude].doubleValue
        self.pointLatitude = jsonCity[CityJsonKey.point][CityJsonKey.latitude].doubleValue
    }
    
    struct CityJsonKey {
        static let cityID = "cityId"
        static let cityName = "cityTitle"
        static let country = "countryTitle"
        static let district = "districtTitle"
        static let region = "regionTitle"
        static let point = "point"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
}


class Station {
    let country: String
    let pointLatitude: Double
    let pointLongitude: Double
    let district: String
    let cityId: Int
    let city: String
    let region: String
    let stationId: Int
    let stationName: String
    
    init(jsonStation: JSON) {
        self.country = jsonStation[StationJsonKey.country].stringValue
        self.pointLatitude = jsonStation[StationJsonKey.point][StationJsonKey.pointLatitude].doubleValue
        self.pointLongitude = jsonStation[StationJsonKey.point][StationJsonKey.pointLongitude].doubleValue
        self.district = jsonStation[StationJsonKey.district].stringValue
        self.cityId = jsonStation[StationJsonKey.cityId].intValue
        self.city = jsonStation[StationJsonKey.city].stringValue
        self.region = jsonStation[StationJsonKey.region].stringValue
        self.stationId = jsonStation[StationJsonKey.stationId].intValue
        self.stationName = jsonStation[StationJsonKey.stationName].stringValue
    }
    
    init?(cdStation: CDStation) {
        self.stationId = Int(cdStation.unique)
        self.stationName = cdStation.name ?? ""
        self.country = cdStation.country ?? ""
        self.region = cdStation.region ?? ""
        self.district = cdStation.district ?? ""
        self.cityId = Int(cdStation.city?.unique ?? 0)
        self.city = cdStation.city?.name ?? ""
        self.pointLatitude = cdStation.latitude
        self.pointLongitude = cdStation.longitude
    }
    
    struct StationJsonKey {
        static let cityDirection = ["citiesFrom", "citiesTo"]
        static let stationArray = "stations"
        
        static let country = "countryTitle"
        static let point = "point"
        static let pointLongitude = "longitude"
        static let pointLatitude = "latitude"
        static let district = "districtTitle"
        static let cityId = "cityId"
        static let city = "cityTitle"
        static let region = "regionTitle"
        static let stationId = "stationId"
        static let stationName = "stationTitle"
    }
}
