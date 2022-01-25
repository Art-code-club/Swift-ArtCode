//
//  GilitchView.swift
//  Creative Coding Practice
//
//  Created by Fomagran on 2022/01/21.
//

import Foundation
import UIKit

class GlitchView:UIView {
    var image = UIImage(named:"macmiller")!.flipImageVertically()!.cgImage!
    var context:CGContext!
    var decode:[CGFloat] = [ CGFloat(1), CGFloat(0), //alpha filpped
                                         CGFloat(0), CGFloat(1), //red   (no change)
                                         CGFloat(0), CGFloat(1), //green   (no change)
                                         CGFloat(0), CGFloat(1) ] //blue   (no change)
    
    
    override func draw(_ rect: CGRect) {
        let mask =  CGImage(width:              image.width,
                            height:             image.height,
                            bitsPerComponent:   image.bitsPerComponent,
                            bitsPerPixel:       image.bitsPerPixel,
                            bytesPerRow:        image.bytesPerRow,
                            space:              image.colorSpace!,
                            bitmapInfo:         image.bitmapInfo,
                            provider:           image.dataProvider!,
                            decode:             decode,
                            shouldInterpolate:  image.shouldInterpolate,
                            intent:             image.renderingIntent)
        
        context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.systemRed.cgColor)
        context.fill(self.frame)
        context.draw(mask!, in: self.frame)
        context.clip(to: self.frame, mask: mask!)
    }
    
    //배경에 gradient 넣기
    func setGradientBackground() {
        let colors = [ UIColor.blue.cgColor, UIColor.blue.cgColor, UIColor.blue.cgColor ]
        let gradient = CGGradient(colorsSpace: context.colorSpace, colors: colors as CFArray, locations: nil)
        context.drawLinearGradient(gradient!,
                                   start: CGPoint.zero,
                                   end: CGPoint(x: frame.size.width, y: frame.size.height),
                                   options: CGGradientDrawingOptions())
    }
}


