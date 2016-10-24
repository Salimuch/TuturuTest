//
//  StationsAPI.swift
//  TuturuTest
//
//  Created by Артем on 22/10/2016.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import CoreData

class PresistanceStoreAPI {
    
//    class var sharedInstance: StationAPI {
//        struct Singleton {
//            static let instance = StationAPI()
//        }
//        return Singleton.instance
//    }
    
    private static let stationsDataUrl = "https://raw.githubusercontent.com/tutu-ru/hire_ios-test/master/allStations.json"
    
    class func getDataAndRecordNewStations(moc: NSManagedObjectContext) {
        let queue = DispatchQueue.global(qos: .userInitiated)
        Alamofire.request(stationsDataUrl).responseJSON(queue: queue) { (response) in
            //                        print(response.request)  // original URL request
            //                        print(response.response) // HTTP URL response
            //                        print(response.data)     // server data
            //                        print(response.result)   // result of response serialization
            //            DispatchQueue.main.async {
            let json = JSON(response.result.value)
            for direction in Station.StationJsonKey.cityDirection {
                let cities = json[direction].arrayValue
                for city in cities {
                    var cStations: [Station] = []
                    let cCity = City(jsonCity: city)
                    let stations = city[Station.StationJsonKey.stationArray].arrayValue
                    for station in stations {
                        let station = Station(jsonStation: station)
                        cStations.append(station)
                    }
                    moc.performAndWait {
                        CDCity.new(cCity, with: cStations, inManagedObjectContext: moc)
                        moc.saveThrows()
                    }
                }
            }
        }
    }
}
