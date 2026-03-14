//
//  ArtistEditPreviewVC.swift
//  easyart
//
//  Created by Damon on 2025/1/21.
//

import UIKit
import SwiftyJSON
import DDLoggerSwift
import HDHUD

class ArtistEditPreviewVC: BaseVC {
    private var editModel: ArtistEditModel
    
    init(editModel: ArtistEditModel) {
        self.editModel = editModel
        super.init(bottomPadding: 100)
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
        self.mSafeView.addSubview(mImageView)
        mImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(30)
            make.width.height.equalTo(105)
        }
        
        self.mSafeView.addSubview(mArtistEditPreviewImageItemView)
        mArtistEditPreviewImageItemView.snp.makeConstraints { make in
            make.left.equalTo(mImageView.snp.right).offset(10)
            make.bottom.equalTo(mImageView)
            make.width.equalTo(120)
        }
        
        self.mSafeView.addSubview(mPreviewButton)
        mPreviewButton.snp.makeConstraints { make in
            make.top.equalTo(mImageView)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(30)
        }
        
        self.mSafeView.addSubview(mPreviewContentView)
        mPreviewContentView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(mImageView.snp.bottom).offset(25)
        }
        
        self.mSafeView.addSubview(mAddNewButton)
        mAddNewButton.snp.makeConstraints { make in
            make.top.equalTo(mPreviewContentView.snp.bottom).offset(10)
            make.left.right.equalTo(mPreviewContentView)
            make.height.equalTo(50)
        }
        
        self.mSafeView.addSubview(mDraftButton)
        mDraftButton.snp.makeConstraints { make in
            make.left.right.equalTo(mPreviewContentView)
            make.top.equalTo(mAddNewButton.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        
        self.mSafeView.addSubview(mConfirmButton)
        mConfirmButton.snp.makeConstraints { make in
            make.left.right.equalTo(mPreviewContentView)
            make.top.equalTo(mDraftButton.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        
    }
    
    //MARK: UI
    lazy var mImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = ThemeColor.line.color()
        return imageView
    }()
    
    lazy var mArtistEditPreviewImageItemView: ArtistEditPreviewImageItemView = {
        let view = ArtistEditPreviewImageItemView()
        return view
    }()
    
    lazy var mPreviewButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.contentType = .contentFit(padding: .zero, gap: 0)
        button.mTitleLabel.attributedText = NSAttributedString(string: "Preview".localString, attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.black.color()])
        button.mTitleLabel.font = .systemFont(ofSize: 13)
        button.mTitleLabel.textColor = ThemeColor.black.color()
        return button
    }()
    
    lazy var mPreviewContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mAddNewButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.contentType = .center(gap: 0)
        button.mTitleLabel.attributedText = NSAttributedString(string: "Add a new edition".localString, attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.black.color()])
        button.mTitleLabel.font = .systemFont(ofSize: 13)
        button.mTitleLabel.textColor = ThemeColor.black.color()
        return button
    }()
    
    lazy var mDraftButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.contentType = .center(gap: 0)
        button.mTitleLabel.text = "Save draft".localString
        button.mTitleLabel.font = .systemFont(ofSize: 14)
        button.mTitleLabel.textColor = ThemeColor.black.color()
        button.backgroundColor = ThemeColor.white.color()
        
        button.layer.borderColor = ThemeColor.black.color().cgColor
        button.layer.borderWidth = 0.5
        return button
    }()
    
    lazy var mConfirmButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.contentType = .center(gap: 0)
        button.mTitleLabel.text = "Confirm".localString
        button.mTitleLabel.font = .systemFont(ofSize: 14)
        button.mTitleLabel.textColor = UIColor.dd.color(hexValue: 0xffffff)
        button.backgroundColor = ThemeColor.black.color()
        return button
    }()
    
}

