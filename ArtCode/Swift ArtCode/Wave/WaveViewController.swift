//
//  WaveViewController.swift
//  Creative Coding Practice
//
//  Created by Fomagran on 2021/12/01.
//

import UIKit

class WaveViewController: UIViewController {
    
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
    
    let redDot3:UIView = {
        let view:UIView = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    let redDot4:UIView = {
        let view:UIView = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    let redDot5:UIView = {
        let view:UIView = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    let redDot6:UIView = {
        let view:UIView = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        

        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.moveRedDot(redDot: self.redDot2,duration: 0.8,move: 100)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.moveRedDot(redDot: self.redDot3,duration: 0.8,move: 100)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.moveRedDot(redDot: self.redDot4,duration: 0.8,move: 100)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.77) {
            self.moveRedDot(redDot: self.redDot5,duration: 0.8,move: 100)
        }
    }

    
    func setLayout() {
        let w = self.view.frame.width/5
        redDot1.frame = CGRect(x:0, y:self.view.center.y, width: 10, height: 10)
        redDot1.layer.cornerRadius = 5
        self.view.addSubview(redDot1)
        
        redDot2.frame = CGRect(x:w*1, y:self.view.center.y, width: 10, height: 10)
        redDot2.layer.cornerRadius = 5
        self.view.addSubview(redDot2)
        
        redDot3.frame = CGRect(x:w*2, y:self.view.center.y, width: 10, height: 10)
        redDot3.layer.cornerRadius = 5
        self.view.addSubview(redDot3)
        
        redDot4.frame = CGRect(x:w*3, y:self.view.center.y, width: 10, height: 10)
        redDot4.layer.cornerRadius = 5
        self.view.addSubview(redDot4)
        
        redDot5.frame = CGRect(x:w*4, y:self.view.center.y, width: 10, height: 10)
        redDot5.layer.cornerRadius = 5
        self.view.addSubview(redDot5)
        
        redDot6.frame = CGRect(x:self.view.frame.width-10, y:self.view.center.y, width: 10, height: 10)
        redDot6.layer.cornerRadius = 5
        self.view.addSubview(redDot6)
    }
    
    func moveRedDot(redDot:UIView,duration:CGFloat,move:CGFloat) {
        UIView.animate(withDuration:duration) {
            redDot.center.y = self.view.center.y + move
        } completion: { _ in
            UIView.animate(withDuration: duration) {
                redDot.center.y = self.view.center.y - move
            } completion: { _ in
                self.moveRedDot(redDot:redDot,duration:duration,move: move)
            }
        }
    }
}
