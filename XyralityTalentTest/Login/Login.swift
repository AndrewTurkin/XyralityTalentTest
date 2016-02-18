//
//  Login.swift
//  XyralityTalentTest
//
//  Created by Andrew Turkin on 2/18/16.
//  Copyright © 2016 andrew.turkin. All rights reserved.
//

import UIKit

class Login: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func loginAction(sender: UIButton) {
        login()
    }
    
    func login() {
        guard !(emailTextField.text!.isEmpty) && !(passwordTextField.text!.isEmpty) else {
                
                let alert = UIAlertController(title: "Credentials Empty", message: "Please enter your credentials.", preferredStyle: .Alert)

                let alertAction = UIAlertAction(title: "Ok", style: .Default, handler: { (action:UIAlertAction) -> Void in
                    
                })
                alert.addAction(alertAction)
                self.presentViewController(alert, animated: true, completion: nil)
                return
        }
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let deviceType = "\(UIDevice.currentDevice().model) - \(UIDevice.currentDevice().systemName) - \(UIDevice.currentDevice().systemVersion)"
        let deviceId = NSUUID().UUIDString
        APIClient.sharedClient.loginWithEmail(email, password: password, deviceType: deviceType, deviceId: deviceId, completionSuccess: { (worlds:[World]) -> Void in
            self.performSegueWithIdentifier("ShowWorldsSegue", sender: worlds)
            }) { (error) -> Void in
                let alert = UIAlertController(title: "Error while requesting data", message: error.localizedDescription, preferredStyle: .Alert)
                
                let alertAction = UIAlertAction(title: "Ok", style: .Default, handler: { (action:UIAlertAction) -> Void in
                    
                })
                alert.addAction(alertAction)
                self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // this logic should be in Controller class
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let worldsVC = segue.destinationViewController as? Worlds,
           let worlds = sender as? [World] {
            worldsVC.worlds = worlds
        }
        
    }
    
    
}
