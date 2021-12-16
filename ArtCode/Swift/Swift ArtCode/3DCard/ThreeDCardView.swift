//
//  ThreeDCardView.swift
//  Swift ArtCode
//
//  Created by Fomagran on 2021/12/16.
//

import UIKit

class ThreeDCardView: UIView {
    let imageView1: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Tree.png")
        view.contentMode = .scaleToFill
        return view
    }()
    
    let imageView2: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Tree.png")
        view.contentMode = .scaleToFill
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    func setupLayout() {
        imageView2.transform = CGAffineTransform(scaleX: 1, y: -1)
        addSubview(imageView1)
        addSubview(imageView2)
        
        imageView1.translatesAutoresizingMaskIntoConstraints = false
        imageView2.translatesAutoresizingMaskIntoConstraints = false
        
        imageView1.leadingAnchor.constraint(equalTo: leadingAnchor
                                         ,constant: 0).isActive = true
        imageView1.trailingAnchor.constraint(equalTo: trailingAnchor
                                             ,constant: 0).isActive = true
        imageView1.topAnchor.constraint(equalTo: topAnchor
                                        ,constant: 0).isActive = true
        imageView1.heightAnchor.constraint(equalToConstant: frame.height/4*3).isActive = true

        imageView2.leadingAnchor.constraint(equalTo: leadingAnchor
                                         ,constant: 0).isActive = true
        imageView2.trailingAnchor.constraint(equalTo: trailingAnchor
                                             ,constant: 0).isActive = true
        imageView2.topAnchor.constraint(equalTo: imageView1.bottomAnchor
                                        ,constant: 0).isActive = true
        imageView2.heightAnchor.constraint(equalToConstant: frame.height/4*1).isActive = true
        imageView2.bottomAnchor.constraint(equalTo: bottomAnchor
                                        ,constant: 0).isActive = true
        
    }
}
