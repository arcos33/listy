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
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Individual")
    
    func fetchRecordsWith(_ context: NSManagedObjectContext) -> [Individual] {
        var individualRecords = [Individual]()
        
        do {
            request.returnsObjectsAsFaults = false
            if let result = try context.fetch(request) as? [Individual] {
                individualRecords = result
            }
        } catch let error as NSError {
            print("Failed to fetch records: \(error): \(error.userInfo)")
        }
        
        return individualRecords
    }
    
    func saveRecordWith(context: NSManagedObjectContext,
                    id: Int,
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
    
    func getCountWith(_ context: NSManagedObjectContext) -> Int {
        var result = 0
        
        do {
            request.returnsObjectsAsFaults = false
            result = try context.count(for: request)
        } catch let error as NSError {
            print("Error getting count: \(error): \(error.userInfo)")
        }
        
        return result
    }
    
    private func getContext(completion: @escaping (NSManagedObjectContext) -> ()) {
        DispatchQueue.main.async {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            completion(delegate.persistentContainer.viewContext)
        }
    }
}
