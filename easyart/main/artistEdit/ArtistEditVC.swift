//
//  ArtistEditVC.swift
//  easyart
//
//  Created by Damon on 2025/1/8.
//

import UIKit
import ZLPhotoBrowser
import SwiftyJSON
import HDHUD

class ArtistEditVC: BaseVC {
    var goodsID: Int?
    private var editModel: ArtistEditModel = ArtistEditModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
        self._initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._reloadData()
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.contentType = .flex
        
        self.mSafeView.addSubview(mPrimaryImageView)
        mPrimaryImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(30)
            make.width.height.equalTo(105)
        }
        
        self.mSafeView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(mPrimaryImageView).offset(10)
            make.left.equalTo(mPrimaryImageView.snp.right).offset(15)
        }
        
        self.mSafeView.addSubview(mDesLabel)
        mDesLabel.snp.makeConstraints { make in
            make.left.equalTo(mTitleLabel)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(4)
        }
        
        self.mSafeView.addSubview(mDesLabel2)
        mDesLabel2.snp.makeConstraints { make in
            make.left.equalTo(mTitleLabel)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(mDesLabel.snp.bottom).offset(4)
        }
        
        self.mSafeView.addSubview(mTipButton)
        mTipButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-30)
            make.centerY.equalTo(mTitleLabel)
            make.height.equalTo(15)
        }
        
        self.mSafeView.addSubview(mCoverImageView)
        mCoverImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(mPrimaryImageView.snp.bottom).offset(30)
            make.width.height.equalTo(105)
        }
        
        self.mSafeView.addSubview(mCoverTitleLabel)
        mCoverTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(mCoverImageView).offset(10)
            make.left.equalTo(mCoverImageView.snp.right).offset(15)
        }
        
        self.mSafeView.addSubview(mCoverDesLabel)
        mCoverDesLabel.snp.makeConstraints { make in
            make.left.equalTo(mCoverTitleLabel)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(mCoverTitleLabel.snp.bottom).offset(4)
        }
        
        self.mSafeView.addSubview(mArtistEditImageListView)
        mArtistEditImageListView.snp.makeConstraints { make in
            make.left.equalTo(mCoverTitleLabel)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalTo(mCoverImageView)
        }
        
        self.mSafeView.addSubview(mCoverTipLabel)
        mCoverTipLabel.snp.makeConstraints { make in
            make.left.equalTo(mCoverImageView)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(mCoverImageView.snp.bottom).offset(10)
        }
        
        self.mSafeView.addSubview(mTitleEditTextView)
        mTitleEditTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(mCoverTipLabel.snp.bottom).offset(38)
        }
        
        self.mSafeView.addSubview(mArtistEditPriceTextView)
        mArtistEditPriceTextView.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleEditTextView)
            make.top.equalTo(mTitleEditTextView.snp.bottom).offset(30)
        }
        
        self.mSafeView.addSubview(mArtistEditExpectedPriceView)
        mArtistEditExpectedPriceView.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleEditTextView)
            make.top.equalTo(mArtistEditPriceTextView.snp.bottom).offset(30)
        }
        
        self.mSafeView.addSubview(mEditTitleLabel)
        mEditTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(mTitleEditTextView)
            make.top.equalTo(mArtistEditExpectedPriceView.snp.bottom).offset(30)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = ThemeColor.line.color()
        self.mSafeView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.centerY.equalTo(mEditTitleLabel)
            make.left.equalTo(mEditTitleLabel.snp.right).offset(10)
            make.right.equalTo(mTitleEditTextView)
            make.height.equalTo(1)
        }
        
        self.mSafeView.addSubview(mMediumArtistEditCellView)
        mMediumArtistEditCellView.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleEditTextView)
            make.top.equalTo(mEditTitleLabel.snp.bottom)
        }
        
        self.mSafeView.addSubview(mYearArtistEditTextField)
        mYearArtistEditTextField.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleEditTextView)
            make.top.equalTo(mMediumArtistEditCellView.snp.bottom)
        }
        
        self.mSafeView.addSubview(mMaterialArtistEditCellView)
        mMaterialArtistEditCellView.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleEditTextView)
            make.top.equalTo(mYearArtistEditTextField.snp.bottom)
        }
        
        self.mSafeView.addSubview(mArtistEditSizeCellView)
        mArtistEditSizeCellView.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleEditTextView)
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
            make.left.right.equalTo(mTitleEditTextView)
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
            make.left.right.equalTo(mTitleEditTextView)
            make.top.equalTo(mArtistEditFrameSizeCellView.snp.bottom)
        }
        
        self.mSafeView.addSubview(mSignatureArtistEditCellView)
        mSignatureArtistEditCellView.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleEditTextView)
            make.top.equalTo(mRarityArtistEditCellView.snp.bottom)
        }
        
        self.mSafeView.addSubview(mProfileArtistEditCellView)
        mProfileArtistEditCellView.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleEditTextView)
            make.top.equalTo(mSignatureArtistEditCellView.snp.bottom)
        }
        
        self.mSafeView.addSubview(mConfirmButton)
        mConfirmButton.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleEditTextView)
            make.top.equalTo(mProfileArtistEditCellView.snp.bottom).offset(45)
            make.height.equalTo(50)
        }
        
        self.mSafeView.addSubview(mCancelButton)
        mCancelButton.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleEditTextView)
            make.top.equalTo(mConfirmButton.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
    }
    
    //MARK: UI
    lazy var mPrimaryImageView: ArtistEditImageView = {
        let view = ArtistEditImageView()
        return view
    }()
    
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Artwork cover".localString
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mDesLabel: UILabel = {
        let label = UILabel()
        label.text = "Only used for the artworks list\npage “Cover” display;"
        label.numberOfLines = 5
        label.font = .systemFont(ofSize: 11)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mDesLabel2: UILabel = {
        let label = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.4
        let attributedString = NSAttributedString(string: "JPG, PNG formats supported;\nDo not upload img over3Mb;".localString, attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        label.attributedText = attributedString
        label.numberOfLines = 5
        label.font = .systemFont(ofSize: 11)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mCoverImageView: ArtistEditImageView = {
        let view = ArtistEditImageView()
        return view
    }()
    
    lazy var mCoverTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Artwork details".localString
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mCoverDesLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "Only used for the artworks details\npage display".localString + "(0/6);", attributes: [NSAttributedString.Key.foregroundColor : ThemeColor.gray.color()])
        label.attributedText = attributedString
        label.numberOfLines = 5
        label.font = .systemFont(ofSize: 11)
        return label
    }()
    
    lazy var mCoverTipLabel: UILabel = {
        let label = UILabel()
        label.text = "*Notice: The 1st upload image will be show as the artwork image.".localString
        label.numberOfLines = 2
        label.textColor = .red
        label.font = .systemFont(ofSize: 11)
        return label
    }()
    
    
    lazy var mArtistEditImageListView: ArtistEditImageListView = {
        let view = ArtistEditImageListView()
        return view
    }()
    
    lazy var mTipButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.contentType = .contentFit(padding: .zero, gap: 0)
        button.mTitleLabel.attributedText = NSAttributedString(string: "Tips".localString, attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.black.color()])
        button.mTitleLabel.font = .systemFont(ofSize: 13)
        button.mTitleLabel.textColor = ThemeColor.black.color()
        return button
    }()
    
    lazy var mTitleEditTextView: ArtistEditTitleTextView = {
        let view = ArtistEditTitleTextView()
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
    
    lazy var mMediumArtistEditCellView: ArtistEditCellView = {
        let view = ArtistEditCellView()
        view.mTitleLabel.text = "Medium".localString
        return view
    }()
    
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
    
    lazy var mArtistEditFrameSizeCellView: ArtistEditSizeCellView = {
        let view = ArtistEditSizeCellView()
        view.mTitleLabel.text = "Artwork with frame".localString
        view.isHidden = true
        return view
    }()
    
    lazy var mArtistEditFrameWeightCellView: ArtistEditTextFieldCellView = {
        let view = ArtistEditTextFieldCellView()
        view.mTitleLabel.text = "Weight（kg）".localString
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
    
    lazy var mProfileArtistEditCellView: ArtistEditCellView = {
        let view = ArtistEditCellView()
        view.mTitleLabel.text = "Artwork profile（Optional）".localString
        return view
    }()
    
    lazy var mConfirmButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.contentType = .center(gap: 0)
        button.mTitleLabel.text = "Submit".localString
        button.mTitleLabel.font = .systemFont(ofSize: 14)
        button.mTitleLabel.textColor = UIColor.dd.color(hexValue: 0xffffff)
        button.backgroundColor = ThemeColor.black.color()
        return button
    }()
    
    lazy var mCancelButton: DDButton = {
        let button = DDButton()
        button.isHidden = true
        button.imageSize = .zero
        button.contentType = .center(gap: 0)
        button.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        button.mTitleLabel.textColor = ThemeColor.black.color()
        button.mTitleLabel.font = .systemFont(ofSize: 14)
        button.mTitleLabel.text = "Remove".localString
        button.layer.borderColor = ThemeColor.black.color().cgColor
        button.layer.borderWidth = 1
        return button
    }()
}

