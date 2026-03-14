//
//  HDHUD+Error.swift
//  Menses
//
//  Created by Damon on 2020/12/16.
//  Copyright © 2020 Damon. All rights reserved.
//

import Foundation
import HDHUD

extension HDHUD {
    //显示错误描述
    static func show(error: Error, autoHidden: Bool = true, view: UIView? = nil, completion: (()->Void)? = nil) {
        self.show(DDErrorProvider.localizedDescription(error), icon: .error)
    }
}
