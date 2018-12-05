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
    @IBOutlet weak var topBackgroundCard: UIView!
    
    //menu
    @IBOutlet weak var buttonsWrapperCard: UIView!


    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var informationButton: UIButton!
    
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
    
    //views inside tableCard
    let settingsViewControllerName = "settingsViewName"
    let informationViewControllerName = "informationViewName"
    var activeViewContollerName = "informationViewName"
    var viewsInsideTableCard = [String: UIViewController]()
    
    //settings view controller inside tableCard
    lazy var settingsViewController: ContainerSettingsViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ContainerSettingsViewController") as! ContainerSettingsViewController
        viewController.logsSwichDelegate = self
        viewController.logsAmountDelegate = self
        self.addViewToTableCard(viewController: viewController)
        viewController.view.isHidden = true
        return viewController
    }()
    
    //information view controller inside tableCard
    lazy var informationViewController: ContainerInformationViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ContainerInformationViewController") as! ContainerInformationViewController
        viewController.containerParameters = containersParameters
        self.addViewToTableCard(viewController: viewController)
        viewController.view.isHidden = true
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
        addBottomBorder(to: buttonsWrapperCard)
        informationButton.setTitleColor(.black , for: .normal)
        
        //init information and view controllers
        viewsInsideTableCard[informationViewControllerName] = informationViewController
        viewsInsideTableCard[settingsViewControllerName] = settingsViewController
        viewsInsideTableCard[activeViewContollerName]?.view.isHidden = false
    }
    
    func addBottomBorder(to subview: UIView) {
        let border = CALayer()
        border.backgroundColor = UIColor.lightGray.cgColor
        let height = 1.5
        let y = Double(subview.frame.height) - height
        border.frame = CGRect(x: 0, y: y, width: Double(subview.frame.width), height: height)
        buttonsWrapperCard.layer.addSublayer(border)
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
    
    @IBAction func clickSettings(_ sender: UIButton) {
        sender.setTitleColor(.black, for: .normal)
        informationButton.setTitleColor(.lightGray, for: .normal)
        showViewController(name: settingsViewControllerName)
    }
    
    @IBAction func clickInformation(_ sender: UIButton) {
        sender.setTitleColor(.black, for: .normal)
        settingsButton.setTitleColor(.lightGray , for: .normal)
        showViewController(name: informationViewControllerName)
    }
    
    func showViewController(name: String) {
        if activeViewContollerName == name {
            return
        }
        viewsInsideTableCard[activeViewContollerName]?.view.isHidden = true
        viewsInsideTableCard[name]?.view.isHidden = false
        activeViewContollerName = name
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

extension ContainerViewController: ChoiceOfLogsAmountCellDelegate {
    func changeAmountOfLogs(amount: Int) {
        self.numberOfLogs = amount
    }
}
