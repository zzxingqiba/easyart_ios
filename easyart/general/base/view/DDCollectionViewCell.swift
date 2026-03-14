//
//  DDCollectionViewCell.swift
//  Menses
//
//  Created by Damon on 2020/7/8.
//  Copyright © 2020 Damon. All rights reserved.
//

import UIKit
import RxSwift

class DDCollectionViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func createUI() {

    }
}
