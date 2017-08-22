//
//  CurrencyDataSource.swift
//  MoviesFromJson
//
//  Created by Tomer Buzaglo on 21/08/2017.
//  Copyright © 2017 iTomerBu. All rights reserved.
//

import UIKit

class CurrencyDataSource{
    static func getRates(handler: @escaping ([Currency])->Void){
        let address = "http://api.fixer.io/latest?base=ILS"
        
        let url = URL(string: address)!
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else{return}
            
            let ratesObject = try! JSONSerialization.jsonObject(with: data, options: []) as! JsonObject
            
            let base = ratesObject["base"] as! String
            let date = ratesObject["date"] as! String
            
            
            let ratesDict = ratesObject["rates"] as! [String: Double]
            
            var currencies = [Currency]()
            
            for (currencyCode, exchangeRate) in ratesDict{
                let currency = Currency(currencyCode: currencyCode, exchangeRate: exchangeRate)
                currencies.append(currency)
            }
            
            DispatchQueue.main.async {
                //run on UI Thread in android
                handler(currencies)
            }
            
        }
        
        task.resume()
    }
}























class Currency : CustomStringConvertible{
    let currencyCode:String
    let exchangeRate:Double
    
    init(currencyCode:String, exchangeRate:Double) {
        self.currencyCode = currencyCode
        self.exchangeRate = exchangeRate
    }
    
    var description: String{
        return "\(currencyCode) : \(exchangeRate)"
    }
}
