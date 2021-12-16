//
//  ThreeDCardView.swift
//  Swift ArtCode
//
//  Created by Fomagran on 2021/12/16.
//

import UIKit

class ThreeDCardView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let layer1 = CAShapeLayer()
        layer1.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height/5*4)
        let img1 = UIImage(named: "Tree.png")?.cgImage
        layer1.contents = img1
        layer1.masksToBounds = true
        layer1.cornerRadius = 10
        let layer2 = CAShapeLayer()
        layer2.frame = CGRect(x: 0, y: frame.height/5*4+1, width: frame.width, height: frame.height/5*1)
        let img2 = UIImage(named: "Tree.png")?.flipImageVertically()?.cgImage
        layer2.masksToBounds = true
        layer2.cornerRadius = 10
        layer2.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        layer2.contents = img2
        layer.addSublayer(layer1)
        layer.addSublayer(layer2)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
}

extension UIImage {
    func flipImageVertically() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let bitmap = UIGraphicsGetCurrentContext()!

        bitmap.translateBy(x: size.width / 2, y: size.height / 2)
        bitmap.scaleBy(x: 1.0, y: 1.0)

        bitmap.translateBy(x: -size.width / 2, y: -size.height / 2)
        bitmap.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
