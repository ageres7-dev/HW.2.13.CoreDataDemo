//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Сергей on 24.11.2020.
//

import Foundation
import CoreData

class StorageManager {
    static let delegate = StorageManager()
    
    private init() {}
    
    var context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container.viewContext
    }()
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData() -> [Task] {
        var result: [Task] = []
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            result = try context.fetch(fetchRequest)
        } catch let error {
            print(error)
        }
        return result
    
    }
    
    func newTask(_ taskName: String) -> Task {
        //тут я прям совсем не уверен, что в случае ошибки возвращать { return Task() }
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return Task() }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return Task()}
        task.name = taskName
        
        return task
    }
    
    func removeTask(_ task:Task) {
        context.delete(task)
        saveContext()
    }
    
}
