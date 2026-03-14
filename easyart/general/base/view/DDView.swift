//
//  DDView.swift
//  Menses
//
//  Created by Damon on 2020/9/23.
//  Copyright © 2020 Damon. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class DDView: UIView {
    var disposeBag = DisposeBag()

    private var widthConstraint: Constraint?
    private var heightConstraint: Constraint?


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var isHiddenAndClearFrame: Bool = false {
        willSet {
            self.widthConstraint?.deactivate()
            self.heightConstraint?.deactivate()
            self.snp.makeConstraints { (make) in
                if newValue {
                    self.widthConstraint = make.width.lessThanOrEqualTo(0).priority(.high).constraint
                    self.heightConstraint = make.height.lessThanOrEqualTo(0).priority(.high).constraint
                }
            }
            self.updateConstraintsIfNeeded()
            //隐藏逻辑最后处理
            self.isHidden = newValue
        }
    }

    func createUI() {
        self.snp.makeConstraints { (make) in
            self.widthConstraint = make.width.lessThanOrEqualTo(MAXFLOAT).priority(.low).constraint
            self.heightConstraint = make.height.lessThanOrEqualTo(MAXFLOAT).priority(.low).constraint
        }
    }

}
