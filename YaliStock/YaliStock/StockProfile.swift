//
//  StockProfile.swift
//  YaliStock
//
//  Created by Yali Sun on 10/31/20.
//

import Foundation

class StockProfile {
    
    var symbol: String! = ""
    var price : Double = 0.0
    var companyName : String = ""
    var industry : String = ""
    var website : String = ""
    var description : String = ""
    var ceo : String = ""
    var fullTimeEmployees : Int = 0
    var imageURL : String = ""
    
    init(_ symbol : String) {
        self.symbol = symbol
    }
}