extension ArtistEditPreviewVC {
    func _bindView() {
        _ = self.mAddNewButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            //添加一个新的
            let skuModel = self.editModel.firstSKU().copySKU()
            let vc = ArtistEditSKUVC(editModel: self.editModel, SKUModel: skuModel, isNewSKU: true)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mPreviewButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self._popPreview()
        })
        
        _ = self.mDraftButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            //提交
            self._goodsSave(isDraf: true)
        })
        
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            //提交
            self._goodsSave(isDraf: false)
        })
    }
    
    func _loadData() {
        self.mImageView.kf.setImage(with: URL(string: self.editModel.primaryImage.fileurl))
        self.mArtistEditPreviewImageItemView.imageList = self.editModel.imageList.map({ model in
            return model.fileurl
        })
        
        //隐藏草稿想按钮
        if self.editModel.show_status == 10 {
            //草稿箱
            self.mDraftButton.isHidden = false
            mDraftButton.snp.updateConstraints { make in
                make.height.equalTo(50)
            }
        } else {
            self.mDraftButton.isHidden = true
            mDraftButton.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
        //sku列表
        for view in self.mPreviewContentView.subviews {
            view.removeFromSuperview()
        }
        var posView: UIView?
        for i in 0..<self.editModel.skuList.count {
            let skuModel = self.editModel.skuList[i]
            let view = ArtistEditPreviewItemView()
            view.showEditButton = true
            if i == 0 {
                view.mTitleLabel.text = "Edition".localString + " " + "#\(i + 1)" + "(主sku)".localString
            } else {
                view.mTitleLabel.text = "Edition".localString + " " + "#\(i + 1)"
            }
            
            view.showProfile = i == 0
            view.updateUI(model: self.editModel, sku: skuModel)
            self.mPreviewContentView.addSubview(view)
            _ = view.editPublish.subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if (i == 0) {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    //点击编辑
                    let vc = ArtistEditSKUVC(editModel: self.editModel, SKUModel: skuModel, isNewSKU: false)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
            view.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                if let posView = posView {
                    make.top.equalTo(posView.snp.bottom)
                } else {
                    make.top.equalToSuperview()
                }
            }
            if i == self.editModel.skuList.count - 1 {
                view.snp.makeConstraints { make in
                    make.bottom.equalToSuperview().offset(-20)
                }
            }
            posView = view
        }
        
    }
    
    func _popPreview() {
        let view = ArtistEditImagePreviewPopView()
        var imageList = self.editModel.imageList.map({ model in
            return model.fileurl
        })
        imageList.insert(self.editModel.primaryImage.fileurl, at: 0)
        view.updateUI(imageList: imageList)
        _ = view.clickPublish.subscribe(onNext: { _ in
            DDPopView.hide()
        })
        DDPopView.show(view: view)
    }
    
    //0:未完成,1:未上架 2:上架 4:删除 5:取消发布
    func _goodsSave(isDraf: Bool) {
        let detail_pic_list = editModel.imageList.map({ fileModel in
            return ["name": fileModel.filename]
        })
        var detail_pic_listString = ""
        if !detail_pic_list.isEmpty {
            let picListJson = JSON(detail_pic_list)
            detail_pic_listString = picListJson.rawString(.utf8, options: .init(rawValue: 0)) ?? ""
        }
        
        var data: [String : Any] = ["name": editModel.name,
                    "intro": editModel.intro,
                    "category_id": editModel.categoryID,
                    "photo_name": editModel.primaryImage.filename,
                    "detail_pic_list": detail_pic_listString,
                    "show_status": isDraf ? "10" : "5"
        ]
        if let id = editModel.id {
            data["id"] = id
        }
        HDHUD.show(icon: .loading, duration: -1, mask: true)
        _ = DDAPI.shared.request("settled/goodsSave", data: data).subscribe(onSuccess: { [weak self] response in
            HDHUD.hide()
            guard let self = self else { return }
            let json = JSON(response.data)
            self._skuSafe(goodsID: json["goods_id"].intValue)
        }, onFailure: { _ in
            HDHUD.hide()
        })
    }
    
    func _skuSafe(goodsID: Int) {
        let skuList = editModel.skuList.map { skuModel in
            let data: [String: Any] = [
                "sku_id": skuModel.id,
                "years": skuModel.year ?? 0,
                "length": skuModel.length,
                "width": skuModel.width,
                "height": skuModel.height,
                "weight": skuModel.weight,
                "length_mount": skuModel.length_mount,
                "width_mount": skuModel.width_mount,
                "height_mount": skuModel.height_mount,
                "pay_price": skuModel.workPrice,
                "material": skuModel.customMeterial.isSelected ? skuModel.customMeterial.title : "",
                "material_ids": Array(skuModel.meterialIDList).map({ id in
                    return "\(id)"
                }).joined(separator: ","),
                "mount_type": skuModel.frameType?.rawValue ?? ArtistEditFrameType.none.rawValue,
                "stock_num": skuModel.stockNumber,
                "real_stock_num": skuModel.realStockNumber ?? 0,
                "number_type": skuModel.numberType!.rawValue,
                "numberVals": skuModel.numberList.joined(separator: ",")
            ]
            return data
        }
        if let jsonString = JSON(skuList).rawString() {
            _ = DDAPI.shared.request("settled/skuSave", data: ["goods_id": goodsID, "sku_list": jsonString]).subscribe(onSuccess: { [weak self] response in
                guard let self = self else { return }
                HDHUD.hide()
                self.navigationController?.popToRootViewController(animated: true)
            }, onFailure: { _ in
                HDHUD.hide()
            })
        } else {
            HDHUD.hide()
            printLog("json转码错误")
        }
        
    }
}