extension ArtistEditVC {
    func _initData() {
        if let goodsID = self.goodsID {
            _ = DDAPI.shared.request("settled/goodsInfo", data: ["goods_id": goodsID]).subscribe(onSuccess: { [weak self] response in
                guard let self = self else { return }
                let json = JSON(response.data)
                //转换model和sku
                let skuList = json["sku_list"].arrayValue.map { sku in
                    let skuModel = ArtistEditSKUModel()
                    skuModel.update(json: sku)
                    return skuModel
                }
                self.editModel = ArtistEditModel()
                self.editModel.update(json: json)
                self.editModel.skuList = skuList
                //刷新页面
                self._reloadData()
            })
        }
    }
    
    func _reloadData() {
        self.mCancelButton.isHidden = (self.goodsID == nil || self.editModel.status != 2)
        self.mPrimaryImageView.mImageView.kf.setImage(with: URL(string: self.editModel.primaryImage.fileurl))
        //详情图片列表
        let modelList = self.editModel.imageList.map({ model in
            return model.fileurl
        })
        self.mCoverImageView.mImageView.kf.setImage(with: URL(string: modelList.first ?? ""))
        self.mArtistEditImageListView.isHidden = modelList.count < 1
        let leftModelList = Array(modelList.dropFirst())
        self.mArtistEditImageListView.updateImages(images: leftModelList)
        //更新提示
        let attributedString = NSMutableAttributedString(string: "Only used for the artworks details\npage display".localString + " (\(self.editModel.imageList.count)/6);", attributes: [NSAttributedString.Key.foregroundColor : ThemeColor.gray.color()])
        self.mCoverDesLabel.attributedText = attributedString
        //描述
        self.mTitleEditTextView.mTextField.text = self.editModel.name
        if self.editModel.categoryID > 0, let json = DDServerConfigTools.shared.getCategory(id: self.editModel.categoryID) {
            self.mMediumArtistEditCellView.setDes(text: json["title"].stringValue)
            
        }
        if String.isAvailable(self.editModel.intro) {
            self.mProfileArtistEditCellView.setDes(text: self.editModel.intro)
        }
        //雕塑
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
        //SKU信息
        guard let firstSKU = self.editModel.skuList.first else { return }
        if firstSKU.frameType == .include {
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
        self.mArtistEditPriceTextView.mTextField.text = "\(firstSKU.workPrice)"
        //金额转换
        self._moneyExchange(value: firstSKU.workPrice)
        if let year = firstSKU.year {
            if  year > 0 {
                self.mYearArtistEditTextField.setDes(text: "\(year)")
            } else {
                self.mYearArtistEditTextField.setDes(text: "Unknown year".localString)
            }
        } else {
            self.mYearArtistEditTextField.setDes(text: nil)
        }
        self.mMaterialArtistEditCellView.setDes(text: firstSKU.meterialString())
        if firstSKU.height > 0 {
            self.mArtistEditSizeCellView.mHeightTextfield.text = "\(firstSKU.height)"
        }
        if firstSKU.width > 0 {
            self.mArtistEditSizeCellView.mWidthTextfield.text = "\(firstSKU.width)"
        }
        if firstSKU.length > 0 {
            self.mArtistEditSizeCellView.mLengthTextfield.text = "\(firstSKU.length)"
        }
        if firstSKU.height_mount > 0 {
            self.mArtistEditFrameSizeCellView.mHeightTextfield.text = "\(firstSKU.height_mount)"
        }
        if firstSKU.width_mount > 0 {
            self.mArtistEditFrameSizeCellView.mWidthTextfield.text = "\(firstSKU.width_mount)"
        }
        if firstSKU.length_mount > 0 {
            self.mArtistEditFrameSizeCellView.mLengthTextfield.text = "\(firstSKU.length_mount)"
        }
        if firstSKU.weight > 0 {
            self.mArtistEditFrameWeightCellView.mHeightTextfield.text = "\(firstSKU.weight)"
        }
        if let frameType = firstSKU.frameType {
            self.mFrameArtistEditCellView.setDes(text: frameType.title())
        }
        if let numberType = firstSKU.numberType {
            self.mRarityArtistEditCellView.setDes(text: numberType.title())
        }
        self.mSignatureArtistEditCellView.setDes(text: firstSKU.hasSignature ? "YES".localString : "NO".localString)
    }
    
    func _bindView() {
        _ = self.mPrimaryImageView.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            ZLPhotoConfiguration.default().allowSelectVideo = false
            ZLPhotoConfiguration.default().maxSelectCount = 1
            let ps = ZLPhotoPicker()
            ps.selectImageBlock = { results, isOriginal in
                // your code
                if let image = results.first?.image.pngData() {
                    HDHUD.show(icon: .loading, duration: -1)
                    _ = DDAPI.shared.upload("settled/uploadPhoto", params: [:], data: image).subscribe(onNext: { response in
                        HDHUD.hide()
                        let json = JSON(response.data)
                        let model = SettleInFileModel()
                        model.fileurl = json["fileurl"].stringValue
                        model.filename = json["filename"].stringValue
                        self.editModel.primaryImage = model
                        self.mPrimaryImageView.mImageView.kf.setImage(with: URL(string: self.editModel.primaryImage.fileurl))
                    }, onError: { _ in
                        HDHUD.hide()
                    })
                }
            }
            ps.showPhotoLibrary(sender: self)
        })
        
