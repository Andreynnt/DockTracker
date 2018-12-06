//
//  TopCardContainer.swift
//  DockTracker
//
//  Created by Андрей Бабков on 29/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import Foundation
import UIKit

class TopContainerCardView: UIView {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var imageContainer: UIImageView!

    var container: Container?

    override init(frame: CGRect) {
        super.init(frame: frame)
        myInit()
    }

    init(frame: CGRect, container: Container) {
        super.init(frame: frame)
        myInit(container)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        myInit()
    }

    private func myInit(_ container: Container? = nil) {
        Bundle.main.loadNibNamed("TopContainerCardView", owner: self, options: nil)
        addSubview(backgroundView)
        backgroundView.frame = self.bounds
        backgroundView.clipsToBounds = true
        backgroundView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.container = container
        nameLabel.text = container?.name.value
        imageLabel.text = container?.image.value
        stateLabel.text = container?.status.value
    }

//    @IBAction func touchStartStopButton(_ sender: UIButton) {
//        if let cont = container {
//            if (cont.isStarted()) {
//                stopContainer(with: cont.name.value)
//            } else {
//                startContainer(with: cont.name.value)
//            }
//        }
//    }

    func startContainer(with name: String) {
        guard let savedUrl = UserSettings.getUrl(at: 0) else { return }
        let urlString = savedUrl + "/containers/\(name)/start?p=80:3000"

        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { (_, response, error) in
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

        print("Going to request \(urlString)")
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { (_, response, error) in
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

    func makeButtonStylish(_ button: UIButton!) {
        button.layer.cornerRadius = button.frame.height / 2
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
    }

}
