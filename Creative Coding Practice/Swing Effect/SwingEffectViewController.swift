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
        view.backgroundColor = .systemYellow
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
    
    private var gapX:Double = 0
    private var gapY:Double = 0
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
    
    func createDisplayLink() {
        let displaylink = CADisplayLink(target: self,
                                        selector: #selector(step))
        displaylink.add(to: .current,
                        forMode:.common)
        displayLink = displaylink
    }
         
    @objc func step(displaylink: CADisplayLink) {
        
        if floor(redDot1.center.x) == floor(goal.x) && floor(redDot1.center.y) == floor(goal.y){
            displaylink.invalidate()
            return
        }
        if floor(redDot1.center.x) != floor(goal.x) {
            redDot1.center.x += redDot1.center.x < goal.x ? 1 : -1
        }
        
        if floor(redDot1.center.y) != floor(goal.y) {
            redDot1.center.y += redDot1.center.y < goal.y ? 1 : -1
        }
        addLine(start: redDot1.center, toPoint: redDot2.center)
    }
    
    //MARK:- Help Functions
    
    func setLayout() {
        square.frame = CGRect(x: self.view.center.x, y: self.view.center.y, width: 60, height: 60)
        redDot1.frame = CGRect(x: self.view.center.x, y: self.view.center.y, width: 10, height: 10)
        redDot2.frame = CGRect(x: self.view.center.x, y: self.view.center.y, width: 10, height: 10)
        self.view.addSubview(square)
        self.view.addSubview(redDot1)
        self.view.addSubview(redDot2)
    }
    
    private func configure() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.dragSquare(_:)))
        square.addGestureRecognizer(panGesture)
        changeRedDotColor(.clear)
        setLayout()
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
    
    private func getTwoPointAngle(center:CGPoint,p1: CGPoint, p2: CGPoint) -> CGFloat {
        let v1 = CGVector(dx: p1.x - center.x, dy: p1.y - center.y)
        let v2 = CGVector(dx: p2.x - center.x, dy: p2.y - center.y)
        let angle = atan2(v2.dy, v2.dx) - atan2(v1.dy, v1.dx)
        let deg = angle * CGFloat(180.0/Double.pi)
        return deg < 0 ? deg + 360 : deg
    }
    
    private func getNewPoint(p2:CGPoint) -> CGPoint {
        if p2.x <= square.center.x  {
            //1
            if p2.y <= square.center.y {
                return CGPoint(x: p2.x+50, y: p2.y+50)
            //3
            }else {
                return CGPoint(x: p2.x+50, y: p2.y-50)
            }
        }else {
            //2
            if p2.y <= square.center.y {
                return CGPoint(x: p2.x-50, y: p2.y+50)
            //4
            }else {
                return CGPoint(x: p2.x-50, y: p2.y-50)
            }
        }
    }
    
    private func getAngle(p2:CGPoint) -> CGFloat {
        if p2.x <= square.center.x  {
            //1
            if p2.y <= square.center.y {
                return 45
            //3
            }else {
                return -45
            }
        }else {
            //2
            if p2.y <= square.center.y {
                return -45
            //4
            }else {
                return 45
            }
        }
    }
    
    //MARK:- Actions
    
    @objc func dragSquare(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            let location = sender.location(in: view)
            gapX = square.center.x - location.x
            gapY = square.center.y - location.y
            let point:CGPoint = CGPoint(x: square.center.x - gapX, y: square.center.y - gapY)
            changeRedDotColor(.red)
            redDot1.center = point
        }else if sender.state == .changed {
            redDot2.center = sender.location(in: view)
            self.addLine(start: redDot1.center, toPoint:redDot2.center)
            let distance:CGFloat = getTwoPointDistance(redDot1.center,redDot2.center)
            
            if distance > 150 {
                UIView.animate(withDuration: 0.5) {
                    self.createDisplayLink()
                    self.goal = self.getNewPoint(p2: self.redDot2.center)
                    self.square.rotate(degrees:self.getAngle(p2: self.redDot2.center))
                    self.square.center = CGPoint(x:self.goal.x + self.gapX, y:self.goal.y + self.gapY)
                } completion: { _ in
                    self.line.strokeColor = UIColor.clear.cgColor
                }
            }
        }else if sender.state == .ended {
            UIView.animate(withDuration: 0.4) {
                self.square.rotate(degrees:0)
                self.changeRedDotColor(.clear)
                self.line.strokeColor = UIColor.clear.cgColor
            }
        }
    }
}

extension UIView {
    func rotate(degrees: CGFloat) {
        let degreesToRadians: (CGFloat) -> CGFloat = { (degrees: CGFloat) in
            return degrees / 180.0 * CGFloat.pi
        }
        self.transform =  CGAffineTransform(rotationAngle: degreesToRadians(degrees))
    }
}
