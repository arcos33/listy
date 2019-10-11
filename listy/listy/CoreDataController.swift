//
//  CoreDataController.swift
//  listy
//
//  Created by user on 10/11/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataController {
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchRecords() -> [Individual] {
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
    
    func saveRecord(id: Int,
                                                name: String,
                                                birthdate: String,
                                                imageData: NSData,
                                                imageURL: String,
                                                forceSensitive: Bool,
                                                affiliation: String) {
        if let individualEntity = NSEntityDescription.entity(forEntityName: "Individual", in: context) {
            let individual = NSManagedObject(entity: individualEntity, insertInto: context)
            individual.setValue(id, forKey: "id")
            individual.setValue(name, forKey: "name")
            individual.setValue(birthdate, forKey: "birthdate")
            individual.setValue(imageData, forKey: "profilePicture")
            individual.setValue(imageURL, forKey: "imageURL")
            individual.setValue(forceSensitive, forKey: "forceSensitive")
            individual.setValue(affiliation, forKey: "affiliation")
            
            do {
                try context.save()
                NotificationCenter.default.post(name: .didFinishSavingObject, object: nil, userInfo: nil)
            } catch let error as NSError {
                print("Could not save: \(error), \(error.userInfo)")
            }
        }
    }
}
