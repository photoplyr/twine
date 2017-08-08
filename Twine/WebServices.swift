
//
//  WebServices.swift
//  RadTab
//
//  Created by troy simon on 6/14/17.
//  Copyright © 2017 Gym Farm LLC. All rights reserved.
//

import Foundation
import UIKit


class WebServices {
    
    let SERVER:String = "https://s3.us-east-2.amazonaws.com/twine-public/apis"
    
    
    static let sharedInstance = WebServices()
    
    
    func getEmails(completion: @escaping (_ json: NSDictionary,_ response:URLResponse) -> ()) {
        
        var objects:NSDictionary =  NSDictionary()
        
        let server : NSString = String(format: "%@/twine-mail-get.json",SERVER) as NSString
        
        let request = NSMutableURLRequest(url: URL(string: server as String)!,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            do {
                
                if (data != nil) {
                    objects = try (JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary).mutableCopy() as! NSDictionary
                    
                    completion(objects,response!)
                }
                
            } catch {
                // failure
                print("Fetch failed: \((error as NSError).localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    
    func setEmails(emailID:Int32,completion: @escaping (_ json: NSDictionary,_ response:URLResponse) -> ()) {
        
        var objects:NSDictionary =  NSDictionary()
        
        let server : NSString = String(format: "%@/emails/%i",SERVER,emailID) as NSString
        
        let request = NSMutableURLRequest(url: URL(string: server as String)!,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            do {
                
                if (data != nil) {
                    objects = try (JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary).mutableCopy() as! NSDictionary
                    
                    completion(objects,response!)
                }
                
            } catch {
                // failure
                print("Fetch failed: \((error as NSError).localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    
    
    
}
