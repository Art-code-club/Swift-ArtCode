//
//  QuadBezier.swift
//  Creative Coding Practice
//
//  Created by Fomagran on 2022/01/08.
//

import UIKit

struct QuadBezier {
    var point1: CGPoint
    var point2: CGPoint
    var controlPoint: CGPoint

    var path: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: point1)
        path.addQuadCurve(to: point2, controlPoint: controlPoint)
        return path
    }

    func point(at t: CGFloat) -> CGPoint {
        let t1 = 1 - t
        return CGPoint(
            x: t1 * t1 * point1.x + 2 * t * t1 * controlPoint.x + t * t * point2.x,
            y: t1 * t1 * point1.y + 2 * t * t1 * controlPoint.y + t * t * point2.y
        )
    }
}
