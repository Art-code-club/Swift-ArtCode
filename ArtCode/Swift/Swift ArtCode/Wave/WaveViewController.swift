//
//  WaveViewController.swift
//  Creative Coding Practice
//
//  Created by Fomagran on 2021/12/01.
//

import UIKit

struct Point {
    var x:CGFloat
    var y:CGFloat
    var max:CGFloat
    var min:CGFloat
    var addY:CGFloat
    var center:CGPoint {
        return CGPoint(x: x, y: y)
    }
}

struct Line {
    let layer:CAShapeLayer
    let p1:Int
    let p2:Int
    var color:UIColor
}

class WaveViewController: UIViewController {

    private var timer : Timer?
    private var points:[Point] = []
    private var h:CGFloat = 0
    private var lineCount:Int = 3
    private var dotCount:Int = 4
    private let colors:[UIColor] = [.systemPink,.systemGreen,.systemRed,.systemBlue,.systemCyan,.systemMint,.systemTeal,.systemOrange,.systemYellow,.systemPurple]
    private var lines:[Line] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK:- Help Functions
    
    func configure() {
        let w:CGFloat = self.view.frame.width/CGFloat(dotCount+1)
        let center = self.view.center.y
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        h = self.view.center.y
        for i in 1...dotCount {
            let x:CGFloat = w*CGFloat(i)
            let y:CGFloat = center
            let max:CGFloat = CGFloat.random(in: 30...120)
            let min:CGFloat = CGFloat.random(in: (-120)...(-30))
            let addY:CGFloat = CGFloat(i%2) == 0 ? -1:1
            points.append(Point(x: x, y: y, max: max, min: min, addY: addY))
        }
        
        for _ in 0..<lineCount {
            lines.append(Line(layer:CAShapeLayer(),p1: (0..<points.count).randomElement()!, p2: (0..<points.count).randomElement()!, color: (colors.randomElement()!)))
        }
    }
    
    private func addCurve(line:Line,p1:Int,p2:Int) {
        line.layer.removeFromSuperlayer()
        let height:CGFloat = self.view.frame.height
        let width:CGFloat = self.view.frame.width
        let linePath = UIBezierPath()
        linePath.move(to:CGPoint(x: 0, y:height))
        linePath.addLine(to:CGPoint(x: 0, y:height/2))
        linePath.addCurve(to:CGPoint(x: width, y:height/2), controlPoint1:points[p1].center, controlPoint2:points[p2].center)
        linePath.addLine(to: CGPoint(x: width, y: height))
        line.layer.path = linePath.cgPath
        line.layer.fillColor = line.color.withAlphaComponent(0.4).cgColor
        view.layer.addSublayer(line.layer)
    }
    
    //MARK:- @objc Functions
    
    @objc
    func timerCallback() {
        for i in 0..<points.count {
            points[i].y += points[i].addY
            if points[i].y > h + points[i].max  || points[i].y < h + points[i].min {
                points[i].addY = -(points[i].addY)
            }
        }
        
        for i in 0..<lineCount {
            addCurve(line:lines[i],p1:lines[i].p1,p2:lines[i].p2)
        }
    }
}
