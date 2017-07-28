//
//  ViewController_PromoParameters.swift
//  hypewizard
//
//  Created by Konstantin Yurchenko on 5/27/17.
//  Copyright © 2017 Disruptive Widgets. All rights reserved.
//

import UIKit

class ViewController_PromoParameters: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var like_count_text_field: UITextField!
    
    var activity_view_controller: ViewController_Activity = ViewController_Activity()
    
    var network_id = 0
    var username = ""
    
    override func loadView() {
        super.viewDidLoad()
        
        if self.screenHeight == 480 {
            Bundle.main.loadNibNamed("ViewController_PromoParameters3.5", owner: self, options: nil)
        } else if self.screenHeight == 568 {
            Bundle.main.loadNibNamed("ViewController_PromoParameters4.0", owner: self, options: nil)
        } else if self.screenHeight == 736 {
            Bundle.main.loadNibNamed("ViewController_PromoParameters5.5", owner: self, options: nil)
        } else {
            Bundle.main.loadNibNamed("ViewController_PromoParameters4.7", owner: self, options: nil)
        }
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.like_count_text_field.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction() {
        self.like_count_text_field.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.like_count_text_field.clearButtonMode = .always
        self.like_count_text_field.clearButtonMode = .whileEditing
        
        self.like_count_text_field.delegate = self
        
        self.like_count_text_field.autocorrectionType = UITextAutocorrectionType.no
        
        self.addDoneButtonOnKeyboard()
        
        self.setup_help_button()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    func show_warning_alert() {
        let alert = UIAlertController(title: "Hype Wizard says:", message: "Please be specific.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Sorry, my bad!", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Don't show this again")
        }
        
        // Add the actions
        alert.addAction(cancelAction)
        
        self.app_delegate.navigation_controller.present(alert, animated: true, completion: nil)
    }
    @IBAction func submit_request(button: UIButton!) {
        print("submit_request")
        
        if (self.like_count_text_field.text!.isEmpty) {
            self.show_warning_alert()
        } else {
        
            let parameters = NSMutableDictionary()
            parameters.setValue(Bundle().releaseVersionNumber, forKey: "release_version_number")
            parameters.setValue(Bundle().buildVersionNumber, forKey: "build_version_number")
            parameters.setValue(Bundle().deviceId, forKey: "device_uuid")
            parameters.setValue(self.network_id, forKey: "social_network_id")
            parameters.setValue(self.username, forKey: "social_network_username")
            parameters.setValue(self.like_count_text_field.text, forKey: "likes_count")
            
            self.app_delegate.show_activity_view_controller(message: "Loading...")
            
            RestAPIClient.sharedInstance.request_ticket(parameters: parameters) { response in
                print(response)
                
                DispatchQueue.main.async(execute: {
                    self.app_delegate.remove_activity_view_controller()
                    
                    let view_controller = ViewController_PromoTicket()
                    
                    let ticket = response["ticket"] as! NSDictionary
                    view_controller.currency = ticket["currency"] as! String
                    view_controller.payment_address = ticket["payment_address"] as! String
                    view_controller.amount = ticket["amount"] as! Double
                    view_controller.conversion_rate = ticket["conversion_rate"] as! Double
                    view_controller.ticket_id = ticket["id"] as! Int
                    
                    self.app_delegate.navigation_controller.pushViewController(
                        view_controller,
                        animated: false
                    )
                })
            }
        }
    }
    @IBAction func back(button: UIButton!) {
        print("back")
        self.app_delegate.navigation_controller.popViewController(animated: false)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBOutlet weak var help_button: UIButton!
    
    func setup_help_button() {
        self.help_button.layer.cornerRadius = self.help_button.frame.size.height / 2.0;
        self.help_button.layer.borderColor = UIColor.clear.cgColor;
        self.help_button.clipsToBounds = true;
    }
    @IBAction func show_help(_ sender: Any) {
        print("show_help")
        
        let view_controller = ViewController_Help()
        self.app_delegate.navigation_controller.pushViewController(
            view_controller,
            animated: false
        )
    }
}
