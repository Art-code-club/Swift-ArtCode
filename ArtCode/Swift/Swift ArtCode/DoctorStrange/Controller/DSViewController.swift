//
//  DSViewController.swift
//  Creative Coding Practice
//
//  Created by Fomagran on 2021/12/18.
//


import UIKit
import SceneKit
import SpriteKit
import Speech

class DSViewController: UIViewController {
    
    @IBOutlet weak var speechButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-CA"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private let audioEngine = AVAudioEngine()
    private var recognitionTask: SFSpeechRecognitionTask?
    
    var check:Bool = false
    let imageView = UIImageView(image: UIImage(named: "skydoor.jpeg"))
    let spark = SKView(withEmitter: "Spark")
    let spark1 = SKView(withEmitter: "Spark")
    var square = SKView(withEmitter: "SquareSpark")
    var vc:String = "TestViewController"
    var whiteView:UIView!
    var starPoint:[CGPoint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        view.addSubview(spark)
        spark.isHidden = true
        view.addSubview(spark1)
        spark1.isHidden = true
        speechRecognizer?.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.imageViewTap(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        setStarPoint()
    }
    
    func drawCircle() {
        let circleView = CircleView(frame: CGRect(x:view.frame.midX-300, y:view.frame.midY-300, width:600, height:600))
        view.addSubview(circleView)
        circleView.animateCircle(duration: 2.0)
    }
    
    func drawStar() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x:view.frame.midX,y:view.frame.midY - 300))
        path.addLine(to: CGPoint(x:view.frame.midX - 200, y:view.frame.midY+230))
        path.addLine(to: CGPoint(x:view.frame.midX + 285, y:view.frame.midY-100))
        path.addLine(to: CGPoint(x:view.frame.midX - 285, y:view.frame.midY-100))
        path.addLine(to: CGPoint(x:view.frame.midX + 200, y:view.frame.midY+230))
        path.addLine(to: CGPoint(x:view.frame.midX, y:view.frame.midY - 300))
        
        let pathLayer = CAShapeLayer()
        pathLayer.frame = view.bounds
        pathLayer.path = path.cgPath
        pathLayer.strokeColor = UIColor.lightGray.cgColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 2
        pathLayer.lineJoin = CAShapeLayerLineJoin.bevel
        view.layer.addSublayer(pathLayer)
        
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 2.0
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1
        pathLayer.add(pathAnimation, forKey: "strokeEnd")
    }
    
    func setStarPoint() {
        spark.center = CGPoint(x:view.frame.midX,y:view.frame.midY - 300)
        starPoint = [ CGPoint(x:view.frame.midX - 200, y:view.frame.midY+230),
                CGPoint(x:view.frame.midX + 285, y:view.frame.midY-100),
                CGPoint(x:view.frame.midX - 285, y:view.frame.midY-100),
                CGPoint(x:view.frame.midX + 200, y:view.frame.midY+230),
                CGPoint(x:view.frame.midX, y:view.frame.midY - 300)]
    }
    
    func circleAnimation() {
        drawCircle()
        drawStar()
        spark1.isHidden = false
        let flightAnimation = CAKeyframeAnimation(keyPath: "position")
        flightAnimation.path = UIBezierPath(ovalIn:CGRect(x: view.frame.midX-300, y: view.frame.midY-300, width: 600, height: 600)).cgPath
        flightAnimation.calculationMode = CAAnimationCalculationMode.paced
        flightAnimation.duration = 2
        flightAnimation.rotationMode = CAAnimationRotationMode.rotateAuto
        flightAnimation.repeatCount = 1
        spark1.layer.add(flightAnimation, forKey: nil)
    }
    
    @objc func imageViewTap(_ sender: UITapGestureRecognizer? = nil) {
        tapDSDoor(vc:vc)
    }
    
    func setDSDoor() {
        square.frame = CGRect(x: view.bounds.midX-800, y: view.bounds.midY-800, width: 1600, height: 1600)
        square.contentMode = .scaleAspectFit
        whiteView = setCenterCircle(view:square)
        square.addSubview(whiteView)
        view.addSubview(square)
        imageView.frame = CGRect(x: view.bounds.midX-300, y: view.bounds.midY-300, width: 600, height: 600)
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.layer.masksToBounds = true
        view.addSubview(imageView)
    }
    
    func tapDSDoor(vc:String) {
        UIView.animate(withDuration: 1) {
            self.imageView.layer.transform = CATransform3DMakeScale(3, 3, 1)
            self.square.removeFromSuperview()
        } completion: { _ in
            self.performSegue(withIdentifier: "show\(vc)", sender: nil)
        }
    }
    
    func setCenterCircle(view:UIView) -> UIView {
        let whiteView = UIView(frame: view.bounds)
        let maskLayer = CAShapeLayer()
        let radius : CGFloat = view.bounds.width/5
        let path = UIBezierPath(rect: view.bounds)
        path.addArc(withCenter: whiteView.center, radius: radius, startAngle: 0.0, endAngle: CGFloat(2*Double.pi), clockwise: true)
        maskLayer.path = path.cgPath
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        whiteView.layer.mask = maskLayer
        whiteView.clipsToBounds = true
        whiteView.alpha = 1
        whiteView.backgroundColor = UIColor.black
        return whiteView
    }
    
    func startRecording() {
        if recognitionTask != nil {
                   recognitionTask?.cancel()
                   recognitionTask = nil
               }
               
               let audioSession = AVAudioSession.sharedInstance()
               do {
                   try audioSession.setCategory(AVAudioSession.Category.record)
                   try audioSession.setMode(AVAudioSession.Mode.measurement)
                   try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
               } catch {
                   print("audioSession properties weren't set because of an error.")
               }
               
               recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
               
               let inputNode = audioEngine.inputNode
               
               guard let recognitionRequest = recognitionRequest else {
                   fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
               }
               
               recognitionRequest.shouldReportPartialResults = true
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            if result != nil {
                self.textView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
                if self.textView.text == "Test" {
                    if !self.check {
                        self.check = true
                        self.stopRecording()
                        self.vc = "TestViewController"
                        self.spark.isHidden = false
                        self.circleAnimation()
                        self.starAnimation(index: 0)
                    }
                    self.textView.text = "Go to TestViewController"
                    return
                }
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                       self.speechButton.isEnabled = true
                   }
               })
               
               let recordingFormat = inputNode.outputFormat(forBus: 0)
               inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
                   self.recognitionRequest?.append(buffer)
               }
               audioEngine.prepare()
               do {
                   try audioEngine.start()
               } catch {
                   print("audioEngine couldn't start because of an error.")
               }
               textView.text = "Which page do you wanna go to?"
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
           if available {
               speechButton.isEnabled = true
           } else {
               speechButton.isEnabled = false
           }
       }
    
    func stopRecording() {
        textView.text = "Which page do you wanna go to?"
        audioEngine.stop()
        recognitionRequest?.endAudio()
 speechButton.isEnabled = false
        speechButton.setImage(UIImage(systemName: "mic.circle"), for: .normal)
        textView.text = ""
    }
    
    func starAnimation(index:Int) {
        if index == starPoint.count {
            spark.isHidden = true
            setDSDoor()
            return
        }
        UIView.animate(withDuration: 0.4) {
            self.spark.center = self.starPoint[index]
        } completion: { _ in
            self.starAnimation(index: index+1)
        }
    }
    
    @IBAction func tapSpeechButton(_ sender: Any) {
        if audioEngine.isRunning {
                  stopRecording()
               } else {
                   startRecording()
                   speechButton.setImage(UIImage(systemName: "mic.circle.fill"), for: .normal)
               }
    }
    
    @IBAction func panGesture(_ sender: UIPanGestureRecognizer) {
        if sender.state == .ended {
            spark.isHidden = true
        } else if sender.state == .began {
            spark.isHidden = false
        }else if sender.state == .changed {
            spark.center = sender.location(in: self.view)
        }
    }
}

extension DSViewController:SFSpeechRecognizerDelegate{
    
}
