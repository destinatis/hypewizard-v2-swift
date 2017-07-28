//
//  ViewController.swift
//  hypewizard
//
//  Created by Konstantin Yurchenko on 1/30/16.
//  Copyright © 2016 Disruptive Widgets. All rights reserved.
//

import UIKit

class ViewController_PromoStart: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    
    var activity_view_controller: ViewController_Activity = ViewController_Activity()
    
    @IBOutlet weak var partial_view: UIView!
    
    override func loadView() {
        super.viewDidLoad()
        
        if self.screenHeight == 480 {
            Bundle.main.loadNibNamed("ViewController_PromoStart3.5", owner: self, options: nil)
        } else if self.screenHeight == 568 {
            Bundle.main.loadNibNamed("ViewController_PromoStart4.0", owner: self, options: nil)
        } else if self.screenHeight == 736 {
            Bundle.main.loadNibNamed("ViewController_PromoStart5.5", owner: self, options: nil)
        } else {
            Bundle.main.loadNibNamed("ViewController_PromoStart4.7", owner: self, options: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        for family: String in UIFont.familyNames {
//            print("\(family)")
//            for names: String in UIFont.fontNames(forFamilyName: family) {
//                print("== \(names)")
//            }
//        }
        
        print(self.screenHeight)
        
//        let parameters = NSMutableDictionary()
//        parameters.setValue(Bundle().releaseVersionNumber, forKey: "release_version_number")
//        parameters.setValue(Bundle().buildVersionNumber, forKey: "build_version_number")
//        parameters.setValue(Bundle().deviceId, forKey: "device_uuid")
//        
//        self.app_delegate.show_activity_view_controller(message: "Loading...")
//        
//        RestAPIClient.sharedInstance.fetch_network_list(parameters: parameters) { response in
//            print(response)
//            
//            DispatchQueue.main.async(execute: {
//                self.app_delegate.remove_activity_view_controller()
//                
//                let networks = response["networks"] as! [String]
//                print(networks)
//                
//
//            })
//        }
        self.setup_ui()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        

//        self.show_welcome_alert()
        self.show_partial_ui()
    }
    
    func hide_partial_ui() {
        self.partial_view.isHidden = true
    }
    
    func show_partial_ui() {
        self.setup_help_button()
        self.partial_view.isHidden = false
    }
    
    func show_welcome_alert() {
        self.hide_partial_ui()
        
        let alert = UIAlertController(title: "Hype Wizard asks:", message: "\n What type of promo do you need?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Don't ask again", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("Dismiss")
            self.show_partial_ui()
        }
        let cancelAction = UIAlertAction(title: "Let me tell you", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Don't show this again")
            self.show_partial_ui()
        }
        
        // Add the actions
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        alert.actions[0].isEnabled = false
        alert.actions[1].isEnabled = false
        
        self.app_delegate.navigation_controller.present(alert, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.actions[0].isEnabled = true
            alert.actions[1].isEnabled = true
        }
    }
    
    func show_warning_alert() {
        let alert = UIAlertController(title: "Hype Wizard says:", message: "Can't do my magic without a username.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "I can tell you", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Don't show this again")
        }
        
        // Add the actions
        alert.addAction(cancelAction)
        
        self.app_delegate.navigation_controller.present(alert, animated: true, completion: nil)
    }

    var buttons: [UIButton] = []
    
    func setup_ui() {
        self.twitterButton.tag = 0
        self.instagramButton.tag = 1
        self.facebookButton.tag = 2
        
        self.twitterButton.addTarget(self, action: #selector(self.networkButtonTapped(_:)), for: .touchDown)
        self.instagramButton.addTarget(self, action: #selector(self.networkButtonTapped(_:)), for: .touchDown)
        self.facebookButton.addTarget(self, action: #selector(self.networkButtonTapped(_:)), for: .touchDown)
        
        self.buttons.append(self.twitterButton)
        self.buttons.append(self.instagramButton)
        self.buttons.append(self.facebookButton)
        
        self.usernameTextField.clearButtonMode = .always
        self.usernameTextField.clearButtonMode = .whileEditing
        
        self.usernameTextField.delegate = self
        
        self.usernameTextField.autocorrectionType = UITextAutocorrectionType.no
        
        self.highlight_network_button(0)
    }
    
    func networkButtonTapped(_ button: UIButton) {
        print("Button pressed \(button.tag)")
        self.highlight_network_button(button.tag)
    }
    
    var selected_network_id = 0
    
    func highlight_network_button(_ tag: Int) {
        for button in buttons {
            if button.tag == tag {
                button.backgroundColor = PANTONE_greenery
                button.setTitleColor(PANTONE_willow_bough, for: .normal)
                self.selected_network_id = tag
            } else {
                button.backgroundColor = PANTONE_willow_bough
                button.setTitleColor(PANTONE_silt_green, for: .normal)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    @IBAction func configure_promo_request (button: UIButton!) {
        print("configure_promo_request")
        
        if (self.usernameTextField.text!.isEmpty) {
            self.show_warning_alert()
        } else {
            let view_controller = ViewController_PromoParameters()
            view_controller.network_id = selected_network_id
            view_controller.username = usernameTextField.text!
            
            self.app_delegate.navigation_controller.pushViewController(
                view_controller,
                animated: false
            )
        }
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

