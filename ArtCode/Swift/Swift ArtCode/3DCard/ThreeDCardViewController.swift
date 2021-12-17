//
//  3DCardViewController.swift
//  Swift ArtCode
//
//  Created by Fomagran on 2021/12/16.
//

import UIKit

class ThreeDCardViewController: UIViewController {
    
    var bgView:ThreeDCardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let bgView1 = ThreeDCardView(frame: CGRect(x: 0, y:0, width: bgView.frame.width/3*2, height: bgView.frame.height/3*2))
//        bgView1.center = CGPoint(x: bgView.center.x-bgView.frame.width/3, y: bgView.center.y)
//        bgView1.configure(image:UIImage(named:"Tree.png")!)
//        setTransform(bgView: bgView1)
        
        bgView = ThreeDCardView(frame: CGRect(x:0, y:0, width: 600, height: 540))
        bgView.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY)
        bgView.configure(image:UIImage(named:"Night.jpeg")!)
        setTransform(bgView: bgView)
        setDrag()
    }
    
    func leftFlipAnimation(card:UIView) {
        card.isHidden = false
        UIView.animate(withDuration: 1, delay: 0, options:.curveEaseIn, animations: {
            card.frame.size.width = 600
            card.frame.size.height = 540
            print(card.frame.width,card.frame.height)
            card.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY)
            card.layer.transform = CATransform3DMakeRotation(0.1, 0, 1, 0)
        })
    }
    
    func rightFlipAnimation(card:UIView) {
        UIView.animate(withDuration: 1, delay: 0, options:.curveEaseOut, animations: {
            card.frame.size.width = card.frame.size.width*2
            card.frame.size.height = card.frame.size.height*2
            card.layer.transform = CATransform3DMakeRotation(0.5, 0, 1, 0)
            card.center = CGPoint(x: self.view.frame.width, y: self.view.frame.midY)
        }) { _ in
            card.isHidden = true
        }
    }
    
    func setDrag() {
        let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(leftSwiped))
        leftSwipeRecognizer.numberOfTouchesRequired = 1
        leftSwipeRecognizer.direction = .left
        view.addGestureRecognizer(leftSwipeRecognizer)
        let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(rightSwiped))
        rightSwipeRecognizer.numberOfTouchesRequired = 1
        rightSwipeRecognizer.direction = .right
        view.addGestureRecognizer(rightSwipeRecognizer)
    }
    
    @objc private func leftSwiped(recognizer: UISwipeGestureRecognizer) {
        leftFlipAnimation(card: bgView)
    }
    
    @objc private func rightSwiped(recognizer: UISwipeGestureRecognizer) {
       rightFlipAnimation(card: bgView)
    }
    
    func setTransform(bgView:UIView) {
        var perspective = CATransform3DIdentity
        perspective.m34 = -1 / 500
        let transformLayer = CATransformLayer()
        transformLayer.transform = perspective
        transformLayer.position = CGPoint(x: 0, y:0)
        transformLayer.addSublayer(bgView.layer)
        view.layer.addSublayer(transformLayer)
        bgView.layer.transform = CATransform3DMakeRotation(0.05, 0, 1, 0)
    }
    @IBAction func tapRightButton(_ sender: Any) {
        rightFlipAnimation(card: bgView)
    }
    @IBAction func tapLeftButton(_ sender: Any) {
        leftFlipAnimation(card: bgView)
    }
    
}
