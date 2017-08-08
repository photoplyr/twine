//
//  WebServiceTest.swift
//  Twine
//
//  Created by troy simon on 8/7/17.
//  Copyright © 2017 Gym Farm LLC. All rights reserved.
//


@testable import Twine

import Quick
import Nimble
import Mockingjay

class NativeApiClientSpec : QuickSpec {
    var returnedEmailData: NSArray?
    
    
    override func spec() {
        super.spec()
        
        describe("getEmails") {
            context("get") {
                it("it should return a json of type array when server response is a array of json object") {
                    
                    WebServices.sharedInstance.getEmails(completion: { (data,response) in
                        
                        if let httpResponse = response as? HTTPURLResponse {
                            
                            switch (httpResponse.statusCode)  {
                                
                            case 200:
                                self.returnedEmailData = data.object(forKey: "emails") as? NSArray
                                
                            default:
                                fatalError()
                            }
                        }
                        
                    })
                    
                    expect(self.returnedEmailData).toEventuallyNot(beNil(),timeout: 20)
                    
                }
            }
        }
        
        
        describe("setEmails") {
            context("get") {
                
                it("it should return a json of type array when server response is a array of json object") {
                    
                    WebServices.sharedInstance.setEmails(emailID: 0,completion: { (data, response) in
                        if let httpResponse = response as? HTTPURLResponse {
                            
                            switch (httpResponse.statusCode)  {
                                
                            case 200:
                                self.returnedEmailData = data.object(forKey: "emails") as? NSArray
                                
                            default:
                                fatalError()
                            }
                        }

                    })
                }
            }
        }
        
        
        describe("Builds Email Lists") {
            context("set") {
                it("it should return an dictionary of data") {
                    
                    let client:EmailClientViewController = EmailClientViewController()
                    
                
                    if let emails:NSMutableDictionary = client.buildLists(data: self.returnedEmailData!) {
                        
                    } else {
                         fatalError()
                    }
                    
                }
                
            }
        }
        
    }
}
