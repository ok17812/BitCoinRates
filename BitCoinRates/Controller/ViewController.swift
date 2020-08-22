//
//  ViewController.swift
//  ByteCoinRates
//
//  Created by Evan Chang on 8/22/20.
//  Copyright © 2020 Evan Chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CoinManagerDelegate {
    
    @IBOutlet weak var currencypicker: UIPickerView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var bitcoinLabel: UILabel!
    
    var coinmanager = CoinManager()
    
    override func viewDidLoad() {
         super.viewDidLoad()
         
         coinmanager.delegate = self
         currencypicker.dataSource = self
         currencypicker.delegate = self

     }

    func didUpdatePrice(price: String, currency: String) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = price
            self.currencyLabel.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinmanager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinmanager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedcurrency = coinmanager.currencyArray[row]
        coinmanager.getCoinPrice(for: selectedcurrency)
        bitcoinLabel.text = selectedcurrency
    }

    
 

}
