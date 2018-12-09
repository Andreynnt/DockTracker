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
    var section: ContainersSection?
    
    //он уже выполнил fetch, поэтому можем спокойно работать
    var fetchedResultsController = ContainersManager.shared().fetchedResultsController
    var favouriteContainers = [FavouriteContainerCoreData]()
    var containersToSend = [Container]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        fetchedResultsController.delegate = self
        
        let tapFavourite = UITapGestureRecognizer(target: self, action: #selector(handleTapOnFavourite))
        favouriteSection.addGestureRecognizer(tapFavourite)

        let tapWorking = UITapGestureRecognizer(target: self, action: #selector(handleTapOnWorking))
        workingSection.addGestureRecognizer(tapWorking)
        
        let tapStopped = UITapGestureRecognizer(target: self, action: #selector(handleTapOnStopped))
        stoppedSection.addGestureRecognizer(tapStopped)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favouriteAmountLabel.text = String(ContainersManager.shared().favouriteContainers.count)
        workingAmountLabel.text = String(ContainersManager.shared().workingContainers.count)
        stoppedAmountLabel.text = String(ContainersManager.shared().stoppedContainers.count)
    }
    
    @objc func handleTapOnFavourite(_ sender: UITapGestureRecognizer) {
        containersToSend = ContainersManager.shared().favouriteContainers
        section = ContainersSection.Favourite
        performSegue(withIdentifier: segueToContainersView, sender: self)
    }
    
    @objc func handleTapOnWorking(_ sender: UITapGestureRecognizer) {
        containersToSend = ContainersManager.shared().workingContainers
        section = ContainersSection.Working
        performSegue(withIdentifier: segueToContainersView, sender: self)
    }
    
    @objc func handleTapOnStopped(_ sender: UITapGestureRecognizer) {
        containersToSend = ContainersManager.shared().stoppedContainers
        section = ContainersSection.Stopped
        performSegue(withIdentifier: segueToContainersView, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToContainersView {
            let containerView = segue.destination as! ContainersViewController
            containerView.fetchController = self.fetchedResultsController
            containerView.section = section
            containerView.containers = containersToSend
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .update:
            print(" case .update:")
        case .insert:
            print(" case .insert:")
            let newValue = String(Int(self.favouriteAmountLabel.text ?? "0")! + 1)
            self.favouriteAmountLabel.text = newValue
            return
        case .delete:
            print(" case .delete:")
            let newValue = String(Int(self.favouriteAmountLabel.text ?? "0")! - 1)
            self.favouriteAmountLabel.text = newValue
            return
        case .move:
            print(" case .move:")
            return
        }
    }
}
