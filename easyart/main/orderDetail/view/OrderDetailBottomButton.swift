//
//  OrderDetailBottomButton.swift
//  easyart
//
//  Created by Damon on 2024/10/15.
//

import UIKit

class OrderDetailBottomButton: DDView {
    private var mStackView = UIStackView()
    
    override func createUI() {
        super.createUI()
    }
    
    var spacing: CGFloat = 0 {
        didSet {
            self.mStackView.spacing = spacing
        }
    }
    
    var distribution: UIStackView.Distribution = .equalSpacing {
        didSet {
            self.mStackView.distribution = distribution
        }
    }
    
    
    func updateUI(views: [UIView]) {
        self.isHidden = views.isEmpty
        //
        for view in self.subviews {
            view.removeFromSuperview()
        }
        //
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.spacing = self.spacing
        stackView.alignment = .fill
        stackView.distribution = self.distribution
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        self.mStackView = stackView
    }
    

}
