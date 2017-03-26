//
//  ViewController.swift
//  Calculator
//
//  Created by Razr on 24/03/2017.
//  Copyright © 2017 Razr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel! //= nil
    
    var userIsInTheMiddleOftyping = false
    var ifPotIsExist = false
    var tem: Double!
    var sign: String = "null"
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOftyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
            
        }else {
            display.text = digit
            if display.text != "0" {
                userIsInTheMiddleOftyping = true
            }
            
        }
        
    }
    
    @IBAction func touchPot(_ sender: UIButton) {
        let pot = sender.currentTitle!
        if ifPotIsExist == false {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + pot
            userIsInTheMiddleOftyping = true
            ifPotIsExist = true
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    
    @IBAction func performOperation(_ sender: UIButton) {
        userIsInTheMiddleOftyping = false
        if let mathematicalSymbol = sender.currentTitle {
            switch mathematicalSymbol {
            case "%":
                displayValue = displayValue * 0.01
            case "+/-":
                displayValue = displayValue * -1
            default:
                break
            }
        }
    }
    
    @IBAction func operation(_ sender: UIButton) {
        userIsInTheMiddleOftyping = false
        if sign != "null" {
            equal(sender)
        }
        if display.text != "ERROR" {
            tem = displayValue
        }
        if let operationSymbol = sender.currentTitle {
            switch operationSymbol {
            case "+":
                sign = "+"
            case "–":
                sign = "–"
            case "x":
                sign = "x"
            case "÷":
                sign = "÷"
            default:
                break
            }
        }
    }
    
    
    
    @IBAction func clear(_ sender: UIButton) {
        display.text = "0"
        sign = "null"
        userIsInTheMiddleOftyping = false
        ifPotIsExist = false
    }
    
    
    @IBAction func equal(_ sender: UIButton) {
        userIsInTheMiddleOftyping = false
        if sign != "null" {
            switch sign {
            case "+":
                displayValue = tem + displayValue
            case "–":
                displayValue = tem - displayValue
            case "x":
                displayValue = tem * displayValue
            case "÷":
                if displayValue == 0 {
                    display.text = "ERROR"
                }else {
                    displayValue = tem / displayValue
                }
            default:
                break
            }
            sign = "null"
        }
    }
    
}

