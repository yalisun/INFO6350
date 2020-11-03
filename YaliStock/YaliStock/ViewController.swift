//
//  ViewController.swift
//  YaliStock
//
//  Created by Yali Sun on 10/31/20.
//

import UIKit
import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var symbolInput: UITextField!
    @IBOutlet weak var ceoText: UILabel!
    @IBOutlet weak var priceText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reset()
    }

    @IBAction func getValue(_ sender: UIButton) {
        guard let symbol = self.symbolInput.text else {return}
        let url = getURL(symbol: symbol)
        AF.request(url).responseJSON { (response) in
            if response.error == nil {
                
                // Get JSON String and convert it into JSON Array
                guard let jsonString = response.data else { return }
                guard let stocks: [JSON] = JSON(jsonString).array else { return }
                
                // If there are no stocks return
                if stocks.count < 1 { return }
                
                for stock in stocks {
                    let stockProfile = self.getStockProfileFromJSON(stock: stock)
                    if stockProfile.symbol == "NONE" {
                        self.reset()
                        return
                    }
                    // check the first and break, as we only query one
                    self.ceoText.text = stockProfile.ceo
                    self.priceText.text = String(stockProfile.price)
                    return
                }
            } else {
                self.reset()
            }
        }
    }
    
    func reset() {
        self.ceoText.text = ""
        self.priceText.text = ""
    }
    
    func getURL(symbol: String) -> String {
        var url = apiURL
        url.append(symbol)
        url.append("?apikey=\(apiKey)")
        return url
    }
    
    func getStockProfileFromJSON(stock : JSON) -> StockProfile {
        let defaultStock = StockProfile("NONE")
        guard let symbol = stock["symbol"].rawString() else {return defaultStock}
        guard let price = stock["price"].double  else {return defaultStock}
        guard let companyName = stock["companyName"].rawString() else {return defaultStock}
        guard let industry = stock["industry"].rawString() else {return defaultStock}
        guard let website = stock["website"].rawString() else {return defaultStock}
        guard let description = stock["description"].rawString() else {return defaultStock}
        guard let ceo = stock["ceo"].rawString() else {return defaultStock}
       
        let stockProfile = StockProfile(symbol)
        stockProfile.price = price
        stockProfile.companyName = companyName
        stockProfile.industry = industry
        stockProfile.website = website
        stockProfile.description = description
        stockProfile.ceo = ceo
       
        return stockProfile
    }
    
}

