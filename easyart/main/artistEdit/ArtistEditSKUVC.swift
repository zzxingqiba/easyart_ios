//
//  ArtistEditSKUVC.swift
//  easyart
//
//  Created by Damon on 2025/1/24.
//

import UIKit
import HDHUD
import SwiftyJSON

class ArtistEditSKUVC: BaseVC {
    private var editModel: ArtistEditModel
    private var SKUModel: ArtistEditSKUModel
    private var isNewSKU = false
    
    init(editModel: ArtistEditModel, SKUModel: ArtistEditSKUModel, isNewSKU: Bool) {
        self.editModel = editModel
        self.SKUModel = SKUModel
        self.isNewSKU = isNewSKU
        super.init(bottomPadding: 80)
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self._bindView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._loadData()
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.contentType = .flex
        
        self.mSafeView.addSubview(mTitleEditTextView)
        mTitleEditTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalToSuperview().offset(30)
        }
        
        self.mSafeView.addSubview(mArtistEditPriceTextView)
        mArtistEditPriceTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(mTitleEditTextView.snp.bottom).offset(30)
        }
        
        self.mSafeView.addSubview(mArtistEditExpectedPriceView)
        mArtistEditExpectedPriceView.snp.makeConstraints { make in
            make.left.right.equalTo(mArtistEditPriceTextView)
            make.top.equalTo(mArtistEditPriceTextView.snp.bottom).offset(30)
        }
        
        self.mSafeView.addSubview(mEditTitleLabel)
        mEditTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(mArtistEditPriceTextView)
            make.top.equalTo(mArtistEditExpectedPriceView.snp.bottom).offset(30)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = ThemeColor.line.color()
        self.mSafeView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.centerY.equalTo(mEditTitleLabel)
            make.left.equalTo(mEditTitleLabel.snp.right).offset(10)
            make.right.equalTo(mArtistEditPriceTextView)
            make.height.equalTo(1)
        }
        
        //        self.mSafeView.addSubview(mMediumArtistEditCellView)
        //        mMediumArtistEditCellView.snp.makeConstraints { make in
        //            make.left.right.equalTo(mTitleEditTextView)
        //            make.top.equalTo(mEditTitleLabel.snp.bottom)
        //        }
        
        self.mSafeView.addSubview(mYearArtistEditTextField)
        mYearArtistEditTextField.snp.makeConstraints { make in
            make.left.right.equalTo(mArtistEditPriceTextView)
            make.top.equalTo(mEditTitleLabel.snp.bottom)
        }
        
        self.mSafeView.addSubview(mMaterialArtistEditCellView)
        mMaterialArtistEditCellView.snp.makeConstraints { make in
            make.left.right.equalTo(mArtistEditPriceTextView)
            make.top.equalTo(mYearArtistEditTextField.snp.bottom)
        }
        
        self.mSafeView.addSubview(mArtistEditSizeCellView)
        mArtistEditSizeCellView.snp.makeConstraints { make in
            make.left.right.equalTo(mArtistEditPriceTextView)
            make.top.equalTo(mMaterialArtistEditCellView.snp.bottom)
        }
        
        self.mSafeView.addSubview(mArtistEditFrameWeightCellView)
        mArtistEditFrameWeightCellView.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleEditTextView)
            make.top.equalTo(mArtistEditSizeCellView.snp.bottom)
            make.height.lessThanOrEqualTo(1)
        }
        
        self.mSafeView.addSubview(mFrameArtistEditCellView)
        mFrameArtistEditCellView.snp.makeConstraints { make in
            make.left.right.equalTo(mArtistEditPriceTextView)
            make.top.equalTo(mArtistEditFrameWeightCellView.snp.bottom)
        }
        
        self.mSafeView.addSubview(mArtistEditFrameSizeCellView)
        mArtistEditFrameSizeCellView.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleEditTextView)
            make.top.equalTo(mFrameArtistEditCellView.snp.bottom)
            make.height.lessThanOrEqualTo(1)
        }
        
        self.mSafeView.addSubview(mRarityArtistEditCellView)
        mRarityArtistEditCellView.snp.makeConstraints { make in
            make.left.right.equalTo(mArtistEditPriceTextView)
            make.top.equalTo(mArtistEditFrameSizeCellView.snp.bottom)
        }
        
        self.mSafeView.addSubview(mSignatureArtistEditCellView)
        mSignatureArtistEditCellView.snp.makeConstraints { make in
            make.left.right.equalTo(mArtistEditPriceTextView)
            make.top.equalTo(mRarityArtistEditCellView.snp.bottom)
        }
        
        //        self.mSafeView.addSubview(mProfileArtistEditCellView)
        //        mProfileArtistEditCellView.snp.makeConstraints { make in
        //            make.left.right.equalTo(mTitleEditTextView)
        //            make.top.equalTo(mSignatureArtistEditCellView.snp.bottom)
        //        }
        
        self.mSafeView.addSubview(mConfirmButton)
        mConfirmButton.snp.makeConstraints { make in
            make.left.right.equalTo(mArtistEditPriceTextView)
            make.top.equalTo(mSignatureArtistEditCellView.snp.bottom).offset(45)
            make.height.equalTo(50)
        }
        
    }
    
    //MARK: UI
    lazy var mTitleEditTextView: ArtistEditTitleTextView = {
        let view = ArtistEditTitleTextView()
        view.mTextField.textColor = ThemeColor.gray.color()
        view.mTextField.isEnabled = false
        view.mTextField.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var mArtistEditPriceTextView: ArtistEditPriceTextView = {
        let view = ArtistEditPriceTextView()
        view.mTextField.keyboardType = .numberPad
        return view
    }()
    
    lazy var mArtistEditExpectedPriceView: ArtistEditExpectedPriceView = {
        let view = ArtistEditExpectedPriceView()
        return view
    }()
    
    lazy var mEditTitleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = ThemeColor.white.color()
        label.text = "Detailed information".localString
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    //    lazy var mMediumArtistEditCellView: ArtistEditCellView = {
    //        let view = ArtistEditCellView()
    //        view.mTitleLabel.text = "Medium".localString
    //        return view
    //    }()
    
    lazy var mYearArtistEditTextField: ArtistEditCellView = {
        let view = ArtistEditCellView()
        view.mTitleLabel.text = "Year".localString
        return view
    }()
    
    lazy var mMaterialArtistEditCellView: ArtistEditCellView = {
        let view = ArtistEditCellView()
        view.mTitleLabel.text = "Material".localString
        return view
    }()
    
    lazy var mArtistEditSizeCellView: ArtistEditSizeCellView = {
        let view = ArtistEditSizeCellView()
        return view
    }()
    
    lazy var mArtistEditFrameWeightCellView: ArtistEditTextFieldCellView = {
        let view = ArtistEditTextFieldCellView()
        view.mTitleLabel.text = "Weight（kg）".localString
        return view
    }()
    
    lazy var mArtistEditFrameSizeCellView: ArtistEditSizeCellView = {
        let view = ArtistEditSizeCellView()
        view.mTitleLabel.text = "Artwork with frame".localString
        view.isHidden = true
        return view
    }()
    
    lazy var mFrameArtistEditCellView: ArtistEditCellView = {
        let view = ArtistEditCellView()
        view.mTitleLabel.text = "Frame".localString
        return view
    }()
    
    lazy var mRarityArtistEditCellView: ArtistEditCellView = {
        let view = ArtistEditCellView()
        view.mTitleLabel.text = "Rarity".localString
        return view
    }()
    
    lazy var mSignatureArtistEditCellView: ArtistEditCellView = {
        let view = ArtistEditCellView()
        view.mTitleLabel.text = "Signature".localString
        return view
    }()
    
    //    lazy var mProfileArtistEditCellView: ArtistEditCellView = {
    //        let view = ArtistEditCellView()
    //        view.mTitleLabel.text = "Artwork profile（Optional）".localString
    //        return view
    //    }()
    
    lazy var mConfirmButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.contentType = .center(gap: 0)
        button.mTitleLabel.text = "Submit".localString
        button.mTitleLabel.font = .systemFont(ofSize: 14)
        button.mTitleLabel.textColor = UIColor.dd.color(hexValue: 0xffffff)
        button.backgroundColor = ThemeColor.black.color()
        return button
    }()
}

