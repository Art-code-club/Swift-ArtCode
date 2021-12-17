//
//  WaveView.swift
//  Creative Coding Practice
//
//  Created by Fomagran on 2021/12/05.
//

import UIKit

class WaveView: UIView {
    
    private var timer : Timer?
    private var points:[Point] = []
    private var lines:[Line] = []
    private lazy var centerY:CGFloat = frame.height/2
    private var lineCount:Int = 3
    private var dotCount:Int = 4
    private let colors:[UIColor] = [.systemPink,.systemBlue,.systemCyan,.systemMint,.systemTeal]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        putDots()
        appendLines()
    }
    
    private func putDots() {
        let w:CGFloat = self.bounds.width/CGFloat(dotCount+1)
        for i in 1...dotCount {
            let x:CGFloat = w*CGFloat(i)
            let max:CGFloat = CGFloat.random(in: centerY/2...centerY)
            let min:CGFloat = CGFloat.random(in: (-centerY)...(-centerY/2))
            let addY:CGFloat = CGFloat(i%2) == 0 ? -1:1
            points.append(Point(x: x, y: centerY, max: max, min: min, addY: addY))
        }
    }
    
    private func appendLines() {
        for _ in 0..<lineCount {
            lines.append(Line(layer:CAShapeLayer(),p1:(0..<dotCount).randomElement()!, p2:(0..<dotCount).randomElement()!, color: (colors.randomElement()!)))
        }
    }
    
    private func addCurve(line:Line,p1:Int,p2:Int) {
        line.layer.removeFromSuperlayer()
        let height:CGFloat = self.frame.height
        let width:CGFloat = self.frame.width
        let linePath = UIBezierPath()
        linePath.move(to:CGPoint(x: 0, y:height))
        linePath.addLine(to:CGPoint(x: 0, y:height/2))
        linePath.addCurve(to:CGPoint(x: width, y:height/2), controlPoint1:points[p1].center, controlPoint2:points[p2].center)
        linePath.addLine(to: CGPoint(x: width, y: height))
        line.layer.path = linePath.cgPath
        line.layer.fillColor = line.color.withAlphaComponent(0.4).cgColor
        layer.addSublayer(line.layer)
    }
    
    //MARK:- @objc Functions
    
    @objc func timerCallback() {
        updateLineCuve()
    }
    
    private func updateLineCuve() {
        for i in 0..<points.count {
            points[i].y += points[i].addY
            if points[i].y > centerY + points[i].max  || points[i].y < centerY + points[i].min {
                points[i].addY = -(points[i].addY)
            }
        }
        for i in 0..<lineCount {
            addCurve(line:lines[i],p1:lines[i].p1,p2:lines[i].p2)
        }
    }
    
    func changeColor() {
        for line in lines {
            line.layer.fillColor = UIColor.clear.cgColor
        }
        lines.removeAll()
        appendLines()
    }
}
