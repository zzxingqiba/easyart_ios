//
//  OrgVerifSelectCell.swift
//  easyart
//
//  Created by 崭新的旧刀 on 2026/3/24.
//

import UIKit
import RxRelay

class OrgVerifSelectCell: DDView {
    let clickPublish = PublishRelay<Void>()
    
    var errorTitle = ""
    
    init(title: String) {
        super.init(frame: .zero)
        self.title = title
        self._bindView()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isError = false {
        didSet {
            if isError {
                self.mLineView.backgroundColor = ThemeColor.red.color()
            } else {
                self.mLineView.backgroundColor = ThemeColor.line.color()
            }
        }
    }
    
    var title: String? {
        get {
            return self.mTitleLabel.text
        }
        set {
            self.mTitleLabel.text = newValue
        }
    }
    
    var text: String? {
        get {
            return mDesLabel.text
        }
        set {
            mDesLabel.text = newValue
        }
    }
    
    override func createUI() {
        self.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(mArrowImageView)
        mArrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(8)
            make.height.equalTo(8)
        }
        
        self.addSubview(mDesLabel)
        mDesLabel.snp.makeConstraints { make in
            make.right.equalTo(mArrowImageView.snp.left).offset(-10)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(mLineView)
        mLineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }

    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mArrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon-arrow-solid"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var mDesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mLineView: UIView = {
        let line = UIView()
        line.backgroundColor = ThemeColor.line.color()
        return line
    }()

}

extension OrgVerifSelectCell {
    func _bindView() {
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clickPublish.accept(())
        })
        self.addGestureRecognizer(tap)
    }
}