        _ = self.mCoverImageView.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            ZLPhotoConfiguration.default().allowSelectVideo = false
            ZLPhotoConfiguration.default().maxSelectCount = 1
            let ps = ZLPhotoPicker()
            ps.selectImageBlock = { results, isOriginal in
                // your code
                if let image = results.first?.image.pngData() {
                    HDHUD.show(icon: .loading, duration: -1)
                    _ = DDAPI.shared.upload("settled/uploadPhoto", params: [:], data: image).subscribe(onNext: { response in
                        HDHUD.hide()
                        let json = JSON(response.data)
                        let model = SettleInFileModel()
                        model.fileurl = json["fileurl"].stringValue
                        model.filename = json["filename"].stringValue
                        if self.editModel.imageList.isEmpty {
                            self.editModel.imageList.append(model)
                        } else {
                            self.editModel.imageList[0] = model
                        }
                        self._reloadData()
                    }, onError: { _ in
                        HDHUD.hide()
                    })
                }
            }
            ps.showPhotoLibrary(sender: self)
        })
        
        _ = self.mArtistEditImageListView.clickSubject.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            ZLPhotoConfiguration.default().allowSelectVideo = false
            ZLPhotoConfiguration.default().maxSelectCount = 1
            let ps = ZLPhotoPicker()
            ps.selectImageBlock = { results, isOriginal in
                // your code
                if let image = results.first?.image.pngData() {
                    HDHUD.show(icon: .loading, duration: -1)
                    _ = DDAPI.shared.upload("settled/uploadPhoto", params: [:], data: image).subscribe(onNext: { response in
                        HDHUD.hide()
                        let json = JSON(response.data)
                        let model = SettleInFileModel()
                        model.fileurl = json["fileurl"].stringValue
                        model.filename = json["filename"].stringValue
                        if self.editModel.imageList.count > index + 1{
                            self.editModel.imageList[index + 1] = model
                        } else {
                            self.editModel.imageList.append(model)
                        }
                        self._reloadData()
                    }, onError: { _ in
                        HDHUD.hide()
                    })
                }
            }
            ps.showPhotoLibrary(sender: self)
        })
        
        _ = self.mTipButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = ArtistEditImageTipsVC(bottomPadding: 100)
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mTitleEditTextView.mTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.editModel.name = self.mTitleEditTextView.mTextField.text ?? ""
        })
        
        _ = self.mArtistEditPriceTextView.mTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let model = self.editModel.skuList.first ?? ArtistEditSKUModel()
            model.workPrice = Int(self.mArtistEditPriceTextView.mTextField.text ?? "") ?? 0
            if self.editModel.skuList.count > 0 {
                self.editModel.skuList[0] = model
            } else {
                self.editModel.skuList.append(model)
            }
            //金额转换
            self._moneyExchange(value: model.workPrice)
        })
        
        _ = self.mMediumArtistEditCellView.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = ArtistEditMediumVC(editModel: self.editModel)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mYearArtistEditTextField.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = ArtistEditYearVC(SKUModel: self.editModel.firstSKU())
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mMaterialArtistEditCellView.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = ArtistEditMeterialVC(SKUModel: self.editModel.firstSKU())
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mArtistEditSizeCellView.widthPublish.subscribe(onNext: { [weak self] width in
            guard let self = self else { return }
            self.editModel.firstSKU().width = width
        })
        
        _ = self.mArtistEditSizeCellView.heightPublish.subscribe(onNext: { [weak self] height in
            guard let self = self else { return }
            self.editModel.firstSKU().height = height
        })
        
        _ = self.mArtistEditSizeCellView.lengthPublish.subscribe(onNext: { [weak self] length in
            guard let self = self else { return }
            self.editModel.firstSKU().length = length
        })
        
        _ = self.mArtistEditFrameSizeCellView.widthPublish.subscribe(onNext: { [weak self] width in
            guard let self = self else { return }
            self.editModel.firstSKU().width_mount = width
        })
        
        _ = self.mArtistEditFrameSizeCellView.heightPublish.subscribe(onNext: { [weak self] height in
            guard let self = self else { return }
            self.editModel.firstSKU().height_mount = height
        })
        
        _ = self.mArtistEditFrameSizeCellView.lengthPublish.subscribe(onNext: { [weak self] length in
            guard let self = self else { return }
            self.editModel.firstSKU().length_mount = length
        })
        
        _ = self.mArtistEditFrameWeightCellView.textPublish.subscribe(onNext: { [weak self] weight in
            guard let self = self else { return }
            self.editModel.firstSKU().weight = Int(weight) ?? 0
        })
        
        _ = self.mFrameArtistEditCellView.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = ArtistEditFrameVC(SKUModel: self.editModel.firstSKU())
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mRarityArtistEditCellView.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = ArtistEditRarityVC(SKUModel: self.editModel.firstSKU())
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mSignatureArtistEditCellView.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = ArtistEditSignatureVC(SKUModel: self.editModel.firstSKU())
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mProfileArtistEditCellView.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = ArtistEditInfoVC(editModel: self.editModel)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if !self.editModel.isAvailable() {
                HDHUD.show("Please complete the required information".localString)
                return
            }
            if !self.editModel.firstSKU().isAvailable() {
                HDHUD.show("Please complete the required information".localString)
                return
            }
            let vc = ArtistEditPreviewVC(editModel: self.editModel)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mCancelButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            //下架
            let warn = DDWarnPopView(title: "Notice".localString, content: "After the artwork removed, it need to be reviewed again for the resubmit.".localString)
            warn.showSecondButton = true
            warn.mFirstButton.setTitle("Cancel".localString, for: .normal)
            warn.mSecondButton.setTitle("Confirm".localString, for: .normal)
            _ = warn.mClickSubject.subscribe(onNext: { [weak self] clickInfo in
                guard let self = self else { return }
                DDPopView.hide()
                if clickInfo.clickType == .cancel {
                    //下架
                    _ = DDAPI.shared.request("settled/undercarriage", data: ["goods_id": self.goodsID ?? 0]).subscribe(onSuccess: {  [weak self] response in
                        self?.navigationController?.popToRootViewController(animated: true)
                        HDHUD.show("Removed".localString)
                    })
                }
            })
            DDPopView.show(view: warn)
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
