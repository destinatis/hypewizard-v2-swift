//
//  ViewController_PromoTicket.swift
//  hypewizard
//
//  Created by Konstantin Yurchenko on 5/27/17.
//  Copyright © 2017 Disruptive Widgets. All rights reserved.
//
import UIKit

class ViewController_PromoTicket: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var address_label: UILabel!
    @IBOutlet weak var amount_currency_label: UILabel!
    
    @IBOutlet weak var partial_view: UIView!
    
    var currency = ""
    var payment_address = ""
    var amount = 0.0
    var conversion_rate = 0.0
    var ticket_id = 0
        
    var activity_view_controller: ViewController_Activity = ViewController_Activity()
    
    @IBOutlet weak var ticket_number_label: UILabel!
    
    override func loadView() {
        super.viewDidLoad()
        
        if self.screenHeight == 480 {
            Bundle.main.loadNibNamed("ViewController_PromoTicket3.5", owner: self, options: nil)
        } else if self.screenHeight == 568 {
            Bundle.main.loadNibNamed("ViewController_PromoTicket4.0", owner: self, options: nil)
        } else if self.screenHeight == 736 {
            Bundle.main.loadNibNamed("ViewController_PromoTicket5.5", owner: self, options: nil)
        } else {
            Bundle.main.loadNibNamed("ViewController_PromoTicket4.7", owner: self, options: nil)
        }
    }
    
    @IBOutlet weak var help_button: UIButton!
    
    func setup_help_button() {
        self.help_button.layer.cornerRadius = self.help_button.frame.size.height / 2.0;
        self.help_button.layer.borderColor = UIColor.clear.cgColor;
        self.help_button.clipsToBounds = true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.amount_currency_label.text = "\(amount) \(currency)"
        self.address_label.text = payment_address
        self.ticket_number_label.text = "Hype Wizard Ticket #\(ticket_id)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.show_ready_alert()
        self.hide_partial_ui()
    }
    
    func hide_partial_ui() {
        self.partial_view.isHidden = true
    }
    
    func show_partial_ui() {
        self.setup_help_button()
        self.partial_view.isHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    @IBAction func back (button: UIButton!) {
        print("back")
        self.app_delegate.navigation_controller.popViewController(animated: false)
        self.app_delegate.navigation_controller.popViewController(animated: false)
    }
    @IBAction func show_help(_ sender: Any) {
        print("show_help")
        
        let view_controller = ViewController_Help()
        self.app_delegate.navigation_controller.pushViewController(
            view_controller,
            animated: false
        )
    }
    func show_ready_alert() {
        let alert = UIAlertController(title: "Hype Wizard says:", message: "\n Your ticket is ready. \n Copy payment address?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Yes, thank you!", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Don't show this again")
            UIPasteboard.general.string = self.payment_address
            self.show_partial_ui()
        }
        
        // Add the actions
        alert.addAction(cancelAction)
        
        alert.actions[0].isEnabled = false
        
        self.app_delegate.navigation_controller.present(alert, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.actions[0].isEnabled = true
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
