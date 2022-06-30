//
//  Presenter.swift
//  CoreDataApp
//
//  Created by Daniil Yarkovenko on 30.06.2022.
//

import Foundation
import CoreData

class Presenter {
    static let instance = Presenter()

    var fetchResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let sortDiscriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDiscriptor]
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                               managedObjectContext: CoreDataManager.instance.context,
                                                               sectionNameKeyPath: nil,
                                                               cacheName: nil)
        return fetchResultController
    }()

}

