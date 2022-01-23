//
//  TestViewController.swift
//  Creative Coding Practice
//
//  Created by Fomagran on 2021/12/19.
//

import UIKit

class TestViewController: UIViewController {
    let redDot1 = UIView()
    var points:[CGPoint] = []
    override func viewDidLoad() {
        super.viewDidLoad()
       circle()
        redDot1.frame = CGRect(x: 495, y: 495, width: 10, height: 10)
        redDot1.backgroundColor = .red
        view.addSubview(redDot1)
        
        for i in 0..<5 {
            let startAngle = CGFloat.pi/180 * (270 - CGFloat(i)*72)
            let point = CGPoint(x: redDot1.center.x + 200 * cos(startAngle),
                                y: redDot1.center.y + 200 * sin(startAngle))
            points.append(point)
        }
        
        for i in 1..<5 {
            drawLine(c1: points[i-1], c2: points[i])
        }
        drawLine(c1: points[0], c2: points[points.count-1])
    }
    
    func circle() {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 500, y: 500), radius: CGFloat(200), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 3.0
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(x: 0, y: 0, width:1000, height:1000)
        gradient.colors = [UIColor.systemOrange.cgColor, UIColor.systemYellow.cgColor]
        gradient.mask = shapeLayer
        view.layer.addSublayer(gradient)
    }
    
    func drawLine(c1:CGPoint,c2:CGPoint) {
        let path = UIBezierPath()
        path.move(to: c1)
        path.addLine(to: c2)
        
        let pathLayer = CAShapeLayer()
        pathLayer.frame = view.bounds
        pathLayer.path = path.cgPath
        pathLayer.strokeColor = UIColor.gray.cgColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 2
        pathLayer.lineJoin = CAShapeLayerLineJoin.bevel
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(x: 0, y: 0, width:1000, height:1000)
        gradient.colors = [UIColor.systemOrange.cgColor, UIColor.systemYellow.cgColor]
        gradient.mask = pathLayer
        view.layer.addSublayer(gradient)
    }
}
