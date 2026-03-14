//
//  HDNoticePopView.swift
//  HDPopView
//
//  Created by Damon on 2021/3/4.
//

import UIKit
import DDUtils
import RxSwift

open class HDNoticePopView: HDPopContentView {
    public convenience init(title: String? = NSLocalizedString("系统公告", comment: ""), content: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.lineHeightMultiple = 1.3
        let attributed = NSAttributedString(string: content, attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        self.init(title: title, content: attributed)
    }

    public var isSingleButton = false {
        willSet {
            self.mLeftButton.isHidden = newValue
            self.mRightButton.isHidden = newValue
            self.mSingleButton.isHidden = !newValue
        }
    }

    public init(title: String? = NSLocalizedString("系统公告", comment: ""), content: NSAttributedString) {
        super.init(frame: .zero)
        self._createUI()
        self._bindView()
        self.mTitleLabel.text = title
        self.mContentLabel.attributedText = content
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: Lazy
    public private(set) lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.textColor = UIColor.dd.color(hexValue: 0x000000)
        tLabel.font = .systemFont(ofSize: 20, weight: .medium)
        tLabel.textAlignment = .center
        return tLabel
    }()

    lazy var mScrollView: UIScrollView = {
        let tScrollView = UIScrollView(frame: CGRect.zero)
        tScrollView.delegate = self
        tScrollView.backgroundColor = UIColor.clear
        tScrollView.scrollsToTop = true
        tScrollView.showsHorizontalScrollIndicator = false
        tScrollView.showsVerticalScrollIndicator = false
        tScrollView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        tScrollView.contentInsetAdjustmentBehavior = .never
        return tScrollView
    }()

    public private(set) lazy var mContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()

    lazy var mContentLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.lineBreakMode = .byCharWrapping
        tLabel.numberOfLines = 0
        tLabel.textColor = UIColor.dd.color(hexValue: 0x666666)
        tLabel.font = .systemFont(ofSize: 14)
        return tLabel
    }()

    public private(set) lazy var mLeftButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.backgroundColor = UIColor.dd.color(hexValue: 0xeeeeee)
        tButton.titleLabel?.font = .systemFont(ofSize: 16)
        tButton.setTitleColor(UIColor.dd.color(hexValue: 0x333333), for: .normal)
        tButton.setTitle(NSLocalizedString("关闭", comment: ""), for: .normal)
        tButton.layer.cornerRadius = 20
        return tButton
    }()

    public private(set) lazy var mRightButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.backgroundColor = UIColor.dd.color(hexValue: 0xFFDA02)
        tButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        tButton.setTitleColor(UIColor.dd.color(hexValue: 0x333333), for: .normal)
        tButton.setTitle(NSLocalizedString("查看", comment: ""), for: .normal)
        tButton.layer.cornerRadius = 20
        return tButton
    }()

    public private(set) lazy var mSingleButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.isHidden = true
        tButton.backgroundColor = UIColor.dd.color(hexValue: 0xFFDA02)
        tButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        tButton.setTitleColor(UIColor.dd.color(hexValue: 0x333333), for: .normal)
        tButton.setTitle(NSLocalizedString("知道了", comment: ""), for: .normal)
        tButton.layer.cornerRadius = 20
        return tButton
    }()

    public private(set) lazy var mTipImageView: UIImageView = {
        let tImageView = UIImageView(image: UIImageHDPopBoundle(named: "down_tip"))
        //增加提示
        let transformYAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        transformYAnimation.fromValue = 0
        transformYAnimation.toValue = -10
        transformYAnimation.duration = 0.3
        transformYAnimation.isCumulative = false
        transformYAnimation.isRemovedOnCompletion = false
        transformYAnimation.autoreverses = true  //原样返回
        transformYAnimation.repeatCount = MAXFLOAT
        transformYAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        tImageView.layer.add(transformYAnimation, forKey: "transformYAnimation")
        return tImageView
    }()

}

private extension HDNoticePopView {
    func _createUI() {
        self.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        self.layer.cornerRadius = 12
        self.snp.makeConstraints { (make) in
            make.width.equalTo(310)
        }

        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(110)
            make.right.equalToSuperview().offset(-110)
            make.top.equalToSuperview().offset(20)
        }

        let leftImageView = UIImageView(image: UIImageHDPopBoundle(named: "line_left"))
        self.addSubview(leftImageView)
        leftImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(mTitleLabel)
            make.right.equalTo(mTitleLabel.snp.left).offset(-10)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(5)
        }

        let rightImageView = UIImageView(image: UIImageHDPopBoundle(named: "line_right"))
        self.addSubview(rightImageView)
        rightImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(mTitleLabel)
            make.left.equalTo(mTitleLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(5)
        }

        self.addSubview(mScrollView)
        mScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(mTitleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(10)
        }

        mScrollView.addSubview(mContentView)
        mContentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        mContentView.addSubview(mContentLabel)
        mContentLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(26)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        self.addSubview(mTipImageView)
        mTipImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(30)
            make.bottom.equalTo(mScrollView)
        }

        self.addSubview(mLeftButton)
        mLeftButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(self.snp.centerX).offset(-8)
            make.height.equalTo(40)
            make.top.equalTo(mScrollView.snp.bottom).offset(20)
        }

        self.addSubview(mRightButton)
        mRightButton.snp.makeConstraints { (make) in
            make.top.equalTo(mLeftButton)
            make.left.equalTo(self.snp.centerX).offset(8)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-20)
        }

        self.addSubview(mSingleButton)
        mSingleButton.snp.makeConstraints { (make) in
            make.left.equalTo(mLeftButton)
            make.right.equalTo(mRightButton)
            make.top.height.equalTo(mRightButton)
        }
    }

    func _bindView() {
        _ = mScrollView.rx.observe(CGSize.self, "contentSize").subscribe(onNext: { [weak self] (contentSize) in
            guard let self = self, let contentSize = contentSize else { return }
            self.mTipImageView.isHidden = contentSize.height <= 400
            self.mScrollView.isScrollEnabled = contentSize.height > 400
            self.mScrollView.snp.updateConstraints { (make) in
                make.height.equalTo(min(Int(contentSize.height), 400))
            }
        })

        _ = mLeftButton.rx.tap.map { _ in
            return HDPopButtonClickInfo(clickType: .cancel, info: nil)
        }.bind(to: self.clickBinder)

        _ = mRightButton.rx.tap.map { _ in
            return HDPopButtonClickInfo(clickType: .confirm, info: nil)
        }.bind(to: self.clickBinder)

        _ = mSingleButton.rx.tap.map { _ in
            return HDPopButtonClickInfo(clickType: .confirm, info: nil)
        }.bind(to: self.clickBinder)
    }
}

extension HDNoticePopView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height;
        let contentYoffset = scrollView.contentOffset.y;
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset;
        //到达底部
        self.mTipImageView.isHidden = distanceFromBottom <= height
    }
}
