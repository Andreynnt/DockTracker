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
   
    @IBOutlet var textView: UITextView!
    
    var containerName: String?
    var socket: WebSocket?
    var host = "andrey-babkov.ru:5555"
    var needDates = false
    var tail = "-1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isEditable = false
        getLogs()
    }
    
    func getLogs() {
        guard let parsedName = containerName else { return }
        var parsedTail = tail
        if parsedTail == "-1" {
            parsedTail = "all"
        }
        let parsedUrl = "http://\(self.host)/containers/\(parsedName)/logs?stderr=1&stdout=1&timestamps=\(needDates)&tail=\(parsedTail)"
        let url = URL(string: parsedUrl)!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let parsedData = data else { return }
            let content = String(decoding: parsedData, as: UTF8.self)
            
            DispatchQueue.main.async {
                self.fillTextView(with: content)
            }
            self.startSocket()
        }.resume()
    }
    
    func startSocket() {
        guard let name = containerName else { return }
        socket = WebSocket(url: URL(string: "ws://\(host)/containers/\(name)/attach/ws?stream=true")!)
        
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
            self.fillTextView(with: content)
        }
        
        socket?.connect()
    }
    
    func fillTextView(with content: String) {
        self.textView.text = self.textView.text! + content
        scrollToBottom()
    }
    
    func scrollToBottom() {
        if textView.text.count > 0 {
            let location = textView.text.count - 1
            let bottom = NSMakeRange(location, 1)
            textView.scrollRangeToVisible(bottom)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (socket != nil) && socket!.isConnected {
            socket!.disconnect()
        }
    }

}
