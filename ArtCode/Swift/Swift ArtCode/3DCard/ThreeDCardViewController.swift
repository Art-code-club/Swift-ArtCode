//
//  3DCardViewController.swift
//  Swift ArtCode
//
//  Created by Fomagran on 2021/12/16.
//

import UIKit

class ThreeDCardViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bgView = ThreeDCardView(frame: CGRect(x: -150, y:-150, width: 300, height: 270))
        setGradient(view: bgView)
        setTransform(bgView: bgView)
    }
    
    func setGradient(view:UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.white.withAlphaComponent(1).cgColor,
            UIColor.white.withAlphaComponent(0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.75)
        gradientLayer.endPoint = CGPoint(x:0.0,y:1.0)
        view.layer.mask = gradientLayer
    }
    
    func setTransform(bgView:UIView) {
        var perspective = CATransform3DIdentity
        perspective.m34 = -1 / 500
        let transformLayer = CATransformLayer()
        transformLayer.transform = perspective
        transformLayer.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        transformLayer.addSublayer(bgView.layer)
        view.layer.addSublayer(transformLayer)
        bgView.layer.transform = CATransform3DMakeRotation(0.3, 0, 1, 0)
    }
    
    func playAnimation(view:UIView) {
        let anim = CABasicAnimation(keyPath: "transform")
        anim.fromValue = CATransform3DMakeRotation(0.5, 0, 2, 0)
        anim.toValue = CATransform3DMakeRotation(-0.5, 0, 2, 0)
        anim.duration = 1
        anim.autoreverses = true
        anim.repeatCount = 10
        view.layer.add(anim, forKey: "transform")
    }
}
