//
//  CDCity+CoreDataProperties.swift
//  TuturuTest
//
//  Created by Артем on 21/10/2016.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import Foundation
import CoreData
//import

extension CDCity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCity> {
        return NSFetchRequest<CDCity>(entityName: "CDCity");
    }

    @NSManaged public var country: String?
    @NSManaged public var district: String?
    @NSManaged public var unique: Int32
    @NSManaged public var name: String?
    @NSManaged public var region: String?
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var stations: NSSet?

}

// MARK: Generated accessors for stations
extension CDCity {

    @objc(addStationsObject:)
    @NSManaged public func addToStations(_ value: CDStation)

    @objc(removeStationsObject:)
    @NSManaged public func removeFromStations(_ value: CDStation)

    @objc(addStations:)
    @NSManaged public func addToStations(_ values: NSSet)

    @objc(removeStations:)
    @NSManaged public func removeFromStations(_ values: NSSet)

}
