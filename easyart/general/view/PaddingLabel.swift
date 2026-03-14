//
//  PaddingLabel.swift
//  HiTalk
//
//  Created by Damon on 2024/5/29.
//

import UIKit
import RxRelay

class PaddingLabel: UILabel {
    let mClickPublish = PublishRelay<Void>()
    
    var topInset: CGFloat
        var bottomInset: CGFloat
        var leftInset: CGFloat
        var rightInset: CGFloat
        
        required init(withInsets top: CGFloat, _ bottom: CGFloat, _ left: CGFloat, _ right: CGFloat) {
            self.topInset = top
            self.bottomInset = bottom
            self.leftInset = left
            self.rightInset = right
            super.init(frame: CGRect.zero)
            self._bindView()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func drawText(in rect: CGRect) {
            let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
            super.drawText(in: rect.inset(by: insets))
        }
        
        override var intrinsicContentSize: CGSize {
            get {
                var contentSize = super.intrinsicContentSize
                contentSize.height += topInset + bottomInset
                contentSize.width += leftInset + rightInset
                return contentSize
            }
        }
}

extension PaddingLabel {
    func _bindView() {
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.mClickPublish.accept(())
        })
        self.addGestureRecognizer(tap)
    }
}
