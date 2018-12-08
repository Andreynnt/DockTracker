//
//  MainMenuViewController.swift
//  DockTracker
//
//  Created by Андрей Бабков on 08/12/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit
import CoreData

class MainMenuViewController: UIViewController, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var favouriteSection: UIView!
    @IBOutlet weak var favouriteAmountLabel: UILabel!
    
    @IBOutlet weak var workingSection: UIView!
    @IBOutlet weak var workingAmountLabel: UILabel!
    
    @IBOutlet weak var stoppedSection: UIView!
    @IBOutlet weak var stoppedAmountLabel: UILabel!
    
    let segueToContainersView = "menu-containers"
    
    var fetchedResultsController = CoreDataManager.instance
        .fetchedResultsController(entityName: "FavouriteContainerCoreData", keyForSort: "id")
    
    var favouriteContainers = [FavouriteContainerCoreData]()
    var containersToSend = [Container]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController.delegate = self
    
        favouriteAmountLabel.text = String(ContainersManager.shared().favouriteContainers.count)
        workingAmountLabel.text = String(ContainersManager.shared().workingContainers.count)
        stoppedAmountLabel.text = String(ContainersManager.shared().stoppedContainers.count)
        
        let tapFavourite = UITapGestureRecognizer(target: self, action: #selector(handleTapOnFavourite))
        favouriteSection.addGestureRecognizer(tapFavourite)

        let tapWorking = UITapGestureRecognizer(target: self, action: #selector(handleTapOnWorking))
        workingSection.addGestureRecognizer(tapWorking)
        
        let tapStopped = UITapGestureRecognizer(target: self, action: #selector(handleTapOnStopped))
        stoppedSection.addGestureRecognizer(tapStopped)
        
//print all favourites containers
//        do {
//         try fetchedResultsController.performFetch()
//        } catch {
//            print("AA")
//        }
//        let containers = fetchedResultsController.fetchedObjects as! [FavouriteContainerCoreData]
//        for container in containers {
//            let id = container.id ?? "No id"
//            print("id = \(id)")
//        }
        
    }
    
    @objc func handleTapOnFavourite(_ sender: UITapGestureRecognizer) {
        containersToSend = ContainersManager.shared().favouriteContainers
        performSegue(withIdentifier: segueToContainersView, sender: self)
    }
    
    @objc func handleTapOnWorking(_ sender: UITapGestureRecognizer) {
        containersToSend = ContainersManager.shared().workingContainers
        performSegue(withIdentifier: segueToContainersView, sender: self)
    }
    
    @objc func handleTapOnStopped(_ sender: UITapGestureRecognizer) {
        containersToSend = ContainersManager.shared().stoppedContainers
        performSegue(withIdentifier: segueToContainersView, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToContainersView {
            let containerView = segue.destination as! ContainersViewController
            containerView.containers = containersToSend
        }
    }
    
//    example how to delete
//    @IBAction func touchDeleteButton(_ sender: UIButton) {
//        let containers = fetchedResultsController.fetchedObjects as! [FavouriteContainerCoreData]
//        for (index, container) in containers.enumerated() {
//            if let id = container.id {
//                if id == "3298" {
//                    let objectToDelete = fetchedResultsController.fetchedObjects?[index] as! NSManagedObject
//                    CoreDataManager.instance.managedObjectContext.delete(objectToDelete)
//                    CoreDataManager.instance.saveContext()
//                }
//            }
//        }
//    }
    
//    example how to save
//    @IBAction func touchAddButton(_ sender: UIButton) {
//        let managedObject = FavouriteContainerCoreData()
//        managedObject.id = "3589"
//        CoreDataManager.instance.saveContext()
//    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .update:
            print(" case .update:")
        case .insert:
            print(" case .insert:")
            return
        case .delete:
            print(" case .delete:")
            return
        case .move:
            print(" case .move:")
            return
        }
    }
    
}
