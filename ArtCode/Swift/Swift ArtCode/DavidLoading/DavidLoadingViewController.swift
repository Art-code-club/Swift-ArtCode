//
//  DavidLoadingViewController.swift
//  Creative Coding Practice
//
//  Created by Fomagran on 2021/12/23.
//

import UIKit

class DavidLoadingViewController: UIViewController {
    
    let david:UIImageView = UIImageView(image: UIImage(named:"david.png"))
    let pinkwall:UIImageView = UIImageView(image: UIImage(named:"pinkwall.png"))
    let palmtree:UIImageView = UIImageView(image: UIImage(named:"palmtree.png"))
    var animator : UIDynamicAnimator!
    var gravity : UIGravityBehavior!
    let davidLength:CGFloat = 60
    let pinkLength:CGFloat = 150
    lazy var pinkCross = pinkLength*sqrt(2)/2
    lazy var davidCross = davidLength*sqrt(2)/2
    var yGap:Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        palmtree.frame = CGRect(x: view.frame.midX-175, y: view.frame.midY-175, width: 350, height: 350)
        view.addSubview(palmtree)
        palmtree.layer.cornerRadius = palmtree.frame.height/2
        palmtree.layer.masksToBounds = true
        pinkwall.frame = CGRect(x: view.frame.midX-75, y: view.frame.midY-75, width: pinkLength, height: pinkLength)
        view.addSubview(pinkwall)
        david.frame = CGRect(x:0, y:0, width: davidLength, height: davidLength)
        view.addSubview(david)
        pinkwall.transform = pinkwall.transform.rotated(by: -.pi/4)
        david.transform = david.transform.rotated(by: .pi/4)
        david.center = CGPoint(x: view.frame.midX + davidCross, y: pinkwall.center.y - pinkCross)
        palmtree.alpha = 0
        pinkwall.alpha = 0
        david.alpha = 0
    }
    
    func davidLoading(pinkwall:UIView) {
        yGap = (david.center.y + davidLength/2) - (view.center.y - pinkLength/2)
        drawArc(centerPoint:CGPoint(x:david.center.x+15, y: david.center.y - yGap/2), startPoint: david.center, angle:180)
        UIView.animate(withDuration: 2.7,delay:0.75) {
            self.david.transform = self.david.transform.rotated(by: -.pi/4)
            pinkwall.transform = pinkwall.transform.rotated(by: -.pi/4)
        } completion: { _ in
            UIView.animate(withDuration: 2,delay: 0) {
                self.david.transform = self.david.transform.rotated(by: -.pi/8)
                pinkwall.transform = pinkwall.transform.rotated(by: -.pi/8)
                self.david.center.x -= 32.5
                self.david.center.y -= 22.5
            } completion: { _ in
                UIView.animate(withDuration: 2,delay: 0) {
                    self.david.transform = self.david.transform.rotated(by:.pi/8)
                    pinkwall.transform = pinkwall.transform.rotated(by: -.pi/8)
                    self.david.center.x -= 40
                    self.david.center.y -= 10
                } completion: { _ in
                    UIView.animate(withDuration: 2,delay: 0) {
                        let davidX = self.view.frame.midX + 12
                        self.david.center.x = davidX
                    } completion: { _ in
                        UIView.animate(withDuration: 1.5) {
                            self.david.transform = self.david.transform.rotated(by:.pi/4)
                            self.david.center.x += 30
                            self.david.center.y = pinkwall.center.y - self.pinkCross
                        } completion: { _ in
                            self.davidLoading(pinkwall: pinkwall)
                        }
                    }
                }
            }
        }
    }
    
    func addCollison() {
        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior(items: [david])
        animator.addBehavior(gravity)
        let collision = UICollisionBehavior(items: [david, pinkwall])
        collision.addBoundary(withIdentifier: "barrier" as NSCopying, for: UIBezierPath(rect: pinkwall.frame))
        animator.addBehavior(collision)
    }
    
    func drawArc(centerPoint: CGPoint, startPoint: CGPoint, angle: CGFloat) {
        let radius = getRadius(center: centerPoint, start: startPoint)
        let start = getStartAngle(center: centerPoint, point: startPoint, radius: radius)
        let end = getEndAngle(startAngle: start, angle: angle)
        let arcPath = UIBezierPath()
        arcPath.move(to: startPoint)
        arcPath.addArc(withCenter: centerPoint, radius: radius, startAngle: start, endAngle: end, clockwise: false)
        arcAnimation(path: arcPath)
    }
    
    func arcAnimation(path:UIBezierPath) {
        david.layer.removeAnimation(forKey: "animate position along path")
        UIView.animate(withDuration: 3) {
            self.david.layer.position = CGPoint(x: self.david.center.x + 30, y: self.david.center.y - self.yGap)
        }
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.repeatCount = 1
        animation.duration = 3.0
        david.layer.add(animation, forKey: "animate position along path")
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
    }
    
    func getRadius(center: CGPoint, start: CGPoint) -> CGFloat {
        let xDist: CGFloat = start.x - center.x
        let yDist: CGFloat = start.y - center.y
        let radius: CGFloat = sqrt((xDist * xDist) + (yDist * yDist))
        return radius
    }
    
    func getStartAngle(center: CGPoint, point: CGPoint, radius: CGFloat) -> CGFloat {
        let origin = CGPoint(x: center.x + radius, y: center.y)
        let v1 = CGVector(dx: origin.x - center.x, dy: origin.y - center.y)
        let v2 = CGVector(dx: point.x - center.x, dy: point.y - center.y)
        let angle = atan2(v2.dy, v2.dx) - atan2(v1.dy, v1.dx)
        return angle
    }
    
    func getEndAngle(startAngle: CGFloat, angle: CGFloat) -> CGFloat {
        return (angle * (.pi / 180)) + startAngle
    }
    @IBAction func tapShowDavidLoading(_ sender: Any) {
        UIView.animate(withDuration: 2) {
            self.view.backgroundColor = UIColor(displayP3Red: 55, green: 55, blue: 55, alpha: 0.2)
            self.palmtree.alpha = 1
            self.pinkwall.alpha = 1
            self.david.alpha = 1
        }
        davidLoading(pinkwall: pinkwall)
    }
}
