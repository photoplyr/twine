//
//  TwineTests.swift
//  TwineTests
//
//  Created by troy simon on 8/7/17.
//  Copyright © 2017 Gym Farm LLC. All rights reserved.
//

import XCTest

class TwineTests: XCTestCase {
    
  
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    
        testValidCallToGetEmails()
        testValidCallToSetEmails()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testValidCallToGetEmails() {
       
        WebTestServices.sharedInstance.getEmails { (emails, error) in
            if (error == 200) {
                
            } else {
             XCTFail("Status code: \(error)")
            }
        }
    }
    
    func testValidCallToSetEmails() {
        
        WebTestServices.sharedInstance.setEmails(emailID: 0) { (data, error) in
            if (error == 200) {
            } else {
                XCTFail("Status code: \(error)")
            }
        }
    }
    
 
}
