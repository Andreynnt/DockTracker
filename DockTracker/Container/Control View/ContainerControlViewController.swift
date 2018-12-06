//
//  ContainerControlViewController.swift
//  DockTracker
//
//  Created by Андрей Бабков on 05/12/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

class ContainerControlViewController: UIViewController {
    
    var container: Container?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func startContainer(with name: String) {
        guard let savedUrl = UserSettings.getUrl(at: 0) else { return }
        let urlString = savedUrl + "/containers/\(name)/start?p=80:3000"
        
        //self.startStopButton.setTitle("Starting", for: .normal)
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Can't httpResponse = response as? HTTPURLResponse")
                return
            }
            
            switch httpResponse.statusCode {
            case 204:
                DispatchQueue.main.async {
                    self.container?.state.value = "running"
                    //self.changeMainButtonTitle("Stop")
                }
            case 304:
                print("Container already started")
                //self.changeMainButtonTitle("Start")
            case 500:
                print("Server error")
                //self.changeMainButtonTitle("Start")
            default:
                print("Unexpected error")
                //self.changeMainButtonTitle("Start")
            }
            }.resume()
    }
    
    func stopContainer(with name: String) {
        guard let savedUrl = UserSettings.getUrl(at: 0) else { return }
        let urlString = savedUrl + "/containers/\(name)/stop"
        
        //self.startStopButton.setTitle("Stopping", for: .normal)
        print("Going to request \(urlString)")
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Can't httpResponse = response as? HTTPURLResponse")
                return
            }
            
            switch httpResponse.statusCode {
            case 204:
                print("Successful stop")
                DispatchQueue.main.async {
                    self.container?.state.value = "exited"
                    //self.changeMainButtonTitle("Start")
                }
            case 304:
                print("Container already stopped")
                //self.changeMainButtonTitle("Stop")
            case 500:
                print("Server error")
                //self.changeMainButtonTitle("Stop")
            default:
                print("Unexpected error")
                //self.changeMainButtonTitle("Stop")
            }
            }.resume()
    }
}
