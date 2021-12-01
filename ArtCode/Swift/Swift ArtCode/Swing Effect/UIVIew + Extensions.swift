//
//  UIVIew + Extensions.swift
//  Creative Coding Practice
//
//  Created by Fomagran on 2021/11/24.
//

import Foundation
import UIKit

extension UIView {
    func rotate(degrees: CGFloat) {
        let degreesToRadians: (CGFloat) -> CGFloat = { (degrees: CGFloat) in
            return degrees / 180.0 * CGFloat.pi
        }
        self.transform =  CGAffineTransform(rotationAngle: degreesToRadians(degrees))
    }
    
    func getDestinationPoint(p2:CGPoint) -> CGPoint {
        if p2.x <= center.x  {
            //1
            if p2.y <= center.y {
                return CGPoint(x: p2.x+50, y: p2.y+50)
            //3
            }else {
                return CGPoint(x: p2.x+50, y: p2.y-50)
            }
        }else {
            //2
            if p2.y <= center.y {
                return CGPoint(x: p2.x-50, y: p2.y+50)
            //4
            }else {
                return CGPoint(x: p2.x-50, y: p2.y-50)
            }
        }
    }
    
    func getAngle(p2:CGPoint) -> CGFloat {
        if p2.x <= center.x  {
            //1
            if p2.y <= center.y {
                return 5
            //3
            }else {
                return -5
            }
        }else {
            //2
            if p2.y <= center.y {
                return -5
            //4
            }else {
                return 5
            }
        }
    }
}
