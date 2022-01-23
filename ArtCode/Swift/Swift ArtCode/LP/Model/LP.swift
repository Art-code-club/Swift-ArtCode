//
//  LP.swift
//  Creative Coding Practice
//
//  Created by Fomagran on 2022/01/08.
//

import UIKit

struct LP {
    let title:String
    let color:UIColor
    let musicName:String
    let album:UIImage
    var averageColor:UIColor {
        return album.averageColor ?? .white
    }
}
