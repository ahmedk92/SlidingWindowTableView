//
//  Model.swift
//  SlidingWindowTableView
//
//  Created by Ahmed Khalaf on 2/22/19.
//  Copyright © 2019 Ahmed Khalaf. All rights reserved.
//

import Foundation

class Model {
    let id: Int
    var text: String?
    
    private static let queue = DispatchQueue(label: "ModelQueue")
    
    init(id: Int) {
        self.id = id
        
        if (320...360).contains(id) {
            loadText()
        }
    }
    
    func loadText() {
        guard text == nil else { return }

        self.text = "\(id)     " + randomText(length: Int.random(in: 500...1000))
    }
    
    func loadTextAsync() {
        Model.queue.async {
            self.loadText()
        }
    }
}

func randomText(length: Int, justLowerCase: Bool = false) -> String {
    var text = ""
    for _ in 1...length {
        var decValue = 0  // ascii decimal value of a character
        var charType = 3  // default is lowercase
        if justLowerCase == false {
            // randomize the character type
            charType =  Int(arc4random_uniform(4))
        }
        switch charType {
        case 1:  // digit: random Int between 48 and 57
            decValue = Int(arc4random_uniform(10)) + 48
        case 2:  // uppercase letter
            decValue = Int(arc4random_uniform(26)) + 65
        case 3:  // lowercase letter
            decValue = Int(arc4random_uniform(26)) + 97
        default:  // space character
            decValue = 32
        }
        // get ASCII character from random decimal value
        let char = String(UnicodeScalar(decValue)!)
        text = text + char
        // remove double spaces
        text = text.replacingOccurrences(of: "  ", with: " ")
    }
    return text
}
