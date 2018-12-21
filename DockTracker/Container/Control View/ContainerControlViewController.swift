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
    var isRequestingBackend = false
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func makeButtonStylish(_ button: UIButton!) {
            button.setTitleColor(UIColor.white, for: .normal)
            button.layer.cornerRadius = 10
            button.layer.shadowColor = UIColor.darkGray.cgColor
            button.layer.shadowRadius = 3
            button.layer.shadowOpacity = 0.5
            button.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
       
        statusLabel.textColor = Colors.thirdColor
        fillStatusLabel()
        colorButtons()
        makeButtonStylish(startButton)
        makeButtonStylish(stopButton)
    }

    
    func colorButtons() {
        if container?.state.value == "running" {
            stopButton.backgroundColor = Colors.secondColor
            startButton.backgroundColor = Colors.secondColor.withAlphaComponent(0.3)
        } else {
            startButton.backgroundColor = Colors.secondColor
            stopButton.backgroundColor = Colors.secondColor.withAlphaComponent(0.3)
        }
    }
    
    func fillStatusLabel() {
        if container?.state.value == "running" {
            statusLabel.text = "running"
        } else {
            statusLabel.text = "stopped"
        }
    }
    @IBAction func clickStopButton(_ sender: UIButton) {
        if container?.state.value == "stopped" || isRequestingBackend {
            return
        }
        stopContainer(with: container!.name.value)
    }
    
    @IBAction func clickStartButton(_ sender: UIButton) {
        if container?.state.value == "running" || isRequestingBackend {
            return
        }
        startContainer(with: container!.name.value)
    }
    

    
    func startContainer(with name: String) {
        guard let savedUrl = UserSettings.getUrl(at: 0) else { return }
        let urlString = savedUrl + "/containers/\(name)/start?p=80:3000"

        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        statusLabel.text = "starting..."
        self.isRequestingBackend = true
        startButton.backgroundColor = Colors.secondColor.withAlphaComponent(0.3)
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Can't httpResponse = response as? HTTPURLResponse")
                return
            }

            self.isRequestingBackend = false
            switch httpResponse.statusCode {
            case 204:
                DispatchQueue.main.async {
                    self.container?.state.value = "running"
                    self.fillStatusLabel()
                    self.colorButtons()
                }
            case 304:
                print("Container already started")
                self.fillStatusLabel()
                self.colorButtons()
            case 500:
                print("Server error")
                self.fillStatusLabel()
                self.colorButtons()
            default:
                print("Unexpected error")
                self.fillStatusLabel()
                self.colorButtons()
            }
            }.resume()
    }

    func stopContainer(with name: String) {
        guard let savedUrl = UserSettings.getUrl(at: 0) else { return }
        let urlString = savedUrl + "/containers/\(name)/stop"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        statusLabel.text = "stopping..."
        self.isRequestingBackend = true
        stopButton.backgroundColor = Colors.secondColor.withAlphaComponent(0.3)
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Can't httpResponse = response as? HTTPURLResponse")
                return
            }

            self.isRequestingBackend = false
            switch httpResponse.statusCode {
            case 204:
                DispatchQueue.main.async {
                    self.container?.state.value = "exited"
                    self.fillStatusLabel()
                    self.colorButtons()
                }
            case 304:
                print("Container already stopped")
                self.fillStatusLabel()
                self.colorButtons()
            case 500:
                print("Server error")
                self.fillStatusLabel()
                self.colorButtons()
            default:
                print("Unexpected error")
                self.fillStatusLabel()
                self.colorButtons()
            }
            }.resume()
    }
}
