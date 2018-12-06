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
    let segueName = "openApp"

    @IBOutlet var preloaderView: FLAnimatedImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fillPreloader()
        fillContainersManager()
    }

    func fillPreloader() {
        let path1: String = Bundle.main.path(forResource: "spinner1", ofType: "gif")!
        let url = URL(fileURLWithPath: path1)
        if let gifData = try? Data(contentsOf: url) {
            let imageData = FLAnimatedImage(animatedGIFData: gifData)
            preloaderView.animatedImage = imageData
        }
    }

    func fillContainersManager() {
        let manager = ContainersManager.shared()
        manager.getContainers(mainCallback: {() -> Void in
            self.performSegue(withIdentifier: self.segueName, sender: self)
        })
    }
}
