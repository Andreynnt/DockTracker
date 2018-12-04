//
//  ContainerViewController.swift
//  DockTracker
//
//  Created by Андрей Бабков on 29/10/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet var logsButton: UIButton!
    @IBOutlet var tableCard: UIView!
    @IBOutlet var mainBackground: UIView!
    @IBOutlet var containerTopCard: UIView!
    @IBOutlet weak var buttonsWrapperCard: UIView!
    @IBOutlet weak var topBackgroundCard: UIView!
    
    var container = Container()
    var numberOfLogs = -1
    var needLogsDates = false
    var stateFieldNum = -1
    let cornerRadius = CGFloat(6)
    
    //segues names
    let openLogsSegue = "openLogs"
    let openNumberOfLogsSegue = "openNumberOfLogs"
    
    //cells names
    let containerDataCellIdentifier = "ContainerDataCell"
    let LogsDateCellIdentifier = "LogsDateCell"
    let numberOfLogsCellIdentifier = "NumberOfLogsCell"
    
    var containersParameters = [СontainerParameter]()
    
    //settings view controller inside tableCard
    lazy var settingsViewController: ContainerSettingsViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ContainerSettingsViewController") as! ContainerSettingsViewController
        self.addViewToTableCard(viewController: viewController)
        return viewController
    }()
    
     //information view controller inside tableCard
    lazy var informationViewController: ContainerInformationViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ContainerInformationViewController") as! ContainerInformationViewController
        viewController.containerParameters = containersParameters
        self.addViewToTableCard(viewController: viewController)
        return viewController
    }()
    
    func addViewToTableCard(viewController: UIViewController) {
        tableCard.addSubview(viewController.view)
        viewController.view.frame = tableCard.bounds
        viewController.view.autoresizingMask = [.flexibleHeight, .flexibleHeight]
        viewController.didMove(toParent: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        containersParameters = container.getParametersArray()
        makeMainBackgroundStylish()
        makeButtonsWrapperStylish()
        makeButtonStylish(logsButton)
        let img = UIImage(named: "bottom@2x.png")
        topBackgroundCard.backgroundColor = UIColor(patternImage: img!)
        
        //add container top card
        let frame = CGRect(x: 0, y: 0, width: containerTopCard.frame.width, height: containerTopCard.frame.height)
        let card = TopContainerCardView(frame: frame, container: container)
        card.layer.cornerRadius = cornerRadius
        containerTopCard.layer.cornerRadius = cornerRadius
        card.clipsToBounds = true
        containerTopCard.addSubview(card)
        
        //init lazy information and view controllers
        _ = informationViewController
        //_ = settingsViewController
    }
    
    func makeButtonsWrapperStylish() {
        buttonsWrapperCard.layer.shadowColor = UIColor.darkGray.cgColor
        buttonsWrapperCard.layer.shadowRadius = 3
        buttonsWrapperCard.layer.shadowOpacity = 0.7
        buttonsWrapperCard.layer.shadowOffset = CGSize(width: 0, height: 2)
    }

    func makeMainBackgroundStylish() {
        mainBackground.layer.shadowColor = UIColor.darkGray.cgColor
        mainBackground.layer.shadowRadius = 5
        mainBackground.layer.shadowOpacity = 0.7
        mainBackground.layer.shadowOffset = CGSize(width: 0, height: -5)
    }
  
    func makeButtonStylish(_ button: UIButton!) {
        button.layer.cornerRadius = button.frame.height / 2
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
    }

    override func viewWillAppear(_ animated: Bool) {
          //rm table
//        if let index = tableView.indexPathForSelectedRow {
//            tableView.deselectRow(at: index, animated: true)
//        }
        let img = UIImage(named: "top@2x.png")
        navigationController?.navigationBar.setBackgroundImage(img, for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(red:0.51, green:0.68, blue:0.81, alpha:1.0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    @IBAction func touchLogsButton(_ sender: UIButton) {
        performSegue(withIdentifier: openLogsSegue, sender: self)
    }
    
    @IBAction func clickSettingsButton(_ sender: UIButton) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == openLogsSegue {
            let logsView = segue.destination as! LogsViewController
            logsView.containerName = container.name.value
            logsView.needDates = needLogsDates
            logsView.tail = String(numberOfLogs)
        }
    }
}

extension ContainerViewController: LogsDateSwitchCellDelegate {
    func changeNeedLogs(need: Bool) {
        self.needLogsDates = need
    }
}