extension ArtistEditSKUVC {
    func _loadData() {
        self.mTitleEditTextView.mTextField.text = self.editModel.name
        self.mArtistEditSizeCellView.showHeight = self.editModel.categoryID == 1
        self.mArtistEditFrameSizeCellView.showHeight = self.editModel.categoryID == 1
        //雕塑显示重量
        if self.editModel.categoryID == 1 {
            self.mArtistEditFrameWeightCellView.isHidden = false
            self.mArtistEditFrameWeightCellView.snp.updateConstraints { make in
                make.height.lessThanOrEqualTo(MAXFLOAT)
            }
        } else {
            self.mArtistEditFrameWeightCellView.isHidden = true
            self.mArtistEditFrameWeightCellView.snp.updateConstraints { make in
                make.height.lessThanOrEqualTo(1)
            }
        }
        if SKUModel.frameType == .include {
            self.mArtistEditFrameSizeCellView.isHidden = false
            self.mArtistEditFrameSizeCellView.snp.updateConstraints { make in
                make.height.lessThanOrEqualTo(MAXFLOAT)
            }
        } else {
            self.mArtistEditFrameSizeCellView.isHidden = true
            self.mArtistEditFrameSizeCellView.snp.updateConstraints { make in
                make.height.lessThanOrEqualTo(1)
            }
        }
        //SKU信息
        self.mArtistEditPriceTextView.mTextField.text = "\(SKUModel.workPrice)"
        //金额转换
        if SKUModel.workPrice > 0 {
            self._moneyExchange(value: SKUModel.workPrice)
        }
        if let year = SKUModel.year {
            self.mYearArtistEditTextField.setDes(text: "\(year)")
        }
        self.mMaterialArtistEditCellView.setDes(text: SKUModel.meterialString())
        if SKUModel.height > 0 {
            self.mArtistEditSizeCellView.mHeightTextfield.text = "\(SKUModel.height)"
        }
        if SKUModel.width > 0 {
            self.mArtistEditSizeCellView.mWidthTextfield.text = "\(SKUModel.width)"
        }
        if SKUModel.length > 0 {
            self.mArtistEditSizeCellView.mLengthTextfield.text = "\(SKUModel.length)"
        }
        if SKUModel.height_mount > 0 {
            self.mArtistEditFrameSizeCellView.mHeightTextfield.text = "\(SKUModel.height_mount)"
        }
        if SKUModel.width_mount > 0 {
            self.mArtistEditFrameSizeCellView.mWidthTextfield.text = "\(SKUModel.width_mount)"
        }
        if SKUModel.length_mount > 0 {
            self.mArtistEditFrameSizeCellView.mLengthTextfield.text = "\(SKUModel.length_mount)"
        }
        if SKUModel.weight > 0 {
            self.mArtistEditFrameWeightCellView.mHeightTextfield.text = "\(SKUModel.weight)"
        }
        if let frameType = SKUModel.frameType {
            self.mFrameArtistEditCellView.setDes(text: frameType.title())
        }
        if let numberType = SKUModel.numberType {
            self.mRarityArtistEditCellView.setDes(text: numberType.title())
        }
        self.mSignatureArtistEditCellView.setDes(text: SKUModel.hasSignature ? "YES".localString : "NO".localString)
    }
    
