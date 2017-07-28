//
//  ViewController_Help.swift
//  hypewizard
//
//  Created by Konstantin Yurchenko on 5/27/17.
//  Copyright © 2017 Disruptive Widgets. All rights reserved.
//

import UIKit

class ViewController_Help: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var version_label: UILabel!
    
    var activity_view_controller: ViewController_Activity = ViewController_Activity()
    
    @IBOutlet weak var close_button: UIButton!
    
    override func loadView() {
        super.viewDidLoad()
        
        if self.screenHeight == 480 {
            Bundle.main.loadNibNamed("ViewController_Help3.5", owner: self, options: nil)
        } else if self.screenHeight == 568 {
            Bundle.main.loadNibNamed("ViewController_Help4.0", owner: self, options: nil)
        } else if self.screenHeight == 736 {
            Bundle.main.loadNibNamed("ViewController_Help5.5", owner: self, options: nil)
        } else {
            Bundle.main.loadNibNamed("ViewController_Help4.7", owner: self, options: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.version_label.text = "Version: \(Bundle.main.releaseVersionNumber!).\(Bundle.main.buildVersionNumber!)"
        
        self.close_button.layer.cornerRadius = self.close_button.frame.size.height / 2.0;
        self.close_button.layer.borderColor = UIColor.clear.cgColor;
        self.close_button.clipsToBounds = true;
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    @IBAction func show_homepage(_ sender: Any) {
        print("show_homepage")
        
        let url = URL(string: "http://www.hypewizard.com")!
        UIApplication.shared.open(url)
    }
    @IBAction func show_terms(_ sender: Any) {
        print("show_terms")
        
        let url = URL(string: "http://hypewizard.com/terms_of_service")!
        UIApplication.shared.open(url)
    }
    @IBAction func contact_support(_ sender: Any) {
        print("contact_support")
        
        let email = "support@hypewizard.com"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func back (button: UIButton!) {
        print("back")
        self.app_delegate.navigation_controller.popViewController(animated: false)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

