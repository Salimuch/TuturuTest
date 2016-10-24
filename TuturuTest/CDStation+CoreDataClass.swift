//
//  CDStation+CoreDataClass.swift
//  TuturuTest
//
//  Created by Артем on 21/10/2016.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import Foundation
import CoreData


public class CDStation: NSManagedObject {
    
    class func stations(with city: CDCity, inManagedObjectContext context: NSManagedObjectContext) -> [CDStation]? {
        // Возвращает все станции, которые ссылаются на город
        let request = NSFetchRequest<CDStation>(entityName: "CDStation")
        request.predicate = NSPredicate(format: "city.unique = %ld", city.unique)
        
        if let stations = (try? context.fetch(request)) {
            return stations
        }
        return nil
    }
    
    class func new(_ station: Station,
                          with city: CDCity,
                          inManageObjectContext context: NSManagedObjectContext) -> CDStation?
    {
        // Создает новую станцию, со ссылкой на указанный город
        let request = NSFetchRequest<CDStation>(entityName: "CDStation")
        request.predicate = NSPredicate(format: "unique = %ld", Int32(station.stationId))
        
        if let cdStation = (try? context.fetch(request))?.first {
            return cdStation
        } else if let cdStation = NSEntityDescription.insertNewObject(forEntityName: "CDStation",
                                                                    into: context) as? CDStation {
            cdStation.name = station.stationName
            cdStation.unique = Int32(station.stationId)
            cdStation.country = station.country
            cdStation.district = station.district
            cdStation.region = station.region
            cdStation.longitude = station.pointLongitude
            cdStation.longitude = station.pointLatitude
            cdStation.city = city
            
            return cdStation
        }
        
        return nil
    }

    class func new(_ stations: [Station],
                                   with city: CDCity,
                                   inManageObjectContext context: NSManagedObjectContext)
    {
        // Создает новые станции, со ссылкой на указанный город
        let request = NSFetchRequest<CDStation>(entityName: "CDStation")
        let newStations = stations.map {$0.stationId}
        var newSet = Set (newStations)
        request.predicate = NSPredicate(format: "unique IN %@", newSet)
        
        let results = try? context.fetch(request)
        
        if let cdStations = results {
            let uniques = cdStations.flatMap({ Int($0.unique) })
            let uniquesSet = Set(uniques)
            
            newSet.subtract(uniquesSet)
            
            for unique in newSet {
                if let index = stations.index(where: { $0.stationId == unique }) {
                    // создаем новую станцию
                    _ = CDStation.new(stations[index],
                                                          with: city,
                                                          inManageObjectContext: context)
                    
                }
            }
        }
    }
}
