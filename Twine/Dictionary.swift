//
//  EmailClientViewController.swift
//  Twine
//
//  Created by troy simon on 8/2/17.
//  Copyright © 2017 Gym Farm LLC. All rights reserved.
//

import UIKit

extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}
