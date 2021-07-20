//
//  Item.swift
//  LootLogger
//
//  Created by Riccardo Carlotto on 10/06/2021.
//

import UIKit

class Item: Equatable, Codable {
    
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    var dateCreated: Date
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.name == rhs.name && lhs.dateCreated == rhs.dateCreated && lhs.serialNumber == rhs.serialNumber && lhs.valueInDollars == rhs.valueInDollars
    }
    
    init(name: String, valueInDollars: Int, serialNumber: String?) {
        self.name = name
        self.valueInDollars = valueInDollars
        self.serialNumber = serialNumber
        self.dateCreated = Date()
    }
    
    convenience init(random: Bool = false) {
        if random {
            let adjectives = ["Fluffy", "Rusty", "Shiny"]
            let nouns = ["Bear", "Spork", "Mac"] // ["Bear Spork Mac 1234 ldfa iaifadf adfkjfaldkfjaldsfj"]
            
            let randomAdjecive = adjectives.randomElement()!
            let randomNoun = nouns.randomElement()!
            
            let randomName = "\(randomAdjecive) \(randomNoun)"
            let randomValue = Int.random(in: 0..<100)
            let randomSerialNumber = UUID().uuidString.components(separatedBy: "-").first!
            
            self.init(name: randomName, valueInDollars: randomValue, serialNumber: randomSerialNumber)
            
            
        } else {
            self.init(name: "", valueInDollars: 0, serialNumber: nil)
        }
    }
}
