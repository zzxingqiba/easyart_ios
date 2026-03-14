//
//  HDNavigationBarView.swift
//  HDSwiftViewControllers
//
//  Created by Damon on 2022/3/11.
//  Copyright © 2022 Damon. All rights reserved.
//

import UIKit

public class HDNavigationBarView: UIView {

    init() {
        super.init(frame: .zero)
        self._createUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: UI
    public private(set) lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    public private(set) lazy var mIndicatorView: UIActivityIndicatorView = {
        let tIndicatorView = UIActivityIndicatorView(style: .white)
        tIndicatorView.color = UIColor.white
        return tIndicatorView
    }()
}

extension HDNavigationBarView {
    func startNavBarLoading() {
        self.mIndicatorView.startAnimating()
        self.mIndicatorView.snp.updateConstraints { (make) in
            make.width.equalTo(30)
        }
    }

    func stopNavBarLoading() {
        self.mIndicatorView.stopAnimating()
        self.mIndicatorView.snp.updateConstraints { (make) in
            make.width.equalTo(0)
        }
    }
}

private extension HDNavigationBarView {
    func _createUI() {
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
        }
        self.addSubview(mIndicatorView)
        mIndicatorView.snp.makeConstraints { make in
            make.left.equalTo(mTitleLabel.snp.right)
            make.centerY.right.equalToSuperview()
            make.width.equalTo(0)
            make.height.equalTo(30)
            make.right.equalToSuperview()
        }
    }
}
