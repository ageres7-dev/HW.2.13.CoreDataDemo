//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Alexey Efimov on 23.11.2020.
//

import UIKit
//import CoreData

class TaskListViewController: UITableViewController {
    
//    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    private let context = StorageManager.delegate.persistentContainer.viewContext
    
    
    private let cellID = "cell"
    private var tasks: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        view.backgroundColor = .white
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }

    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func addNewTask() {
        /*
        let newTaskVC = NewTaskViewController()
        newTaskVC.modalPresentationStyle = .fullScreen
        present(newTaskVC, animated: true)
        */
        showAlert(withTitle: "Add New Task", andMessage: "What do you want to do?")
    }
    
    private func fetchData() {
       /*
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            tasks = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error {
            print(error)
        }
 */
        tasks = StorageManager.delegate.fetchData()
        tableView.reloadData()
    }
    
    private func showAlert(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            self.save(task)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func save(_ taskName: String) {
        /*
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return }
        
        task.name = taskName
        */
        
        
        tasks.append(StorageManager.delegate.newTask(taskName))
        
        let cellIndex = IndexPath(row: tasks.count - 1, section: 0)
        tableView.insertRows(at: [cellIndex], with: .automatic)
        /*
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
        */
        StorageManager.delegate.saveContext()
    }

}

// MARK: - Table view data source
extension TaskListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = tasks[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.name
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - Table view delegate
extension TaskListViewController {
    
    
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let currenTask = tasks.remove(at: sourceIndexPath.row)
        tasks.insert(currenTask, at: destinationIndexPath.row)
        //обновть целеком или удалить и добавить целеком
        StorageManager.delegate.saveContext()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, _, completion) in
            print("edit")
            
            let task = self.tasks[indexPath.row]
            self.showAlert(withTitle: "Edit Task", andMessage: "What do you want to do?")
            
            
            
            completion(true)
        }
        
        let delete = UIContextualAction(style: .destructive, title: "delete") { (action, _, completion) in
            print("delete")
            let task = self.tasks.remove(at: indexPath.row)
        
            tableView.deleteRows(at: [indexPath], with: .automatic)
            StorageManager.delegate.removeTask(task)
            
            completion(true)
        }
        
        let config = UISwipeActionsConfiguration(actions: [delete, edit])
//        config.performsFirstActionWithFullSwipe = false
        return config
    }
    /*
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            let task = tasks.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            StorageManager.delegate.removeTask(task)
        }
    }
    */
    
    
    
}
