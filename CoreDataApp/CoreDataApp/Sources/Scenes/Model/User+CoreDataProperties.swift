//
//  User+CoreDataProperties.swift
//  CoreDataApp
//
//  Created by Daniil Yarkovenko on 30.06.2022.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var birthday: String?
    @NSManaged public var gender: String?
    @NSManaged public var image: Data?
    @NSManaged public var name: String?

}

extension User : Identifiable {

}
