//
//  CoreDataController.swift
//  listy
//
//  Created by user on 10/11/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import CoreData

class CoreDataController {
    static func fetchIndividualRecordsWithContext(_ context: NSManagedObjectContext) -> [Individual] {
        var individualRecords = [Individual]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Individual")
        request.returnsObjectsAsFaults = false
        do {
            if let result = try context.fetch(request) as? [Individual] {
                individualRecords = result
            }
        } catch let error as NSError {
            print("Failed to fetch records: \(error): \(error.userInfo)")
        }
        return individualRecords
    }
}
