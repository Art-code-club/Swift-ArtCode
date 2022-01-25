//
//  Particle.swift
//  Creative Coding Practice
//
//  Created by Fomagran on 2022/01/21.
//

import UIKit

public class Particle: CAEmitterCell {
    
    override init() {
        super.init()
        self.birthRate = 5
        self.lifetime = 1.0
        self.velocity = 100
        self.velocityRange = 50
        self.emissionLongitude = 90
        self.emissionRange = .pi
        self.spinRange = 5
        self.scale = 0.5
        self.scaleRange = 0.25
        self.alphaSpeed = -1
        self.contents = UIImage(named: "macmiller.png")!.cgImage!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
