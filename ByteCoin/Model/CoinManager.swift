//
//  CoinManager.swift
//  BitCoin
//
//  Created by Amirzhan Armandiyev on 16.06.2022.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCurrency(_ coinManager: CoinManager, _ currency: String, currencyRate: Double)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "2B102EDF-AD95-42EB-BCAD-147C4BDD24C8"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR","KZT"]
    
    var delegate: CoinManagerDelegate?
    
    func getURL(to currency: String) {
        let url = "\(baseURL)\(currency)?apikey=\(apiKey)"
        performRequest(url, currency)
    }
    
    func performRequest(_ urlString: String, _ currency: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, urlResponse, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(CurrencyRate.self, from: safeData)
                        self.delegate?.didUpdateCurrency(self, currency, currencyRate: decodedData.rate)
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
}
