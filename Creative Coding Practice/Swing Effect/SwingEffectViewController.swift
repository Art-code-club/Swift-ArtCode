//
//  SwingEffectViewController.swift
//  Creative Coding Practice
//
//  Created by Fomagran on 2021/11/22.
//

import UIKit

class SwingEffectViewController: UIViewController {

    //MARK:- Properties
    
//    var square:UIView = {
//       let view = UIView()
    //        return view
    //    }()
    
    @IBOutlet weak var square: UIView!
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK:- Help Functions
    
    //MARK:- IBActions
    
    @IBAction func dragSquare(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view) //
        square.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        sender.setTranslation(.zero, in: self.view)
    }
}
