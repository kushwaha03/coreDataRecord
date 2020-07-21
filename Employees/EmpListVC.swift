//
//  EmpListVC.swift
//  Quotes
//
//  Created by Sumit Bangarwa on 11/6/19.
//  Copyright © 2019 Cocoacasts. All rights reserved.
//

import UIKit
import CoreData

class EmpListVC: UIViewController {
    
    
    private let SegueAddEmpViewController = "SegueAddEmpViewController"
    
    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
   
    
    private let persistentContainer = NSPersistentContainer(name: "Employees")
    
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Employee> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = " Employee List"

        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
                
            } else {
                self.setupView()
                
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
                
                self.updateView()
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueAddEmpViewController {
            if let destinationViewController = segue.destination as? AddEmpVC {
                // Configure View Controller
                destinationViewController.managedObjectContext = persistentContainer.viewContext
            }
        }
    }
    
    // MARK: - View Methods
    
    private func setupView() {
        setupMessageLabel()
        
        updateView()
    }
    
    fileprivate func updateView() {
        var hasrecords = false
        
        if let records = fetchedResultsController.fetchedObjects {
            hasrecords = records.count > 0
        }
        
        tableView.isHidden = !hasrecords
        messageLabel.isHidden = hasrecords
        
        activityIndicatorView.stopAnimating()
    }
    
    // MARK: -
    
    private func setupMessageLabel() {
        messageLabel.text = "You don't have any data yet."
    }
    
    // MARK: - Notification Handling
    
    @objc func applicationDidEnterBackground(_ notification: Notification) {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Unable to Save Changes")
            print("\(error), \(error.localizedDescription)")
        }
    }
    
}

extension EmpListVC: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        
        updateView()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        default:
            print("...")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
    }
    
}

extension EmpListVC: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let record = fetchedResultsController.fetchedObjects else { return 0 }
        return record.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? EmployeeCell else {
            fatalError("Unexpected Index Path")
        }
        
        // Fetch record
        let record = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        cell.nmLabel.text = record.name
        cell.emailLabel.text = record.email
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EmpDetailsVC") as? EmpDetailsVC
        let record = fetchedResultsController.object(at: indexPath)

        vc?.name = record.name ?? ""
        vc?.email = record.email ?? ""
        vc?.city = record.city ?? ""
        vc?.single = record.single
        self.navigationController?.pushViewController(vc!, animated: true)


    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let record = fetchedResultsController.object(at: indexPath)
            
            
            record.managedObjectContext?.delete(record)
        }
    }
    
}
