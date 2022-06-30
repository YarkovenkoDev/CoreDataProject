//
//  User+CoreDataClass.swift
//  CoreDataApp
//
//  Created by Daniil Yarkovenko on 30.06.2022.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "User"), insertInto: CoreDataManager.instance.context)
    }
}
