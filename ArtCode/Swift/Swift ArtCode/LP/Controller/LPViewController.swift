//
//  LPViewController.swift
//  Creative Coding Practice
//
//  Created by Fomagran on 2022/01/08.
//

import UIKit
import AVFoundation

class LPViewController: UIViewController {
    
    //MARK:- UI
    
    @IBOutlet weak var scrollView: UIScrollView!

    let pathLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 5
        layer.strokeColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
        
    var needle: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "needle.jpg")
        iv.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    var aperture:UIView = {
        let v = UIView()
        v.backgroundColor = .systemMint
        return v
    }()
    
    //MARK:- Properties
    
    var player: AVAudioPlayer?
    var bezier: QuadBezier!
    var line = CAShapeLayer()
    let cons = LPConstants()
    var bigLPView:LPView!
    var currentLP:LP!
    var lpViews = [LPView]()
    var niddleLineEnd = CGPoint()
    var radius:CGFloat = 0
    var smallLps:[LPView] = []
    var setBigLP:Bool = false
    var isPlaying:Bool = false
    var transformView:TransformView!
    var transformLPView:LPView!
    var originalTransform:CATransform3D!
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK:- Help Functions
    
    
    func configure() {
        view.backgroundColor = .white
        radius = self.view.frame.width/3
        setBigLPView()
        setNeedle()
        setTransformView()
        setSmallLPViews()
        setScrollView()
        setAperture()
    }
    
    func findClosestLP() -> (LPView,Int) {
        var minDistance = Int.max
        var minLP = (bigLPView!,0)
        for (i,lp) in smallLps.enumerated() {
            if lp.center.x - scrollView.contentOffset.x < 0 {
                continue
            }
            let distance = abs(lp.center.x - scrollView.contentOffset.x - bigLPView.center.x)
            if minDistance > Int(distance) {
                minDistance = Int(distance)
                minLP = (lp,i)
            }
        }
        return minLP
    }
    
    private func setBigLPView() {
        let lp = LP(title:cons.musics[0], color: .red, musicName:cons.musics[0],album:UIImage(named: cons.albums[0])!)
        bigLPView = LPView(frame: CGRect(x: 0, y: 0, width: radius, height: radius),lp:lp)
        currentLP = bigLPView.LP
        view.addSubview(bigLPView)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.dragLP(_:)))
        bigLPView.addGestureRecognizer(panGesture)
        bigLPView.parent = self
        bigLPView.isHidden = true
    }
    
    @objc func dragLP(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self.view)
        if sender.state == .began {
            UIView.animate(withDuration: 0.1) {
                let scale = CGAffineTransform(scaleX: 1, y: 1)
                self.bigLPView.transform = scale
            }
        }else if sender.state == .changed {
            bigLPView.center = location
            let distance = abs(scrollView.frame.minY - location.y)
            if distance < bigLPView.frame.height/2 {
                aperture.isHidden = false
            }else {
                aperture.isHidden = true
            }
            let minLP = findClosestLP()
            aperture.center.x =  minLP.0.frame.maxX
        }else {
            if aperture.isHidden {
                UIView.animate(withDuration: 0.1) {
                    let scale = CGAffineTransform(scaleX: 2, y: 2)
                    self.bigLPView.transform = scale
                    self.bigLPView.center = self.view.center
                }
            }else {
                setBigLP = false
                bigLPView.isHidden = true
                let minLP = findClosestLP()
                let x = minLP.0.center.x + smallLps[0].frame.width
                for lp in smallLps  {
                    if minLP.0.center.x < lp.center.x {
                        lp.center.x += smallLps[0].frame.width
                    }
                    if lp.center.x < 0 {
                        lp.center.x = x
                    }
                }
                view.backgroundColor = .white
                scrollView.contentSize.width += smallLps[0].frame.width
                aperture.isHidden = true
            }
        }
    }
    
    func setTransformView() {
        transformView = TransformView(frame:CGRect(x:view.center.x, y: view.center.y, width:radius*2, height: radius*2))
        transformView.center = view.center
        transformLPView = LPView(frame: transformView.bounds, lp: bigLPView.LP)
        transformView.addSubview(transformLPView)
        originalTransform = transformView.layer.transform
        view.addSubview(transformView)
        transformView.isHidden = true
    }
    
    func setAperture() {
        aperture.frame = CGRect(origin:.zero, size:CGSize(width: 5, height:radius/3*4))
        aperture.center = CGPoint(x:view.center.x - 2.5,y:0)
        scrollView.addSubview(aperture)
        aperture.isHidden = true
    }
    
    func setScrollView() {
        self.scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentOffset = CGPoint(x:radius/3,y:0)
    }
    
    func updateBigLPView(lp:LP,isDrag:Bool) {
        setMusicPlayer(lp: lp)
        self.currentLP = lp
        self.bigLPView.update(lp:currentLP)
        self.transformLPView.update(lp: currentLP)
        if !isDrag {
            self.view.backgroundColor = self.currentLP.averageColor
        }
    }
    
    func setSmallLPViews() {
        var x:CGFloat = 0
        for i in 0..<cons.colors.count {
            let lp = LP(title:cons.musics[i], color:cons.colors[i], musicName: cons.musics[i],album:UIImage(named:cons.albums[i])!)
            let lpView = LPView(frame: CGRect(x:x, y: 0, width:radius/3*2, height: radius/3*2),lp:lp)
            smallLps.append(lpView)
            scrollView.addSubview(lpView)
            scrollView.contentSize.width = lpView.frame.width * CGFloat(i + 1)
            lpViews.append(lpView)
            lpView.parent = self
            x += radius/3*2
        }
    }
        
    func setMusicPlayer(lp:LP) {
        let url = Bundle.main.url(forResource:lp.musicName, withExtension: "mp3")!
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.prepareToPlay()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    private func setNeedle() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.drag(_:)))
        needle.addGestureRecognizer(panGesture)
        bezier = setCurvedPath()
        pathLayer.path = bezier.path.cgPath
        needle.center = bezier.point(at: 0.3)
        niddleLineEnd = CGPoint(x: view.bounds.maxX, y: view.bounds.midY)
        addLine(start:CGPoint(x: needle.center.x + 20, y: needle.center.y), end:niddleLineEnd)
        view.layer.addSublayer(pathLayer)
        view.addSubview(needle)
    }
    
    private func addLine(start: CGPoint, end:CGPoint) {
        line.removeFromSuperlayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.strokeColor = UIColor.darkGray.cgColor
        line.lineWidth = 3
        view.layer.addSublayer(line)
    }
    
    func setCurvedPath() -> QuadBezier {
        let bounds = view.bounds
        let point1 = CGPoint(x: bounds.maxX, y: bounds.minY + 100)
        let point2 = CGPoint(x: bounds.maxX, y: bounds.maxY - 100)
        let controlPoint = CGPoint(x: bounds.maxX - CGFloat(radius), y: bounds.midY)
        let path = QuadBezier(point1: point1, point2: point2, controlPoint: controlPoint)
        return path
    }
    
    func updateNeedlePosition(_ position:CGPoint) {
        let location = position
        let t = (location.y - view.bounds.minY) / view.bounds.height
        needle.center.y = bezier.point(at: t).y
        needle.center.x = bezier.point(at: t).x - 20
        addLine(start:bezier.point(at: t), end:niddleLineEnd)
        touchLP(needle.center)
    }
    
    func touchLP(_ needle:CGPoint) {
        if abs(needle.y - bigLPView.center.y) < 15 {
            if transformLPView.layer.animation(forKey: "rotation") == nil {
                startPlaying()
            }
        }else {
            stopPlaying()
        }
    }
    
    func startPlaying() {
        self.bigLPView.isHidden = true
        self.transformView.isHidden = false
        transformLPView.rotate()
        player?.play()
        isPlaying = true
        bigLPView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 2) {
            var transform = CATransform3DIdentity
            transform.m34 = CGFloat(-1) / self.transformView.bounds.width
            transform = CATransform3DRotate(transform, 0.85 * .pi/2, 1, 0, 0)
            self.transformView.layer.transform = transform
        }
    }
    
    func stopPlaying() {
        if isPlaying {
            self.isPlaying = false
            self.player?.stop()
            UIView.animate(withDuration:3) {
                self.transformView.layer.transform = self.originalTransform
            }completion: { _ in
                self.transformLPView.layer.removeAllAnimations()
                self.transformView.isHidden = true
                self.bigLPView.isHidden = false
                self.bigLPView.isUserInteractionEnabled = true
                
            }
        }
    }
    
    //MARK:- @objc
    
    @objc func drag(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self.view)
        updateNeedlePosition(location)
    }
}

