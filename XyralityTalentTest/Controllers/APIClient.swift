//
//  APIClient.swift
//  XyralityTalentTest
//
//  Created by Andrew Turkin on 2/19/16.
//  Copyright © 2016 andrew.turkin. All rights reserved.
//

import Alamofire

class APIClient {
    class var sharedClient:APIClient {
        struct SharedClient {
            static let instance = APIClient()
        }
        
        return SharedClient.instance
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
}

