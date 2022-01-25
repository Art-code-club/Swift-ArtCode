//
//  MacMillerViewController.swift
//  Creative Coding Practice
//
//  Created by Fomagran on 2022/01/21.
//

import UIKit
import AVFoundation

class MacMillerViewController: UIViewController {
    
    // MARK: - Properties
    
    var iv:UIImageView!
    var glitchView:GlitchView!
    let particle = Particle()
    var random:[CGFloat] = [1,0,0,1,0,1,0,1]
    var player: AVAudioPlayer!
    private var timer: Timer?
    private let updateInterval = 1
    private let animatioтDuration = 0.05
    private let maxPowerDelta: CGFloat = 30
    
    lazy var panGestureRecognizer:
    UIPanGestureRecognizer = {
        let gestureRecognizer = UIPanGestureRecognizer()
        gestureRecognizer
            .addTarget(self, action: #selector(handleDrag(sender:)))
        return gestureRecognizer
    }()
    
    lazy var particleEmitter: CAEmitterLayer = {
        let emitter = CAEmitterLayer()
        emitter.emitterShape = .point
        emitter.renderMode = .additive
        return emitter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSound()
        iv = UIImageView(image: UIImage(named: "macmiller.png"))
        iv.frame = CGRect(origin: .zero, size: CGSize(width: 200, height: 250))
        iv.center = view.center
        view.addSubview(iv)
        view.backgroundColor = .systemRed
        iv.isUserInteractionEnabled = true
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        iv.addGestureRecognizer(doubleTap)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handTap))
        tap.numberOfTapsRequired = 1
        iv.addGestureRecognizer(tap)
        iv.addGestureRecognizer(panGestureRecognizer)
        tap.require(toFail: doubleTap)
//        timerStart()
    }
    
    func springAnimation(gview:UIView?,scale:CGFloat) {
        let v = gview == nil ? iv : gview
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity:0.1, options:[]) {
            v!.layer.transform = CATransform3DMakeScale(1.3,1.3,1)
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                v!.layer.transform = CATransform3DMakeScale(1,1,1)
            }
        }
    }
    
    func showGlitch(scale:CGFloat) {
        let glitchView = GlitchView(frame:CGRect(x:0, y:0, width: 200, height: 250))
        glitchView.bounds.origin = CGPoint(x: iv.center.x-100, y: iv.center.y-125)
        view.addSubview(glitchView)
        glitchView.decode = random
        glitchView.center = iv.center
        iv.isHidden = true
        glitchView.isHidden = false
        springAnimation(gview: glitchView,scale:scale)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            glitchView.removeFromSuperview()
            self.iv.isHidden = false
        }
        let random1 = (0...10).randomElement()!
        let random2 = (0...10).randomElement()!
        let random3 = 0
        let random4 = 1
        let random5 = 0
        let random6 = 1
        random = [ CGFloat(1), CGFloat(0),
                   CGFloat(random1),CGFloat(random2),CGFloat(random3),CGFloat(random4),CGFloat(random5),CGFloat(random6)]
    }
    
    func setSound() {
        guard let url = Bundle.main.url(forResource: "Clubhouse", withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.isMeteringEnabled = true
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func timerStart() {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(updateInterval),
                                     target: self,
                                     selector: #selector(self.updateMeters),
                                     userInfo: nil,
                                     repeats: true)
        player.play()
    }
    
    
    
    // Calculate average power from all channels
    private func averagePowerFromAllChannels() -> CGFloat {
        var power: CGFloat = 0.0
        (0..<player.numberOfChannels).forEach { (index) in
            power = power + CGFloat(player.averagePower(forChannel: index))
        }
        return power
    }
    
    // MARK: - Actions
    
    func showStars() {
        particleEmitter.emitterCells = [particle]
        self.view.layer.addSublayer(particleEmitter)
    }
    
    @objc func handleDrag(sender: UIPanGestureRecognizer) {
        iv.center = sender.location(in: self.view)
        particleEmitter.emitterPosition = sender.location(in: self.view)
        if sender.state == .ended {
            particleEmitter.lifetime = 0
        } else if sender.state == .began {
            showStars()
            particleEmitter.lifetime = 1.0
        }
    }
    
    func showParticle(_ posistion:CGPoint) {
        particleEmitter.emitterPosition = posistion
        showStars()
        particleEmitter.lifetime = 1.0
    }
    
    //MARK:- @obfc
    
    @objc func handTap(sender:UITapGestureRecognizer) {
        showGlitch(scale:1.3)
    }
    
    @objc func handDoubleTap(sender:UITapGestureRecognizer) {
        springAnimation(gview: nil,scale: 1.3)
    }
    
    @objc private func updateMeters() {
        player.updateMeters()
        let power = averagePowerFromAllChannels()
        let scale = (power + 20)/10
        if scale > 0 {
            if scale > 1.3 {
                showGlitch(scale: scale)
            }else {
                springAnimation(gview: nil, scale: scale)
            }
        }
    }
}



