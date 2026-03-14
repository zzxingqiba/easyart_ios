//
//  DDXylonPreviewContractView.swift
//  easyart
//
//  Created by Damon on 2024/11/6.
//

import UIKit
import SnapKit
import RxRelay
import SwiftyJSON

class DDXylonPreviewContractView: DDView {
    var viewModel: DDPackageViewModel
    
    init(viewModel: DDPackageViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var bottomConstraint: Constraint?
    private var colorList: [UIColor] = [] {
        didSet {
            self.mColorPackageItemView.updateVisible(hidden: !self.viewModel.showColorList(packageIndex: self.tag))
            for i in 0..<colorList.count {
                let color = colorList[i]
                let view = DDPreviewItemView()
                _ = view.clickPublish.subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    if self.tag != self.viewModel.packageIndex.value {
                        self.viewModel.packageIndex.accept(self.tag)
                    }
                    self.viewModel.colorIndex.accept(i)
                    self.reset()
                })
                view.backgroundColor = color
                view.layer.masksToBounds = true
                view.layer.cornerRadius = 12
                self.mColorPackageItemView.mStackView.addArrangedSubview(view)
            }
        }
    }
    private var borderList: [CGFloat] = [] {
        didSet {
            self.mBorderPackageItemView.updateVisible(hidden: !self.viewModel.showBorderWList(packageIndex: self.tag))
            for i in 0..<borderList.count {
                let border = borderList[i]
                let view = DDPreviewItemView()
                _ = view.clickPublish.subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    if self.tag != self.viewModel.packageIndex.value {
                        self.viewModel.packageIndex.accept(self.tag)
                    }
                    self.viewModel.borderWIndex.accept(i)
                    self.reset()
                })
                view.mTitleLabel.text = "\(border) cm"
                view.layer.masksToBounds = true
                view.layer.cornerRadius = 12
                self.mBorderPackageItemView.mStackView.addArrangedSubview(view)
            }
        }
    }
    private var paperList: [CGFloat] = [] {
        didSet {
            self.mPaperPackageItemView.updateVisible(hidden: !self.viewModel.showPaperWList(packageIndex: self.tag))
            for i in 0..<paperList.count {
                let padding = paperList[i]
                let view = DDPreviewItemView()
                _ = view.clickPublish.subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    if self.tag != self.viewModel.packageIndex.value {
                        self.viewModel.packageIndex.accept(self.tag)
                    }
                    self.viewModel.paperWIndex.accept(i)
                    self.reset()
                })
                if padding == 0 {
                    view.mTitleLabel.text = "/"
                } else {
                    view.mTitleLabel.text = "\(padding) cm"
                }
                view.layer.masksToBounds = true
                view.layer.cornerRadius = 12
                self.mPaperPackageItemView.mStackView.addArrangedSubview(view)
            }
        }
    }
    
    private var styleList: [String] = [] {
        didSet {
            self.mStylePackageItemView.updateVisible(hidden: !self.viewModel.showStyleList(packageIndex: self.tag))
            for i in 0..<styleList.count {
                let styleString = styleList[i]
                let view = DDPreviewItemView()
                _ = view.clickPublish.subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    if self.tag != self.viewModel.packageIndex.value {
                        self.viewModel.packageIndex.accept(self.tag)
                    }
                    self.viewModel.styleIndex.accept(i)
                    self.reset()
                })
                view.mTitleLabel.text = styleString
                view.layer.masksToBounds = true
                view.layer.cornerRadius = 12
                self.mStylePackageItemView.mStackView.addArrangedSubview(view)
            }
        }
    }
    
    private var acrylicList: [String] = [] {
        didSet {
            self.mAcrylicPackageItemView.updateVisible(hidden: !self.viewModel.showAcrylicList(packageIndex: self.tag))
            for i in 0..<acrylicList.count {
                let acrylicString = acrylicList[i]
                let view = DDPreviewItemView()
                _ = view.clickPublish.subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    if self.tag != self.viewModel.packageIndex.value {
                        self.viewModel.packageIndex.accept(self.tag)
                    }
                    self.viewModel.acrylicIndex.accept(i)
                    self.reset()
                })
                view.mTitleLabel.text = acrylicString
                view.layer.masksToBounds = true
                view.layer.cornerRadius = 12
                self.mAcrylicPackageItemView.mStackView.addArrangedSubview(view)
            }
        }
    }
    private var paddingList: [CGFloat] = [] {
        didSet {
            self.mPaddingPackageItemView.updateVisible(hidden: !self.viewModel.showPaddingList(packageIndex: self.tag))
            for i in 0..<paddingList.count {
                let padding = paddingList[i]
                let view = DDPreviewItemView()
                _ = view.clickPublish.subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    if self.tag != self.viewModel.packageIndex.value {
                        self.viewModel.packageIndex.accept(self.tag)
                    }
                    self.viewModel.paddingIndex.accept(i)
                    self.reset()
                })
                if padding == 0 {
                    view.mTitleLabel.text = "/"
                } else {
                    view.mTitleLabel.text = "\(padding) cm"
                }
                view.layer.masksToBounds = true
                view.layer.cornerRadius = 12
                self.mPaddingPackageItemView.mStackView.addArrangedSubview(view)
            }
        }
    }
    
    var isExpand = false {
        didSet {
            self.mContractButton.isSelected = isExpand
            self.mContentView.isHidden = !isExpand
            
            self.bottomConstraint?.deactivate()
            self.snp.makeConstraints { make in
                if isExpand {
                    self.bottomConstraint = make.bottom.equalTo(mContentView).constraint
                } else {
                    self.bottomConstraint = make.bottom.equalTo(mTitleLabel).constraint
                }
            }
        }
    }    //是否展开
    
    override func createUI() {
        super.createUI()
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        self.snp.makeConstraints { make in
            self.bottomConstraint = make.bottom.equalTo(mTitleLabel).constraint
        }
        
        self.addSubview(mContentView)
        mContentView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mTitleLabel.snp.bottom).offset(-8)
            make.height.greaterThanOrEqualTo(80)
        }
        
        mContentView.addSubview(mImageView)
        mImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(45)
            make.height.equalTo(42)
        }
        
        mContentView.addSubview(mColorPackageItemView)
        mColorPackageItemView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(mImageView.snp.bottom).offset(10)
            make.right.lessThanOrEqualToSuperview().offset(-20)
        }
        
        mContentView.addSubview(mBorderPackageItemView)
        mBorderPackageItemView.snp.makeConstraints { make in
            make.left.equalTo(mColorPackageItemView)
            make.top.equalTo(mColorPackageItemView.snp.bottom)
            make.right.lessThanOrEqualToSuperview().offset(-20)
        }
        
        mContentView.addSubview(mStylePackageItemView)
        mStylePackageItemView.snp.makeConstraints { make in
            make.left.equalTo(mColorPackageItemView)
            make.top.equalTo(mBorderPackageItemView.snp.bottom)
            make.right.lessThanOrEqualToSuperview().offset(-20)
        }
        
        //
        mContentView.addSubview(mAcrylicPackageItemView)
        mAcrylicPackageItemView.snp.makeConstraints { make in
            make.left.equalTo(mColorPackageItemView)
            make.top.equalTo(mStylePackageItemView.snp.bottom)
            make.right.lessThanOrEqualToSuperview().offset(-20)
        }
        
        mContentView.addSubview(mPaddingPackageItemView)
        mPaddingPackageItemView.snp.makeConstraints { make in
            make.left.equalTo(mColorPackageItemView)
            make.top.equalTo(mAcrylicPackageItemView.snp.bottom)
            make.right.lessThanOrEqualToSuperview().offset(-20)
        }
        
        //
        mContentView.addSubview(mPaperPackageItemView)
        mPaperPackageItemView.snp.makeConstraints { make in
            make.left.equalTo(mColorPackageItemView)
            make.top.equalTo(mPaddingPackageItemView.snp.bottom)
            make.right.lessThanOrEqualToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
        
        self.addSubview(mContractButton)
        mContractButton.snp.makeConstraints { make in
            make.centerY.equalTo(mTitleLabel)
            make.right.equalToSuperview()
            make.width.height.equalTo(10)
        }
        
        self._bindView()
    }

    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mContentView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    //颜色
    lazy var mColorPackageItemView: DDPackageItemView = {
        let view = DDPackageItemView()
        view.mTitleLabel.text = "Colour".localString
        return view
    }()
    
    //框宽
    lazy var mBorderPackageItemView: DDPackageItemView = {
        let view = DDPackageItemView()
        view.mTitleLabel.text = "Frame width".localString
        return view
    }()
    
    //卡纸
    lazy var mPaperPackageItemView: DDPackageItemView = {
        let view = DDPackageItemView()
        view.mTitleLabel.text = "Cardboard".localString
        return view
    }()
    
    //亚克力
    lazy var mAcrylicPackageItemView: DDPackageItemView = {
        let view = DDPackageItemView()
        view.mTitleLabel.text = "Acrylic".localString
        return view
    }()
    
    //边距
    lazy var mPaddingPackageItemView: DDPackageItemView = {
        let view = DDPackageItemView()
        view.mTitleLabel.text = "Margins".localString
        return view
    }()
    
    //样式
    lazy var mStylePackageItemView: DDPackageItemView = {
        let view = DDPackageItemView()
        view.mTitleLabel.text = "Style".localString
        return view
    }()
    
    //亚克力和边距
    lazy var mImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var mContractButton: UIButton = {
        let button = UIButton(type: .custom)
        button.imageView?.contentMode = .scaleAspectFit
        button.isUserInteractionEnabled = false
        button.isSelected = false
        button.setImage(UIImage(named: "home_folded"), for: .normal)
        button.setImage(UIImage(named: "home_unFolded"), for: .selected)
        return button
    }()
}

