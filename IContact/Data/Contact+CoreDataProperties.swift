//
//  Contact+CoreDataProperties.swift
//  IContact
//
//  Created by yunus on 19.11.2024.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var surname: String?

}

extension Contact : Identifiable {

}
