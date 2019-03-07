//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var currentCurrencyIndex = 0
    let currencySymbol = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
    }

    
    //MARK: - UIPickerView delegate methods
    
    // Function to determine how many columns in picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Function for how many rows picker should have
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }

    // Function to fill picker row tiles from array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    // Function called every time the picker is scrolled.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        currentCurrencyIndex = row
        print(finalURL)
        getBitcoinPrice(url: finalURL)
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    func getBitcoinPrice(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the Bitcoin price")
                    let bitcoinJSON : JSON = JSON(response.result.value!)

                    self.updatePriceData(json: bitcoinJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }

    

    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updatePriceData(json : JSON) {
        
        if let priceResult = json["ask"].double {
            bitcoinPriceLabel.text = currencySymbol[currentCurrencyIndex] + String(priceResult)
       }else{
            bitcoinPriceLabel.text = "Currency Unavailable"
        }
        
    }
    




}