extension DDXylonPreviewContractView {
    func reset() {
        for index in 0..<self.mColorPackageItemView.mStackView.arrangedSubviews.count {
            if let itemView = self.mColorPackageItemView.mStackView.arrangedSubviews[index] as? DDPreviewItemView {
                if index == self.viewModel.colorIndex.value && self.tag == self.viewModel.packageIndex.value {
                    itemView.isSelected = true
                } else {
                    itemView.isSelected = false
                }
            }
        }
        //
        for index in 0..<self.mBorderPackageItemView.mStackView.arrangedSubviews.count {
            if let itemView = self.mBorderPackageItemView.mStackView.arrangedSubviews[index] as? DDPreviewItemView {
                if self.tag == self.viewModel.packageIndex.value {
                    itemView.isEnabled = true
                    if index == self.viewModel.borderWIndex.value {
                        itemView.isSelected = true
                    } else {
                        itemView.isSelected = false
                    }
                } else {
                    itemView.isEnabled = false
                }
                
            }
        }
        //
        for index in 0..<self.mPaperPackageItemView.mStackView.arrangedSubviews.count {
            if let itemView = self.mPaperPackageItemView.mStackView.arrangedSubviews[index] as? DDPreviewItemView {
                if self.tag == self.viewModel.packageIndex.value {
                    itemView.isEnabled = true
                    if index == self.viewModel.paperWIndex.value  {
                        itemView.isSelected = true
                    } else {
                        itemView.isSelected = false
                    }
                } else {
                    itemView.isEnabled = false
                }
            }
        }
        
        for index in 0..<self.mStylePackageItemView.mStackView.arrangedSubviews.count {
            if let itemView = self.mStylePackageItemView.mStackView.arrangedSubviews[index] as? DDPreviewItemView {
                if self.tag == self.viewModel.packageIndex.value {
                    itemView.isEnabled = true
                    if index == self.viewModel.styleIndex.value {
                        itemView.isSelected = true
                    } else {
                        itemView.isSelected = false
                    }
                } else {
                    itemView.isEnabled = false
                }
            }
        }
        
        //
        for index in 0..<self.mAcrylicPackageItemView.mStackView.arrangedSubviews.count {
            if let itemView = self.mAcrylicPackageItemView.mStackView.arrangedSubviews[index] as? DDPreviewItemView {
                if self.tag == self.viewModel.packageIndex.value {
                    itemView.isEnabled = true
                    if index == self.viewModel.acrylicIndex.value {
                        itemView.isSelected = true
                    } else {
                        itemView.isSelected = false
                    }
                } else {
                    itemView.isEnabled = false
                }
            }
        }
        //
        for index in 0..<self.mPaddingPackageItemView.mStackView.arrangedSubviews.count {
            if let itemView = self.mPaddingPackageItemView.mStackView.arrangedSubviews[index] as? DDPreviewItemView {
                if self.tag == self.viewModel.packageIndex.value {
                    itemView.isEnabled = true
                    if index == self.viewModel.paddingIndex.value {
                        itemView.isSelected = true
                    } else {
                        itemView.isSelected = false
                    }
                } else {
                    itemView.isEnabled = false
                }                
            }
        }
    }
    
   
    
