//
//  3DCardViewController.swift
//  Swift ArtCode
//
//  Created by Fomagran on 2021/12/16.
//

import UIKit

class ThreeDCardViewController: UIViewController {
    
    var bgView:ThreeDCardView!
    var cardViews:[ThreeDCardView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeCardViews()
    }
    
    func makeCardViews() {
        let mid = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY)
        let images:[UIImage] = [UIImage(named: "Tree.png")!,UIImage(named: "Night.jpeg")!,UIImage(named: "fomagran.png")!]
        for i in 0..<images.count {
            var cardView:ThreeDCardView = ThreeDCardView()
            if i == 0{
                cardView = ThreeDCardView(frame: CGRect(x: 0, y:0, width:600, height:500))
                cardView.center = CGPoint(x: mid.x, y: mid.y)
            }else {
                let last = cardViews.last!
                cardView = ThreeDCardView(frame: CGRect(x: 0, y:0, width:last.frame.width/3*2, height:last.frame.height/3*2))
                cardView.center = CGPoint(x:last.center.x - cardView.frame.width/2, y: mid.y)
            }
            cardView.configure(image:images[i])
            setTransform(bgView: cardView)
            cardViews.append(cardView)
        }
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
