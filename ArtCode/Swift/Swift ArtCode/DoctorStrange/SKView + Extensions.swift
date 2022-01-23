//
//  SKView + Extensions.swift
//  Creative Coding Practice
//
//  Created by Fomagran on 2021/12/19.
//

import Foundation
import SpriteKit

extension SKView {
 convenience init(withEmitter name: String) {
  self.init()

  self.frame = UIScreen.main.bounds
  backgroundColor = .clear

  let scene = SKScene(size: self.frame.size)
  scene.backgroundColor = .clear

  guard let emitter = SKEmitterNode(fileNamed: name + ".sks") else { return }
  emitter.name = name
  emitter.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)

  scene.addChild(emitter)
  presentScene(scene)
 }
}
