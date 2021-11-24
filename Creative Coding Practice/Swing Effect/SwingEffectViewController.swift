//
//  SwingEffectViewController.swift
//  Creative Coding Practice
//
//  Created by Fomagran on 2021/11/22.
//

import UIKit

class SwingEffectViewController: UIViewController {
    
    //MARK:- Properties
    
    let square:UIView = {
        let view:UIView = UIView()
        view.backgroundColor = .systemCyan
        return view
    }()
    
    let redDot1:UIView = {
        let view:UIView = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    let redDot2:UIView = {
        let view:UIView = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    let label:UILabel = {
        let label:UILabel = UILabel()
        label.text = "Fomagran"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private var gap:CGPoint = CGPoint()
    private var line = CAShapeLayer()
    private var startPoint = CGPoint()
    private var angle = CGFloat()
    var displayLink:CADisplayLink?
    var goal = CGPoint()
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK:- Help Functions
    
    func setLayout() {
        square.frame = CGRect(x: self.view.center.x, y: self.view.center.y, width: 200, height: 100)
        redDot1.frame = CGRect(x: self.view.center.x, y: self.view.center.y, width: 10, height: 10)
        redDot2.frame = CGRect(x: self.view.center.x, y: self.view.center.y, width: 10, height: 10)
        redDot1.layer.cornerRadius = 5
        redDot2.layer.cornerRadius = 5
        self.view.addSubview(square)
        label.frame = CGRect(x: self.square.center.x, y: self.square.center.y, width: 120, height: 50)
        self.view.addSubview(redDot1)
        self.view.addSubview(redDot2)
        self.view.addSubview(label)
    }
    
    private func configure() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.dragSquare(_:)))
        square.addGestureRecognizer(panGesture)
        changeRedDotColor(.clear)
        setLayout()
    }
    
    func createDisplayLink() {
        let displaylink = CADisplayLink(target: self,selector: #selector(checkRedDot1))
        displaylink.add(to: .current,forMode:.common)
        displayLink = displaylink
    }
    
    private func changeRedDotColor(_ color:UIColor) {
        redDot1.backgroundColor = color
        redDot2.backgroundColor = color
    }
    
    private func addLine(start: CGPoint, toPoint end:CGPoint) {
        line.removeFromSuperlayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.strokeColor = UIColor.red.cgColor
        line.lineWidth = 2
        view.layer.addSublayer(line)
    }
    
    private func getTwoPointDistance(_ point1:CGPoint,_ point2:CGPoint) -> CGFloat {
           let xDist:CGFloat = point2.x - point1.x
           let yDist:CGFloat = point2.y - point1.y
           return sqrt((xDist * xDist) + (yDist * yDist))
       }
    
    private func rotateAndChangeColor(angle:CGFloat,color:UIColor) {
        UIView.animate(withDuration: 0.4) {
            self.square.rotate(degrees:angle)
            self.label.rotate(degrees:angle)
            self.changeRedDotColor(color)
            self.line.strokeColor = color.cgColor
        }
    }
    
    //MARK:- Actions
    
    @objc func dragSquare(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            let location = sender.location(in: view)
            gap.x = square.center.x - location.x
            gap.y = square.center.y - location.y
            changeRedDotColor(.red)
            redDot1.center = CGPoint(x: square.center.x - gap.x, y: square.center.y - gap.y)
        }else if sender.state == .changed {
            redDot2.center = sender.location(in: view)
            addLine(start: redDot1.center, toPoint:redDot2.center)
            let distance:CGFloat = getTwoPointDistance(redDot1.center,redDot2.center)
            goal = square.getDestinationPoint(p2: redDot2.center)
            if distance > 100 {
                createDisplayLink()
                let angle:CGFloat = square.getAngle(p2:redDot2.center)
                rotateAndChangeColor(angle: angle, color: .systemRed)
            }
        }else if sender.state == .ended {
            rotateAndChangeColor(angle: 0, color: .clear)
        }
    }
    
    @objc func checkRedDot1(displaylink: CADisplayLink) {
        if round(redDot1.center.x) == round(goal.x) && round(redDot1.center.y) == round(goal.y){
            displaylink.invalidate()
            line.strokeColor = UIColor.clear.cgColor
            return
        }
        if round(redDot1.center.x) != round(goal.x) {
            redDot1.center.x += redDot1.center.x < goal.x ? 1: -1
            square.center.x = redDot1.center.x + gap.x
            label.center = square.center
        }
        
        if round(redDot1.center.y) != round(goal.y) {
            redDot1.center.y += redDot1.center.y < goal.y ? 1 : -1
            square.center.y = redDot1.center.y + gap.y
            label.center = square.center
        }
        addLine(start: redDot1.center, toPoint: redDot2.center)
    }
}
