//
//  main.swift
//  Command Line Calculator
//
//  Created by Sunni Tang on 7/18/19.
//  Copyright © 2019 Sunni Tang. All rights reserved.
//

import Foundation

// Variables and Constants
var operations: ([String: (Double, Double) -> Double]) = ["+": { $0 + $1 },
                                                          "-": { $0 - $1 },
                                                          "*": { $0 * $1 },
                                                          "/": { $0 / $1 }]
var input:String?       // for getInput low-level calc
var inputArr = [String]()   // array of string nums without whitespace low-level calc
var operands = [Double]()   // array of two doubles
var op = String()           // +, -, /, *, ?

var inputArrForFM = [Int]()
var filterMapBy = [String]()
var sepNums = [String]()
var filterMapByInt = [Int]()

// A1. Get input (low-level)
func getInputA() {
    
    // 1a. Readline
    print("Enter an expression to be calculated by typing two operands separated by an operator (+, =, *, /, ?). Ex: 5+3")
    input = readLine()
    
    // 1b. Unwrap input, separate string by operator
    if let inputUnwrapped = input {
        if inputUnwrapped.contains("+") {
            op = "+"
            print("Adding \(inputUnwrapped)!")
        } else if inputUnwrapped.contains("-") {
            op = "-"
            print("Subtracting \(inputUnwrapped)!")
        } else if inputUnwrapped.contains("*") {
            op = "*"
            print("Multiplying \(inputUnwrapped)!")
        } else if inputUnwrapped.contains("/") {
            op = "/"
            print("Dividing \(inputUnwrapped)!")
        } else if inputUnwrapped.contains("?") {
            op = "?"
            print("Performing mystery calculation \(inputUnwrapped)!")
        } else {
            print("Are you sure you have a known operator? Use: +, -, *, /, or mystery operator ?")
        }
        inputArr = inputUnwrapped.components(separatedBy: op)
    }
    
    // 1c. Separate values into array, remove whitespaces
    for num in inputArr {
        operands.append(Double(num.trimmingCharacters(in: .whitespacesAndNewlines))!)
    }
    
    calculate()
}


// A2. Calculate values based on operators, guess mystery operator
func calculate() {
    let randomOp = operations.keys.randomElement()! // random op from dictionary
    var mysteryGuess: String?   // input for mystery guess
    
    if op == "+" || op == "-" || op == "*" || op == "/" {
        
        if let result = operations[op] {
            print(result(operands[0],operands[1]))
        }
        
    } else if op == "?" {
        
        if let result = operations[randomOp] {
            print(result(operands[0],operands[1]))
            print("Guess the mystery operator!")
            mysteryGuess = readLine()
            if let mysteryGuessUnwrapped = mysteryGuess {
                if mysteryGuessUnwrapped == randomOp {
                    print("You did it!")
                } else {
                    print("Wrong guess!")
                }
            }
        }
        
    }
}

// B1. Get input (high-level)
func getInputB() {
    print("Apply an operation to multiple numbers by following these formats:")
    print("Filter all numbers smaller or larger than a number. Ex: 1,2,3,4,5 by < 3")
    print("Add, subtract, multiply, or divide a number to each of the numbers. Ex: 1,2,3,4,5 by + 3")
    input = readLine()
    
    if let inputUnwrapped = input {
        if inputUnwrapped.contains("<") || inputUnwrapped.contains(">") || inputUnwrapped.contains(">=") || inputUnwrapped.contains("<=") {
            
            if inputUnwrapped.contains("<") {
                op = "<"
            } else if inputUnwrapped.contains(">") {
                op = ">"
            }  else if inputUnwrapped.contains("<=") {
                op = "<="
            }  else if inputUnwrapped.contains("<=") {
                op = "<="
            }
            print("Filtering numbers in \(inputUnwrapped)!")
            
        } else if inputUnwrapped.contains("*") || inputUnwrapped.contains("/") || inputUnwrapped.contains("+") || inputUnwrapped.contains("-"){
            
            if inputUnwrapped.contains("*") {
                op = "*"
            } else if inputUnwrapped.contains("/") {
                op = "/"
            }  else if inputUnwrapped.contains("+") {
                op = "+"
            }  else if inputUnwrapped.contains("-") {
                op = "-"
            }
            
            print("Mapping numbers in \(inputUnwrapped)!")
            
        } else {
            print("Are you sure you entered that correctly?")
        }
        
        inputArr = inputUnwrapped.components(separatedBy: "by \(op)")
        filterMapBy.append(inputArr.popLast()!)
        
        for string in inputArr {
            sepNums = string.components(separatedBy: ",")
        }
        
        inputArrForFM = sepNums.compactMap({Int($0.trimmingCharacters(in: .whitespacesAndNewlines))})
        filterMapByInt = filterMapBy.compactMap({Int($0.trimmingCharacters(in: .whitespacesAndNewlines))})
        
        if op == "<" || op == ">" || op == "<=" || op == ">=" {
            filter()
        } else if op == "+" || op == "-" || op == "*" || op == "/" {
            map()
        }
        
    }
}

// B2. Filter

func filter() {
    
    if op == "<" {
        let result = inputArrForFM.filter({ $0 < filterMapByInt[0]})
        print(result)
    } else if op == ">" {
        let result = inputArrForFM.filter({ $0 > filterMapByInt[0]})
        print(result)
    } else if op == "<=" {
        let result = inputArrForFM.filter({ $0 <= filterMapByInt[0]})
        print(result)
    } else if op == ">=" {
        let result = inputArrForFM.filter({ $0 >= filterMapByInt[0]})
        print(result)
    }
}

// B3. Map

func map() {
    
    if op == "+" {
        let result = inputArrForFM.map({ $0 + filterMapByInt[0]})
        print(result)
    } else if op == "-" {
        let result = inputArrForFM.map({ $0 - filterMapByInt[0]})
        print(result)
    } else if op == "*" {
        let result = inputArrForFM.map({ $0 * filterMapByInt[0]})
        print(result)
    } else if op == "/" {
        let result = inputArrForFM.map({ $0 / filterMapByInt[0]})
        print(result)
    }
    
}


// 0. Choose low-level or high-level
func welcome() {
    print("Welcome! Low-level or high-level operation? Return a for low-level, b for high-level.")
    input = readLine()
    
    if let inputUnwrapped = input {
        if inputUnwrapped.lowercased() == "a" {
            getInputA()
        } else if inputUnwrapped.lowercased() == "b" {
            getInputB()
        } else {
            print("Choose a or b!")
            welcome()
        }
        
    }
    
}


func playAgain() {
    print("Do another calculation? y/n")
    let yes = readLine()
    if let yesUnwrapped = yes {
        if yesUnwrapped.lowercased() == "y" {
            main()
        } else if yesUnwrapped.lowercased() != "n" {
            print("Are you sure you input that right?")
            playAgain()
        }
    }
}


func main() {
    welcome()
    playAgain()
}

main()
