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
    @IBOutlet weak var controlButton: UIButton!
    
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
    
    var movingIndicator: UIView?
    
    //views inside tableCard
    let settingsViewControllerName = "settingsViewName"
    let informationViewControllerName = "informationViewName"
    let controlViewControllerName = "controlViewControllerName"
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
    
    //control view controller inside tableCard
    lazy var controlViewController: ContainerControlViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ContainerControlViewController") as! ContainerControlViewController
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
        //logsButton.backgroundColor = Colors.thirdColor
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
        
        //init internal view controllers
        viewsInsideTableCard[informationViewControllerName] = informationViewController
        viewsInsideTableCard[settingsViewControllerName] = settingsViewController
        viewsInsideTableCard[controlViewControllerName] = controlViewController
        viewsInsideTableCard[activeViewContollerName]?.view.isHidden = false
        
        initIndicator()
    }
    
    func initIndicator() {
        let indicatorHeight = CGFloat(3)
        movingIndicator = UIView(frame:CGRect(x: 0,
              y: buttonsWrapperCard.bounds.height - indicatorHeight,
              width: buttonsWrapperCard.bounds.width / 3,
              height: indicatorHeight)
        )
        movingIndicator?.backgroundColor = Colors.secondColor
        buttonsWrapperCard.addSubview(movingIndicator!)
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
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    @IBAction func touchLogsButton(_ sender: UIButton) {
        performSegue(withIdentifier: openLogsSegue, sender: self)
    }
    
    @IBAction func clickSettings(_ sender: UIButton) {
        if activeViewContollerName == settingsViewControllerName { return }
        changeButtonTextColor(viewControllerName: settingsViewControllerName, color: .black)
        changeButtonTextColor(viewControllerName: activeViewContollerName, color: .lightGray)
        animateIndicator(moveTo: settingsViewControllerName)
        showViewController(name: settingsViewControllerName)
    }
    
    @IBAction func clickInformation(_ sender: UIButton) {
        if activeViewContollerName == informationViewControllerName { return }
        changeButtonTextColor(viewControllerName: informationViewControllerName, color: .black)
        changeButtonTextColor(viewControllerName: activeViewContollerName, color: .lightGray)
        animateIndicator(moveTo: informationViewControllerName)
        showViewController(name: informationViewControllerName)
    }
    
    @IBAction func clickControlButton(_ sender: UIButton) {
        if activeViewContollerName == controlViewControllerName { return }
        changeButtonTextColor(viewControllerName: controlViewControllerName, color: .black)
        changeButtonTextColor(viewControllerName: activeViewContollerName, color: .lightGray)
        animateIndicator(moveTo: controlViewControllerName)
        showViewController(name: controlViewControllerName)
    }
    
    func changeButtonTextColor(viewControllerName: String, color: UIColor) {
        switch viewControllerName {
        case settingsViewControllerName:
            settingsButton.setTitleColor(color , for: .normal)
        case controlViewControllerName:
            controlButton.setTitleColor(color , for: .normal)
        case informationViewControllerName:
            informationButton.setTitleColor(color , for: .normal)
        default:
            return
        }
    }
    
    func animateIndicator(moveTo viewName: String) {
        guard let indicator = movingIndicator else { return }

        let indicatorWidth = indicator.bounds.size.width
        let animationTime = 0.2
        if viewName == informationViewControllerName {
            let destination = CGFloat(indicatorWidth / 2)
            UIView.animate(withDuration: animationTime,  delay: 0, options: [.curveEaseOut],
                animations: {
                        indicator.center.x = destination
                },
                completion: nil
            )
        } else if viewName == controlViewControllerName {
            let destination = indicatorWidth + CGFloat(indicatorWidth / 2)
            UIView.animate(withDuration: animationTime,  delay: 0, options: [.curveEaseOut],
                animations: {
                indicator.center.x = destination
            },
                completion: nil
            )
        } else if viewName == settingsViewControllerName {
            let destination = 2 * indicatorWidth + CGFloat(indicatorWidth / 2)
            UIView.animate(withDuration: animationTime,  delay: 0, options: [.curveEaseOut],
                animations: {
                    indicator.center.x = destination
                },
                completion: nil
            )
        }
    }
    
    func showViewController(name: String) {
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
