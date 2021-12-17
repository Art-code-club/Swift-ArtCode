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
    var currentCardView:(Int,ThreeDCardView)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDrag()
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
        currentCardView = (0,cardViews[0])
    }
    
    func moveRight() {
        if currentCardView.0 == cardViews.count-1 {
            return
        }
        for i in currentCardView.0..<cardViews.count {
            let cardView = cardViews[i]
            if i == currentCardView.0 {
                rightFlipAnimation(card:cardView)
            }else {
                UIView.animate(withDuration: 1, delay: 0, options:.curveEaseIn, animations: {
                    cardView.center.x = cardView.frame.width + cardView.frame.width/2
                    let rotation = CATransform3DMakeRotation(0.05, 0, 1, 0)
                    let scale = CATransform3DMakeScale(1.5,1.5,1)
                    cardView.layer.transform = CATransform3DConcat(rotation,scale)
                })
            }
        }
        currentCardView = (currentCardView.0+1,cardViews[currentCardView.0+1])
    }
    
    func moveLeft() {
        if currentCardView.0 == 0 {
            return
        }
        for i in currentCardView.0-1..<cardViews.count{
            let cardView = cardViews[i]
            if i == currentCardView.0-1 {
               leftFlipAnimation(card: cardView)
            }else {
                UIView.animate(withDuration: 1, delay: 0, options:.curveEaseIn, animations: {
                    let rotation = CATransform3DMakeRotation(0.05, 0, 1, 0)
                    let scale = CATransform3DMakeScale(1,1,1)
                    cardView.center.x = self.cardViews[i-1].center.x - cardView.frame.width/2
                    cardView.layer.transform = CATransform3DConcat(rotation,scale)
                })
            }
        }
        currentCardView = (currentCardView.0-1,cardViews[currentCardView.0-1])
    }
    
    func leftFlipAnimation(card:UIView) {
        card.isHidden = false
        UIView.animate(withDuration: 1, delay: 0, options:.curveEaseIn, animations: {
            let rotation = CATransform3DMakeRotation(0.05, 0, 1, 0)
            let scale = CATransform3DMakeScale(1,1,1)
            card.layer.transform = CATransform3DConcat(rotation, scale)
            card.center.x = self.view.frame.midX
        })
    }
    
    func rightFlipAnimation(card:UIView) {
        UIView.animate(withDuration: 1, delay: 0, options:.curveEaseOut, animations: {
            let rotation = CATransform3DMakeRotation(0.5, 0, 1, 0)
            let scale = CATransform3DMakeScale(2,2,1)
            card.layer.transform = CATransform3DConcat(rotation, scale)
            card.center.x = self.view.frame.maxX
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
        moveLeft()
    }
    
    @objc private func rightSwiped(recognizer: UISwipeGestureRecognizer) {
        moveRight()
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