    func _bindView() {
        //        _ = self.mMediumArtistEditCellView.clickPublish.subscribe(onNext: { [weak self] _ in
        //            guard let self = self else { return }
        //            let vc = ArtistEditMediumVC(SKUModel: self.SKUModel)
        //            vc.hidesBottomBarWhenPushed = true
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        })
        
        _ = self.mArtistEditPriceTextView.mTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.SKUModel.workPrice = Int(self.mArtistEditPriceTextView.mTextField.text ?? "") ?? 0
            //金额转换
            self._moneyExchange(value: self.SKUModel.workPrice)
        })
        
        _ = self.mYearArtistEditTextField.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = ArtistEditYearVC(SKUModel: self.SKUModel)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mMaterialArtistEditCellView.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = ArtistEditMeterialVC(SKUModel: self.SKUModel)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mArtistEditSizeCellView.widthPublish.subscribe(onNext: { [weak self] width in
            guard let self = self else { return }
            self.SKUModel.width = width
        })
        
        _ = self.mArtistEditSizeCellView.heightPublish.subscribe(onNext: { [weak self] height in
            guard let self = self else { return }
            self.SKUModel.height = height
        })
        
        _ = self.mArtistEditSizeCellView.lengthPublish.subscribe(onNext: { [weak self] length in
            guard let self = self else { return }
            self.SKUModel.length = length
        })
        
        _ = self.mArtistEditFrameSizeCellView.widthPublish.subscribe(onNext: { [weak self] width in
            guard let self = self else { return }
            self.SKUModel.width_mount = width
        })
        
        _ = self.mArtistEditFrameSizeCellView.heightPublish.subscribe(onNext: { [weak self] height in
            guard let self = self else { return }
            self.SKUModel.height_mount = height
        })
        
        _ = self.mArtistEditFrameSizeCellView.lengthPublish.subscribe(onNext: { [weak self] length in
            guard let self = self else { return }
            self.SKUModel.length_mount = length
        })
        
        _ = self.mArtistEditFrameWeightCellView.textPublish.subscribe(onNext: { [weak self] weight in
            guard let self = self else { return }
            self.SKUModel.weight = Int(weight) ?? 0
        })
        
        _ = self.mFrameArtistEditCellView.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = ArtistEditFrameVC(SKUModel: self.SKUModel)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mRarityArtistEditCellView.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = ArtistEditRarityVC(SKUModel: self.SKUModel)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mSignatureArtistEditCellView.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = ArtistEditSignatureVC(SKUModel: self.SKUModel)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        //        _ = self.mProfileArtistEditCellView.clickPublish.subscribe(onNext: { [weak self] _ in
        //            guard let self = self else { return }
        //            let vc = ArtistEditInfoVC(SKUModel: self.SKUModel)
        //            vc.hidesBottomBarWhenPushed = true
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        })
        
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if !self.SKUModel.isAvailable() {
                HDHUD.show("Please complete the required information".localString)
                return
            }
            if isNewSKU {
                self.editModel.skuList.append(self.SKUModel)
            }
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func _moneyExchange(value: Int) {
        let price = Int(Double(value) * 0.6)
        if price == 0 {
            return
        }
        _ = DDAPI.shared.request("settled/moneyExchange", data: ["money": price, "exchange_code": "CNY"]).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            let json = JSON(response.data)
            let exchange_money = Int(json["exchange_money"].floatValue)
            self.mArtistEditExpectedPriceView.mExpectedBetweenView.mContentLabel.text = "\(price)"
            self.mArtistEditExpectedPriceView.mCNYBetweenView.mContentLabel.text = "≈ \(exchange_money)"
            self.mArtistEditExpectedPriceView.mServiceFeeBetweenView.mContentLabel.text = "- \(value - price)"
        })
    }
}