//MARK:- LPViewDelegate

extension LPViewController:LPViewDelegate {
    func viewDragged(lpView:LPView,sender:UIPanGestureRecognizer) {
        if !setBigLP {
            let location = sender.location(in: view)
            if sender.state == .began {
                updateBigLPView(lp: lpView.LP,isDrag: true)
                bigLPView.center = location
                bigLPView.isHidden = false
            }else if sender.state == .changed {
                bigLPView.center = location
            }else if sender.state == .ended {
                let distance = abs(scrollView.frame.minY - location.y)
                if distance > bigLPView.frame.height/2 {
                    var centerX:CGFloat = 0
                    for lp in smallLps {
                        if lp.LP.title == lpView.LP.title {
                            centerX = lp.center.x
                            lp.center.x = -500
                            break
                        }
                    }
                    bigLPView.center = self.view.center
                    bigLPView.isHidden = false
                    let scale = CGAffineTransform(scaleX: 2, y: 2)
                    self.bigLPView.transform = scale
                    self.view.backgroundColor = lpView.LP.averageColor
                    setBigLP = true
                    for lp in smallLps  {
                        if centerX < lp.center.x {
                            lp.center.x -= smallLps[0].frame.width
                        }
                    }
                    scrollView.contentSize.width -= smallLps[0].frame.width
                }else {
                    let scale = CGAffineTransform(scaleX: 1, y: 1)
                    self.bigLPView.transform = scale
                    bigLPView.isHidden = true
                }
            }
        }
    }
}

class TransformView: UIView {
    class func layerClass() -> AnyClass {
        return CATransformLayer.self
    }
}
