//
//  HDNavBarButtonItem.swift
//  HDSwiftViewControllers
//
//  Created by Damon on 2023/1/20.
//  Copyright © 2023 Damon. All rights reserved.
//

import UIKit
import DDUtils

open class HDNavBarButtonItem: UIBarButtonItem {
    
    convenience init(item: UIBarButtonQuickItem) {
        self.init()
        let height = DDUtils_Default_NavigationBar_Height() - 5
        if let image = item.image {
            let button = UIButton(type: .custom)
            button.setImage(image, for: .normal)
            //约束大小
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
            button.heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
            //设置badge
            button.addSubview(labelBGView)
            labelBGView.translatesAutoresizingMaskIntoConstraints = false
            labelBGView.rightAnchor.constraint(equalTo: button.rightAnchor).isActive = true
            labelBGView.widthAnchor.constraint(greaterThanOrEqualToConstant: 14).isActive = true
            labelBGView.heightAnchor.constraint(greaterThanOrEqualToConstant: 14).isActive = true
            //
            labelBGView.addSubview(badgeLabel)
            badgeLabel.translatesAutoresizingMaskIntoConstraints = false
            badgeLabel.leftAnchor.constraint(equalTo: labelBGView.leftAnchor, constant: 5).isActive = true
            badgeLabel.rightAnchor.constraint(equalTo: labelBGView.rightAnchor, constant: -5).isActive = true
            badgeLabel.topAnchor.constraint(equalTo: labelBGView.topAnchor).isActive = true
            badgeLabel.bottomAnchor.constraint(equalTo: labelBGView.bottomAnchor).isActive = true
            
            self.customView = button
            self.customButton = button
        } else if let attributedString = item.attributedString, attributedString.length > 0 {
            let button = UIButton(type: .custom)
            button.setAttributedTitle(attributedString, for: .normal)
            //设置badge
            button.addSubview(badgeLabel)
            badgeLabel.translatesAutoresizingMaskIntoConstraints = false
            badgeLabel.rightAnchor.constraint(equalTo: button.rightAnchor).isActive = true
            badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 14).isActive = true
            badgeLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 14).isActive = true
            
            self.customView = button
            self.customButton = button
        }
    }
    
    //MARK: UI
    public var customButton: UIButton?
    
    public private(set) lazy var labelBGView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.dd.color(hexValue: 0xff0000)
        view.isHidden = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 7
        return view
    }()
    
    public private(set) lazy var badgeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.dd.color(hexValue: 0xffffff)
        label.font = .systemFont(ofSize: 11)
        return label
    }()
}

public extension HDNavBarButtonItem {
    func setBadge(text: String?) {
        if let text = text {
            labelBGView.isHidden = text.isEmpty
            badgeLabel.text = text
        } else {
            labelBGView.isHidden = true
        }
    }
}
