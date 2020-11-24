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
    
    // MARK: - Core Data stack
//    var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "CoreDataDemo")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
    
   
    var context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container.viewContext
    }()
    
    
    // MARK: - Core Data Saving support
    func saveContext() {
//        let context = persistentContainer.viewContext
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
//        let context = persistentContainer.viewContext
        var result: [Task] = []
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            result = try context.fetch(fetchRequest)
//            tasks = try context.fetch(fetchRequest)
//            tableView.reloadData()
        } catch let error {
            print(error)
        }
        return result
    }
    
    
    func newTask(_ taskName: String) -> Task{
//        let context = persistentContainer.viewContext
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return Task() }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return Task()}
        
        task.name = taskName
//        tasks.append(task)
        
//        let cellIndex = IndexPath(row: tasks.count - 1, section: 0)
//        tableView.insertRows(at: [cellIndex], with: .automatic)
        
        //????????????????
        /*
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
        */
//        saveContext()
        return task
    }
    
    
    
}
