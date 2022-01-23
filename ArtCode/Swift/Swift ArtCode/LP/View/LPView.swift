//
//  LPView.swift
//  Creative Coding Practice
//
//  Created by Fomagran on 2022/01/08.
//

import UIKit

protocol LPViewDelegate: AnyObject {
    func viewDragged(lpView:LPView,sender: UIPanGestureRecognizer)
}

class LPView: UIView {
    
    var LP:LP!
    weak var parent: LPViewDelegate?
    var centerView:UIImageView!
    
    init(frame: CGRect,lp:LP) {
        super.init(frame: frame)
        LP = lp
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.dragLP(_:)))
        drawLP(lp.color)
        setCenterView(color:lp.color)
        addGestureRecognizer(panGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawLP(_ color:UIColor) {
        var radius = frame.width/2
        for i in 0..<10 {
            radius -= radius/20
            if i == 0 {
                drawCircle(radius, 0.0)
                continue
            }
            drawCircle(radius, 0.5)
        }
    }
    
    func setCenterView(color:UIColor) {
        centerView = UIImageView()
        centerView.frame = CGRect(x: bounds.midX - frame.height/4, y: bounds.midY - frame.height/4, width: frame.width/2, height: frame.height/2)
        centerView.backgroundColor = color
        centerView.image = LP.album
        centerView.contentMode = .scaleAspectFit
        centerView.layer.cornerRadius = centerView.frame.height/2
        centerView.layer.masksToBounds = true
        addSubview(centerView)
    }
    
    func update(lp:LP) {
        self.centerView.backgroundColor = lp.color
        self.centerView.image = lp.album
    }
    
    @objc func dragLP(_ sender: UIPanGestureRecognizer) {
        parent?.viewDragged(lpView:self,sender:sender)
    }
    
    func drawCircle(_ radius:CGFloat,_ lineWidth:CGFloat) {
        let circleLayer = CAShapeLayer()
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius:radius, startAngle: 0.0, endAngle: CGFloat(Double.pi * 2.0), clockwise: true)
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.black.cgColor
        circleLayer.strokeColor = UIColor.darkGray.cgColor
        circleLayer.lineWidth = lineWidth
        circleLayer.strokeEnd = 1.0
        layer.addSublayer(circleLayer)
    }
}