    func updateUI(packageIndex: Int) {
        self.tag = packageIndex
        let item = self.viewModel.packageConfigList.value[packageIndex]
        self.mTitleLabel.text = item["title"].stringValue
        self.mImageView.kf.setImage(with: URL(string: item["image"].stringValue))
        self.colorList = self.viewModel.getColorList(packageIndex: packageIndex).map({ color in
            let colorString = color["color"].stringValue
            return UIColor.dd.color(hexString: colorString)
        })
        self.borderList = self.viewModel.getBorderWList(packageIndex: packageIndex).map({ border in
            return CGFloat(border["value"].floatValue)
        })
        self.paperList = self.viewModel.getPaperWList(packageIndex: packageIndex).map({ paper in
            return CGFloat(paper["value"].floatValue)
        })
        self.styleList = self.viewModel.getStyleList(packageIndex: packageIndex).map({ style in
            return style["text"].stringValue
        })
        self.acrylicList = self.viewModel.getAcrylicList(packageIndex: packageIndex).map({ acrylic in
            return acrylic["text"].stringValue
        })
        self.paddingList = self.viewModel.getPaddingList(packageIndex: packageIndex).map({ padding in
            return CGFloat(padding["value"].floatValue)
        })
    }
}

private extension DDXylonPreviewContractView {
    func _bindView() {
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.isExpand = !self.isExpand
        })
        self.mTitleLabel.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer()
        _ = tap2.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.isExpand = !self.isExpand
        })
        self.mContractButton.addGestureRecognizer(tap2)
    }
}
