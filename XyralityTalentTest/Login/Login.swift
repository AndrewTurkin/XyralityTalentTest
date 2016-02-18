//
//  Login.swift
//  XyralityTalentTest
//
//  Created by Andrew Turkin on 2/18/16.
//  Copyright © 2016 andrew.turkin. All rights reserved.
//

import UIKit
import Alamofire

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
        loginWithEmail(email, password: password, deviceType: deviceType, deviceId: deviceId, completionSuccess: { (worlds:[World]) -> Void in
            self.performSegueWithIdentifier("ShowWorldsSegue", sender: worlds)
            }) { (error) -> Void in
                let alert = UIAlertController(title: "Error while requesting data", message: error.localizedDescription, preferredStyle: .Alert)
                
                let alertAction = UIAlertAction(title: "Ok", style: .Default, handler: { (action:UIAlertAction) -> Void in
                    
                })
                alert.addAction(alertAction)
                self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    func loginWithEmail(email:String, password:String, deviceType:String, deviceId:String,
        completionSuccess:(worlds:[World]) -> Void,
        completionFail:(error:NSError) -> Void) {
            
            
        
        let endpoint = "http://backend1.lordsandknights.com/XYRALITY/WebObjects/BKLoginServer.woa/wa/worlds"
        
        let params = ["login": email,
                      "password":password,
                      "deviceType": deviceType,
                      "deviceId":deviceId]
        
        Alamofire.request(.POST, endpoint, parameters: params)
            .response { request, response, data, error in
                
                // deserialize plist response
                do {
                    let dict = try NSPropertyListSerialization.propertyListWithData(data!, options: .MutableContainersAndLeaves, format: nil) as! NSDictionary
                    
                    guard let worlds = self.deserialize(dict) else {
                        completionFail(error: NSError(domain: "Can't deserialize plist", code: -1, userInfo: nil))
                        return
                    }
                    
                    completionSuccess(worlds: worlds)
                    
                }
                catch let error as NSError {
                    completionFail(error: error)
                }
        }
            
            
    }
    
    func deserialize(worldsDict:NSDictionary) -> [World]? {
        
        guard let allWorlds = worldsDict["allAvailableWorlds"] else {
            return nil
        }
        
        var worlds:[World] = []

        for aWorld in allWorlds as! Array<NSDictionary> {
            
            // validate
            guard let country = aWorld["country"] as? String,
                  let name = aWorld["name"] as? String,
                  let worldStatus = aWorld["worldStatus"] as? NSDictionary,
                  let status = worldStatus["description"] as? String else {
                    return nil
            }
            
            // create array of Worlds
            let world = World()
            world.country = country
            world.name = name
            world.status = status
            worlds += [world]
        }
        
        return worlds
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let worldsVC = segue.destinationViewController as? Worlds,
           let worlds = sender as? [World] {
            worldsVC.worlds = worlds
        }
        
    }
    
    
}
