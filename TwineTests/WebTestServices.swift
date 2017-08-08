//
//  WebServices.swift
//  RadTab
//
//  Created by troy simon on 6/14/17.
//  Copyright © 2017 Gym Farm LLC. All rights reserved.
//

import Foundation
import UIKit


class WebTestServices {
    
    static let sharedInstance = WebTestServices()
    
    
    func getEmails(completion: @escaping (_ json: NSDictionary,_ error:NSInteger) -> ()) {
        
        readJson()
        
         var objects:NSDictionary =  NSDictionary()
        
        let path = Bundle.main.path(forResource: "GetEmail", ofType: "json")
        let data = NSData(contentsOfFile: path!)!
        
        do {
            
                objects = try (JSONSerialization.jsonObject(with: data as Data, options: []) as! NSDictionary).mutableCopy() as! NSDictionary
                
                completion(objects,200)
            
        } catch {
            // failure
            print("Fetch failed: \((error as NSError).localizedDescription)")
        }
     }
    
    
    func setEmails(emailID:Int32,completion: @escaping (_ json: NSDictionary,_ error:NSInteger) -> ()) {
        
     }
    
    
    
    private func readJson() {
        do {
            if let file = Bundle.main.url(forResource: "GetEmail", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    print(object)
                } else if let object = json as? [Any] {
                    // json is an array
                    print(object)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
}
