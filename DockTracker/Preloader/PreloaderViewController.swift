//
//  PreloaderViewController.swift
//  DockTracker
//
//  Created by Андрей Бабков on 26/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit
import FLAnimatedImage

class PreloaderViewController: UIViewController {
    
    enum Segues: String {
        case OpenApp
    }
  
    @IBOutlet var preloaderView: FLAnimatedImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fillPreloader()
        setup()
    }

    func fillPreloader() {
        let path1: String = Bundle.main.path(forResource: "spinner1", ofType: "gif")!
        let url = URL(fileURLWithPath: path1)
        if let gifData = try? Data(contentsOf: url) {
            let imageData = FLAnimatedImage(animatedGIFData: gifData)
            preloaderView.animatedImage = imageData
        }
    }

    func setup() {
        let service = ServerService.shared()
        
        guard let preferredServer = service.preferredServer else {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Segues.OpenApp.rawValue, sender: self)
            }
            return
        }
    
        service.getStatus(server: preferredServer) { (canConnect, text) -> Void in
            if canConnect {
                service.preferredServerIsConnected = true
                let url = service.getUrl(server: preferredServer)
                ContainersManager.shared().getContainers(url: url, mainCallback: {() -> Void in
                    self.performSegue(withIdentifier: Segues.OpenApp.rawValue, sender: self)
                })
                return
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Segues.OpenApp.rawValue, sender: self)
            }
        }
    }
    
    
}
