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
    private var line = CAShapeLayer()
    
    
    
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
    
    private func addLine(start: CGPoint, toPoint end:CGPoint) {
        line.removeFromSuperlayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.strokeColor = UIColor.red.cgColor
        line.lineWidth = 2
        line.lineJoin = CAShapeLayerLineJoin.round
        self.view.layer.addSublayer(line)
    }
    
    //MARK:- IBActions
    
    @IBAction func dragSquare(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in:square)

        self.square.center = CGPoint(x: self.square.center.x + translation.x, y: self.square.center.y + translation.y)
        sender.setTranslation(.zero, in:self.square)
        
        if sender.state == .began {
            let location = sender.location(in: view)
            gapX = square.center.x - location.x
            gapY = square.center.y - location.y
            
            let point:CGPoint = CGPoint(x: square.center.x - gapX, y: square.center.y - gapY)
            changeRedDotColor(.red)
            changeRedDotLocation(point)
            
        }else if sender.state == .changed {
            let point:CGPoint = sender.location(in: view)
            redDot2.center = point
            addLine(start: redDot1.center, toPoint:redDot2.center)
        }else if sender.state == .ended {
            self.changeRedDotColor(.clear)
            self.line.strokeColor = UIColor.clear.cgColor
        }
    }
}
