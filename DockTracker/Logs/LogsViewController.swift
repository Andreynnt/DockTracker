//
//  LogsViewController.swift
//  DockTracker
//
//  Created by Андрей Бабков on 15/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit
import Starscream


class LogsViewController: UIViewController {
    @IBOutlet var logsTitle: UILabel!
    
    var containerName: String?
    var socket: WebSocket?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startSocket()
    }
    
    func startSocket() {
        guard let name = containerName else { return }
        socket = WebSocket(url: URL(string: "ws://andrey-babkov.ru:5555/containers/\(name)/attach/ws?stream=true")!)
        
        socket?.onConnect = {
            print("websocket is connected")
        }
        
        socket?.onDisconnect = { (error: Error?) in
            if error != nil {
                 print("websocket is disconnected: \(String(describing: error?.localizedDescription))")
            } else {
                 print("successful ws disconnect")
            }
        }
        
        socket?.onText = { (text: String) in
            print("got some text: \(text)")
        }
        
        socket?.onData = { (data: Data) in
            guard let content = String(data: data, encoding: String.Encoding.utf8) else { return }
            self.logsTitle.text = self.logsTitle.text! + content
        }
        
        socket?.connect()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (socket != nil) && socket!.isConnected {
            socket!.disconnect()
        }
    }

}
