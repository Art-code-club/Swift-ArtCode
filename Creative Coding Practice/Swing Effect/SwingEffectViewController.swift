//
//  SwingEffectViewController.swift
//  Creative Coding Practice
//
//  Created by Fomagran on 2021/11/22.
//

import UIKit

class SwingEffectViewController: UIViewController {

    //MARK:- IBOutlets
    
    @IBOutlet weak var redDot2: UIView!
    @IBOutlet weak var redDot1: UIView!
    @IBOutlet weak var square: UIView!
    
    //MARK:- Properties
    
    private var gapX:Double = 0
    private var gapY:Double = 0
    
    
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK:- Help Functions
    
    private func configure() {
        changeRedDotColor(.clear)
    }
    
    private func changeRedDotColor(_ color:UIColor) {
        redDot1.backgroundColor = color
        redDot2.backgroundColor = color
    }
    
    private func changeRedDotLocation(_ point:CGPoint) {
        redDot1.center = point
        redDot2.center = point
    }
    
    //MARK:- IBActions
    
    @IBAction func dragSquare(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in:square)
        square.center = CGPoint(x: square.center.x + translation.x, y: square.center.y + translation.y)
        sender.setTranslation(.zero, in:square)

        
        if sender.state == .began {
            let location = sender.location(in: view)
            let x = location.x
            let y = location.y
            
            gapX = square.center.x - x
            gapY = square.center.y - y

            changeRedDotColor(.red)
       
        }else if sender.state == .changed {
            let point:CGPoint = CGPoint(x: square.center.x - gapX, y: square.center.y - gapY)
            changeRedDotLocation(point)
        }else if sender.state == .ended {
            changeRedDotColor(.clear)
        }
    }
}
