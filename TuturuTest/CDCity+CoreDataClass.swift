//
//  CDCity+CoreDataClass.swift
//  TuturuTest
//
//  Created by Артем on 21/10/2016.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import Foundation
import CoreData


public class CDCity: NSManagedObject {
    
    class func new(_ city: City, inManagedObjectContext context: NSManagedObjectContext) -> CDCity? {
        // Создает новый город, без массива станций.
        let request = NSFetchRequest<CDCity>(entityName: "CDCity")
        request.predicate = NSPredicate(format: "unique = %ld", Int32(city.cityID))
        
        if let cdCity = (try? context.fetch(request))?.first {
            return cdCity
        } else if let cdCity = NSEntityDescription.insertNewObject(forEntityName: "CDCity",
                                                                   into: context) as? CDCity {
            cdCity.unique = Int32(city.cityID)
            cdCity.name = city.cityName
            cdCity.country = city.country
            cdCity.region = city.region
            cdCity.district = city.district
            cdCity.latitude = city.pointLatitude
            cdCity.longitude = city.pointLongitude
            return cdCity
        }
        return nil
    }
    
    class func new(_ city: City, with stations: [Station], inManagedObjectContext context: NSManagedObjectContext) {
        // Создает новый город с массивом станций
        let request = NSFetchRequest<CDCity>(entityName: "CDCity")
        request.predicate = NSPredicate(format: "unique = %ld", Int32(city.cityID))
        
        if let cdCity = (try? context.fetch(request))?.first {
            // пытаемся добавить станции и подвязать их к городу
            CDStation.new(stations, with: cdCity, inManageObjectContext: context)
        } else {
            // Добавляем город
            if let cdCity = CDCity.new(city, inManagedObjectContext: context) {
                // Добавляем станции с этим городом
                CDStation.new(stations, with: cdCity, inManageObjectContext: context)
            }
        }
    }

}
