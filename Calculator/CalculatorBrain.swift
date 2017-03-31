//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Razr on 30/03/2017.
//  Copyright © 2017 Razr. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    
    private var temresult: Double?
    
    private var equalTemp: Double?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
        case clear
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "±" : Operation.unaryOperation({ -$0 }),
        "%" : Operation.unaryOperation({ $0 * 0.01 }),
        "+" : Operation.binaryOperation({ $0 + $1 }),
        "–" : Operation.binaryOperation({ $0 - $1 }),
        "×" : Operation.binaryOperation({ $0 * $1 }),
        "÷" : Operation.binaryOperation({ $0 / $1 }),
        "=" : Operation.equals,
        "C" : Operation.clear
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    temresult = function(accumulator!)
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                temresult = nil
                if pendingBinaryOperation != nil && accumulator != nil {
                    performPendingBinaryOperation()
                    accumulator = temresult
                }
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                if pendingBinaryOperation != nil && accumulator != nil {
                    equalTemp = accumulator
                    temPerformPendingBinaryOperation = PendingBinaryOperation2(function: pendingBinaryOperation!.function, secondOperand: equalTemp!)
                }
                
                if pendingBinaryOperation == nil && temPerformPendingBinaryOperation != nil {
                    temresult = temPerformPendingBinaryOperation!.perform(with: temresult!)
                }
                performPendingBinaryOperation()
            case .clear:
                accumulator = nil
                temresult = nil
                pendingBinaryOperation = nil
            }
        }
    }
    
    
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            temresult = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
            accumulator = temresult
        }
        
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private var temPerformPendingBinaryOperation: PendingBinaryOperation2?
    
    private struct PendingBinaryOperation {
        let function: (Double,Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return  function(firstOperand,secondOperand)
        }
    
    }
    
    private struct PendingBinaryOperation2 {
        let function: (Double,Double) -> Double
        let secondOperand: Double
        
        func perform(with firstOperand: Double) -> Double {
            return  function(firstOperand,secondOperand)
        }
        
    }


    mutating func setOperand(_ operand: Double) {
        
        accumulator = operand
        
    }
    
    var result: Double? {
        get {
            return temresult
        }
    }
}
