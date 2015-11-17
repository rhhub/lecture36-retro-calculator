//
//  ViewController.swift
//  lecture36-retro-calculator
//
//  Created by Ryan Huebert on 11/16/15.
//  Copyright © 2015 Ryan Huebert. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    private enum Operation: String {
        case divide = "/"
        case multiply = "*"
        case subtract = "-"
        case add = "+"
        case empty = "empty"
    }
    
    @IBOutlet weak private var label: UILabel!
    
    private var btnSound: AVAudioPlayer?
    
    private var runningNumber = ""
    private var leftValStr = ""
    private var rightValStr = ""
    var result = ""
    
    private var currentOperation = Operation.empty
    private var userIsTyping = false
    private var equalsPressedNotFollowingOperation = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav") {
            let soundUrl = NSURL(fileURLWithPath: path)
            
            do {
                try btnSound = AVAudioPlayer(contentsOfURL: soundUrl)
                btnSound?.prepareToPlay()
            } catch let error {
                print(error)
            }
        }
    }

    @IBAction private func numberPressed(sender: UIButton) {
        playSound()
        
        if equalsPressedNotFollowingOperation {
            // Clear
            
            leftValStr = ""
            rightValStr = ""
            result = ""
            currentOperation = .empty
        }
        if !userIsTyping {
            runningNumber = ""
            userIsTyping = true
        }
        
        runningNumber += "\(sender.tag)"
        label.text = runningNumber
    }
    
    @IBAction private func onDividePressed(sender: UIButton) {
        appendOperation(Operation.divide)
    }
    
    @IBAction private func onMultiplyPressed(sender: UIButton) {
        appendOperation(Operation.multiply)
    }
    
    @IBAction private func onSubtractPressed(sender: UIButton) {
        appendOperation(Operation.subtract)
    }
    
    @IBAction private func onAddPressed(sender: UIButton) {
        appendOperation(Operation.add)
    }
    
    @IBAction private func onEqualPressed(sender: UIButton) {
        
//        print("leftValStr: \(leftValStr) ")
//        print("rightValStr: \(rightValStr)")
//        print("lavel.text: \(label.text)")
//        print("runningNumber: \(runningNumber)")
//        print("result: \(result)")
//        print("currentOperation: \(currentOperation)")
        
    equalsPressed()
        
//        print("leftValStr: \(leftValStr) ")
//        print("rightValStr: \(rightValStr)")
//        print("lavel.text: \(label.text)")
//        print("runningNumber: \(runningNumber)")
//        print("result: \(result)")
//        print("currentOperation: \(currentOperation)")

    }
    
    private func equalsPressed() {
        playSound()
        userIsTyping = false
        equalsPressedNotFollowingOperation = true
        
        if currentOperation != Operation.empty {
            // Run some math
            
            if runningNumber != "" {
                
                rightValStr = runningNumber
                
                let leftVal = Double(leftValStr)! //Double(result) != nil ? Double(result)! : 0.0
                let rightVal = Double(rightValStr)! //Double(storedNumeber) != nil ? Double(storedNumeber)! : 0.0
                
                switch currentOperation {
                case .add:
                    result = "\(leftVal + rightVal)"
                case .subtract:
                    result = "\(leftVal - rightVal)"
                case .multiply:
                    result = "\(leftVal * rightVal)"
                case .divide:
                    result = "\(leftVal / rightVal)"
                case .empty:
                    ()
                }
                
                leftValStr = result
                label.text = result
                
            }
        }
    }
    
    private func appendOperation(op: Operation) {
        playSound()
        userIsTyping = false
        equalsPressedNotFollowingOperation = false
        
        
            // First time pressed.
            if currentOperation == .empty {
                leftValStr = runningNumber
                runningNumber = ""
                
            }
        
        currentOperation = op
            
        
    }
    
    private func playSound() {
        if let sound = btnSound {
            if sound.playing {
                sound.stop()
                sound.play()
            }
        }
    }
}

