//
//  CoinManager.swift
//  ByteCoinRates
//
//  Created by Evan Chang on 8/22/20.
//  Copyright © 2020 Evan Chang. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "1049EC2C-1739-47E4-83C5-AC2DAA86CE92"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        //create a url
        if let url = URL(string: urlString) {
            
            //create a urlsession
            let session = URLSession(configuration: .default)
            
            //give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let bitcoinRate = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", bitcoinRate)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            
            //start the task
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double?{
        let decoder = JSONDecoder()
        do
        {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let rate = decodedData.rate
            return rate
            
        }
        catch
        {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
