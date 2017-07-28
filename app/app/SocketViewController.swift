//
//  SocketViewController.swift
//  hypewizard
//
//  Created by Konstantin Yurchenko on 10/9/16.
//  Copyright © 2016 Disruptive Widgets. All rights reserved.
//


import Foundation
import UIKit
import ActionCableClient

class SocketViewController: BaseViewController {
    
    @IBOutlet weak var header_view: UIView!
    
    var handler: ((_ data: NSDictionary) -> Void) = {data in ()}
    
    // UI ELEMENTS
    var scrollView: UIScrollView!
    
    override func loadView() {
        super.viewDidLoad()
        
        if self.screenHeight == 480 {
            Bundle.main.loadNibNamed("SocketViewController", owner: self, options: nil)
        } else if self.screenHeight == 568 {
            Bundle.main.loadNibNamed("SocketViewController", owner: self, options: nil)
        } else if self.screenHeight == 736 {
            Bundle.main.loadNibNamed("SocketViewController", owner: self, options: nil)
        } else {
            Bundle.main.loadNibNamed("SocketViewController", owner: self, options: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight))
        self.view.addSubview(scrollView)
        
        self.stackView = UIStackView()
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.axis = UILayoutConstraintAxis.vertical
        self.stackView.distribution = UIStackViewDistribution.equalSpacing
        self.stackView.alignment = UIStackViewAlignment.center
        self.stackView.spacing = 10
        
        self.assembleInterface()
        
        self.scrollView.addSubview(self.stackView)
        self.scrollView.contentSize = CGSize(width: self.stackView.frame.width, height: self.stackView.frame.height)
        self.scrollView.bounces = false
    }
    
    let client = ActionCableClient(url: URL(string: "ws://playent-puma.us-west-2.elasticbeanstalk.com/cable")!)
    var channel: Channel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        //
        self.client.connect()
        
        self.client.onConnected = {
            print("Connected!")
        }
        
        self.client.onDisconnected = {(error: Error?) in
            print("Disconnected!")
        }
        let uuid = UUID().uuidString.lowercased()
        let payload = ChannelIdentifier(dictionaryLiteral: ("uuid", uuid))
        
        self.channel = client.create("ClockChannel", identifier: payload)
        
        self.channel?.onReceive = { (JSON : Any?, error : Error?) in
            print("Received", JSON, error)

            if let dict = JSON as? [String: AnyObject] {
                self.socket_output_label.text = "\(dict["random_number"] as! Int)"
            }
        }
        
        // A channel has successfully been subscribed to.
        self.channel?.onSubscribed = {
            print("Yay!")
        }
        
        // A channel was unsubscribed, either manually or from a client disconnect.
        self.channel?.onUnsubscribed = {
            print("Unsubscribed")
        }
        
        // The attempt at subscribing to a channel was rejected by the server.
        self.channel?.onRejected = {
            print("Rejected")
        }
        //
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        #if DEBUG
            print("viewDidLayoutSubviews")
        #endif
        
        self.scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
    }
    
    var socket_output_label = UILabel()
    
    func assembleInterface() {
        self.header_view.heightAnchor.constraint(equalToConstant: 64).isActive = true
        self.header_view.widthAnchor.constraint(equalToConstant: self.screenWidth).isActive = true
        self.stackView.addArrangedSubview(self.header_view)
        
        self.addSpacer()
        
        let start_button = self.createButton(caption: "Start")
        start_button.addTarget(self, action: #selector(self.start_action), for: UIControlEvents.touchUpInside)
        self.stackView.addArrangedSubview(start_button)
        
        let stop_button = self.createButton(caption: "Stop")
        stop_button.addTarget(self, action: #selector(self.stop_action), for: UIControlEvents.touchUpInside)
        self.stackView.addArrangedSubview(stop_button)

        self.addSpacer()
        
        self.socket_output_label = self.createLabel(text: "Server Message", size: 24)
        self.stackView.addArrangedSubview(self.socket_output_label)
        
        self.addSpacer()
        
        self.addExpandInfoLabel1Fold(button_text: "Instructions", label_text: "Start/Stop Timer")
        //        self.addExpandInfoLabel2Fold()
        self.addWhyInfoLabel1Fold()
        self.addSpacer()
    }
    
    @IBAction func start_action(sender: AnyObject) {
        self.channel?.action("start", with: ["message": "Hello, World!"])
    }

    @IBAction func stop_action(sender: AnyObject) {
        self.channel?.action("stop", with: ["message": "Hello, World!"])
    }

    
    @IBAction func close(sender: AnyObject) {
        self.close()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
}

