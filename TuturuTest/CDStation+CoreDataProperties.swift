//
//  CDStation+CoreDataProperties.swift
//  TuturuTest
//
//  Created by Артем on 21/10/2016.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import Foundation
import CoreData
//import

extension CDStation {

//    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDStation> {
//        return NSFetchRequest<CDStation>(entityName: "CDStation");
//    }

    @NSManaged public var unique: Int32
    @NSManaged public var name: String?
    @NSManaged public var country: String?
    @NSManaged public var district: String?
    @NSManaged public var region: String?
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var city: CDCity?

}
