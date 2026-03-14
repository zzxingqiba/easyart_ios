//
//  DetailVC.swift
//  easyart
//
//  Created by Damon on 2024/11/15.
//

import UIKit
import KakaJSON
import RxRelay
import SwiftyJSON
import DDUtils
import Lightbox
import HDHUD

class DetailVC: BaseVC {
    private var goodsID: String
    let pageInfo = BehaviorRelay<JSON>(value: JSON())
    let skuInfo = BehaviorRelay<JSON>(value: JSON())
    var selectedSKUInfo = JSON()
    var packageViewModel = DDPackageViewModel()
    var isOnleStatus: Bool {    //禁止购买
        return self.pageInfo.value["goods_info"]["is_not_sell"].boolValue
    }
    var isOwner: Bool = false   //是否是发布者
    private var list = [ArtModel]()
    
    init(goodsID: String) {
        self.goodsID = goodsID
        super.init(bottomPadding: 100)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._loadData()
        if self.isOwner {
            self.mRecomendTitleLabel.isHidden = true
            self.mCollectionView.isHidden = true
        } else {
            self._loadRecomendData()
        }
        
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.contentType = .flex
        self.mSafeView.addSubview(mBannerView)
        mBannerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(mBannerView.snp.width)
        }
        
        self.mSafeView.addSubview(mPageControl)
        mPageControl.snp.makeConstraints { make in
            make.top.equalTo(mBannerView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        self.mSafeView.addSubview(mShareButton)
        mShareButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(mPageControl.snp.bottom).offset(5)
        }
        
        self.mSafeView.addSubview(mViewButton)
        mViewButton.snp.makeConstraints { make in
            make.centerY.equalTo(mShareButton)
            make.left.equalTo(mShareButton.snp.right).offset(25)
        }
        
        self.mSafeView.addSubview(mFavLabel)
        mFavLabel.snp.makeConstraints { make in
            make.centerY.equalTo(mShareButton)
            make.right.equalToSuperview().offset(-16)
        }
        
        self.mSafeView.addSubview(mFavButton)
        mFavButton.snp.makeConstraints { make in
            make.centerY.equalTo(mShareButton)
            make.right.equalTo(mFavLabel.snp.left).offset(-12)
        }
        
        self.mSafeView.addSubview(mBaseInfoView)
        mBaseInfoView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mFavButton.snp.bottom).offset(25)
        }
        
        //多规格
        self.mSafeView.addSubview(mSKUListView)
        mSKUListView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mBaseInfoView.snp.bottom)
        }
        
        self.mSafeView.addSubview(mIntroContractView)
        mIntroContractView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mSKUListView.snp.bottom).offset(16)
        }
        
        self.mSafeView.addSubview(mGoodsDetailAuthorView)
        mGoodsDetailAuthorView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mIntroContractView.snp.bottom).offset(10)
        }
        
        self.mSafeView.addSubview(mGoodsDetailTaxesView)
        mGoodsDetailTaxesView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mGoodsDetailAuthorView.snp.bottom)
        }
        
        self.mSafeView.addSubview(mGoodsDetailConnectionView)
        mGoodsDetailConnectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mGoodsDetailTaxesView.snp.bottom)
        }
        
        self.mSafeView.addSubview(mPackageContractView)
        mPackageContractView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mGoodsDetailConnectionView.snp.bottom).offset(30)
        }
        
        self.mSafeView.addSubview(mTipContractView)
        mTipContractView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mPackageContractView.snp.bottom).offset(30)
        }
        
        self.mSafeView.addSubview(mRecomendTitleLabel)
        mRecomendTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(mTipContractView.snp.bottom).offset(28)
            make.left.equalToSuperview().offset(16)
        }
        self.mSafeView.addSubview(mCollectionView)
        mCollectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mRecomendTitleLabel.snp.bottom).offset(20)
            make.height.equalTo(1)
        }
        
        
        self.view.addSubview(mBottomButton)
        mBottomButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50 + BottomSafeAreaHeight)
        }
        
        self.view.addSubview(mAudioPlayerView)
        mAudioPlayerView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }

    //MARK: UI
    lazy var mBannerView: DDSwiperView = {
        let view = DDSwiperView()
        view.imageContentMode = .scaleAspectFit
        view.mPageControl.isHidden = true
        return view
    }()
    
    public lazy var mPageControl: DDPageControl = {
        var pageControl = DDPageControl()
        return pageControl
    }()
    
    lazy var mShareButton: DDButton = {
        let button = DDButton(imagePosition: .left)
        button.normalImage = UIImage(named: "icon-share")
        button.contentType = .contentFit(padding: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0), gap: 5)
        button.mTitleLabel.text = "Share".localString
        button.mTitleLabel.font = .systemFont(ofSize: 11)
        button.mTitleLabel.textColor = ThemeColor.black.color()
        button.imageSize = CGSize(width: 10, height: 10)
        return button
    }()
    
    lazy var mViewButton: DDButton = {
        let button = DDButton(imagePosition: .left)
        button.normalImage = UIImage(named: "icon-eye")
        button.contentType = .contentFit(padding: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0), gap: 5)
        button.mTitleLabel.text = "View in Room".localString
        button.mTitleLabel.font = .systemFont(ofSize: 11)
        button.mTitleLabel.textColor = ThemeColor.black.color()
        button.imageSize = CGSize(width: 10, height: 10)
        button.isHidden = true
        return button
    }()
    
    lazy var mFavButton: DDButton = {
        let button = DDButton(imagePosition: .left)
        button.normalImage = UIImage(named: "home_aixin-h")
        button.contentType = .contentFit(padding: .zero, gap: 5)
        button.mTitleLabel.text = "Save".localString
        button.mTitleLabel.font = .systemFont(ofSize: 11)
        button.mTitleLabel.textColor = ThemeColor.black.color()
        button.imageSize = CGSize(width: 10, height: 10)
        button.isHidden = true
        return button
    }()
    
    lazy var mFavLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 11)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mAudioPlayerView : DDAudioPlayerView = {
        let view = DDAudioPlayerView()
        view.isHidden = true
        return view
    }()
    
    lazy var mBaseInfoView: GoodsDetailBaseInfoView = {
        let view = GoodsDetailBaseInfoView()
        return view
    }()
    
    lazy var mSKUListView: SKUListView = {
        let view = SKUListView()
        return view
    }()
    
    lazy var mIntroContractView: GoodsDetailIntroView = {
        let view = GoodsDetailIntroView()
        return view
    }()
    
    lazy var mGoodsDetailAuthorView: GoodsDetailAuthorView = {
        let view = GoodsDetailAuthorView()
        return view
    }()
    
    lazy var mGoodsDetailTaxesView: GoodsDetailTaxesView = {
        let view = GoodsDetailTaxesView()
        return view
    }()
    
    lazy var mGoodsDetailConnectionView: GoodsDetailConnectionView = {
        let view = GoodsDetailConnectionView()
        return view
    }()
    
    lazy var mPackageContractView: DetailContractView = {
        let view = DetailContractView()
        return view
    }()
    
    lazy var mTipContractView: DetailContractView = {
        let view = DetailContractView()
        return view
    }()
    
    lazy var mRecomendTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Recommended for you".localString
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: (UIScreenWidth - 48) / 2, height: (UIScreenWidth - 48) / 2 + 90)
        let tCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tCollection.allowsMultipleSelection = false
        tCollection.showsVerticalScrollIndicator = false
        tCollection.backgroundColor = UIColor.clear
        tCollection.delegate = self
        tCollection.dataSource = self
        tCollection.register(ArtCollectionViewCell.self, forCellWithReuseIdentifier: "ArtCollectionViewCell")
        return tCollection
    }()
    
    lazy var mBottomButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isHidden = true
        button.setTitle("Buy".localString, for: .normal)
        button.backgroundColor = ThemeColor.black.color()
        button.setTitleColor(UIColor.dd.color(hexValue: 0xffffff), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        return button
    }()
}


extension DetailVC {
    func _loadData() {
        HDHUD.show(icon: .loading, duration: -1)
        _ = DDAPI.shared.request("goods/detail", data: ["goods_id": self.goodsID]).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            let data = JSON(response.data)
            self.pageInfo.accept(data)
            //获取sku
            self._loadSKUData()
        }, onFailure: { _ in
            HDHUD.hide()
        })
    }
    
    func _loadSKUData() {
        _ = DDAPI.shared.request("goods/skuList", data: ["goods_id": self.goodsID]).subscribe(onSuccess: { [weak self] response in
            HDHUD.hide()
            guard let self = self else { return }
            let data = JSON(response.data)
            //调整SKU的选择
            if (data["sku_list"].arrayValue.count == 1) {
                self.selectedSKUInfo = data["sku_list"].arrayValue.first!
                self.mSKUListView.SKUList = []
                self.mSKUListView.isHidden = true
                mIntroContractView.snp.updateConstraints { make in
                    make.top.equalTo(self.mSKUListView.snp.bottom).offset(-20)
                }
            } else {
                self.mSKUListView.SKUList = data["sku_list"].arrayValue
                self.mSKUListView.isHidden = false
                mIntroContractView.snp.updateConstraints { make in
                    make.top.equalTo(self.mSKUListView.snp.bottom).offset(16)
                }
            }
            self.skuInfo.accept(data["sku_list"])
            //更新介绍信息
            self._transformFoldInfoList(goodsInfo: self.pageInfo.value["goods_info"])
        }, onFailure: { _ in
            HDHUD.hide()
        })
    }
    
    func _loadRecomendData() {
        _ = DDAPI.shared.request("goods/recommendList", data: ["goods_id": self.goodsID]).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            let data = JSON(response.data)
            let goodsList = (data["goods_list"].arrayObject as? [[String: Any]]) ?? []
            self.list =  goodsList.kj.modelArray(ArtModel.self)
            self.mCollectionView.reloadData()
        })
    }
    
    func _bindView() {
        _ = self.pageInfo.subscribe(onNext: { [weak self] info in
            guard let self = self else { return }
            let goodsInfo = info["goods_info"]
            self.mGoodsDetailAuthorView.updateUI(model: goodsInfo)
            self.loadBarTitle(title: goodsInfo["name"].stringValue, textColor: ThemeColor.black.color())
            
            let list = goodsInfo["pic_list"].arrayValue.map { json in
                return json["small_url"].stringValue
            }
            self.mBannerView.updateUI(list: list)
            self.mPageControl.numberOfPages = list.count
            //
            self.mFavLabel.text = goodsInfo["collect_num"].stringValue
            if goodsInfo["is_collect"].boolValue {
                self.mFavButton.mTitleLabel.text = "Saved".localString
                self.mFavButton.normalImage = UIImage(named: "home_aixin")
            } else {
                self.mFavButton.mTitleLabel.text = "Save".localString
                self.mFavButton.normalImage = UIImage(named: "home_aixin-h")
            }
            
            //播放进度
            if !goodsInfo["audio"].stringValue.isEmpty {
                self.mAudioPlayerView.prepare(url: goodsInfo["audio"].stringValue)
            }
        })
        
        _ = self.mBannerView.clickPublish.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            let goodsInfo = self.pageInfo.value["goods_info"]
            let imagesList = goodsInfo["pic_list"].arrayValue.map { json in
                let url = json["big_url"].stringValue
                return LightboxImage(imageURL: URL(string: url)!)
            }
            let controller = LightboxController(images: imagesList)
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true)
        })
        
        _ = self.packageViewModel.packageIndex.subscribe(onNext: { [weak self] index in
            guard let self = self, self.selectedSKUInfo["id"].string != nil else { return }
            self._updateBottomButton()
        })
        
        _ = self.skuInfo.subscribe(onNext: { [weak self] skuInfo in
            guard let self = self, !skuInfo.isEmpty else { return }
            if (skuInfo.arrayValue.count == 1) {
                self.selectedSKUInfo = skuInfo.arrayValue.first!
            }
            //
            let goodsInfo = self.pageInfo.value["goods_info"]
            self.mBaseInfoView.updateUI(goodsInfo: goodsInfo, selectedSKU: self.selectedSKUInfo, singleSKU: skuInfo.arrayValue.count == 1)
            //底部按钮
            self._updateBottomButton()
            //雕塑不显示
            if goodsInfo["category_id"].intValue != 1 {
                self.mViewButton.isHidden = false
                self.mFavButton.isHidden = false
            }
        })
        
        _ = self.mBannerView.scrollPublish.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.mPageControl.currentPage = index
        })
        
        _ = self.mShareButton.rx.tap.subscribe(onNext: { index in
            ShareTools.shared.share(type: .url(image: nil, text: nil, url: "https://apps.apple.com/en/app/id6738575033"), complete: nil)
        })
        
        _ = self.mFavButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self._collect()
        })
        
        _ = self.mBaseInfoView.authorClickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = DDAuthorDetailVC(id: self.pageInfo.value["goods_info"]["artist_id"].stringValue)
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mGoodsDetailAuthorView.followPublish.subscribe(onNext: { [weak self] isFollowed in
            guard let self = self else { return }
            _ = DDAPI.shared.request("settled/artistCollect", data: ["artist_id": self.pageInfo.value["goods_info"]["artist_id"].stringValue, "type": isFollowed ? 2 : 1]).subscribe(onSuccess: { [weak self] _ in
                guard let self = self else { return }
                self.mGoodsDetailAuthorView.follow(isFollow: !isFollowed)
            })
        })
        
        _ = self.mSKUListView.clickSKUPublish.subscribe(onNext: { [weak self] sku in
            guard let self = self else { return }
            self.selectedSKUInfo = sku
            //更新标题
            let goodsInfo = self.pageInfo.value["goods_info"]
            self.mBaseInfoView.updateUI(goodsInfo: goodsInfo, selectedSKU: self.selectedSKUInfo, singleSKU: self.skuInfo.value.arrayValue.count == 1)
            self._updateBottomButton()
            self._transformFoldInfoList(goodsInfo: goodsInfo)
        })
        
        _ = self.mIntroContractView.clickPublish.subscribe(onNext: { [weak self] tag in
            guard let self = self else { return }
            if tag == 0 {
                let pop = DDGoodsEditionPopView()
                _ = pop.mClickSubject.subscribe(onNext: { _ in
                    DDPopView.hide()
                })
                DDPopView.show(view: pop, animationType: .bottom)
            } else if tag == 6 {
                let model = SectionShowModel()
                let goodsInfo = self.pageInfo.value["goods_info"]
                model.imgURL = goodsInfo["cover_url"].stringValue
                if self.selectedSKUInfo["length"].intValue > 0 && self.selectedSKUInfo["width"].intValue > 0 {
                    model.length = self.selectedSKUInfo["length"].floatValue
                    model.width = self.selectedSKUInfo["width"].floatValue
                }
                let vc = DDPackageViewController(model: model, viewModel: self.packageViewModel)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
        
        _ = mCollectionView.rx.observe(CGSize.self, "contentSize").subscribe(onNext: { [weak self] (contentSize) in
            guard let self = self, let contentSize = contentSize else { return }
            self.mCollectionView.snp.updateConstraints { (make) in
                make.height.equalTo(contentSize.height)
            }
        })
        
        _ = self.mGoodsDetailConnectionView.clickPublish.subscribe(onNext: { _ in
            UIApplication.shared.open(URL(string: "mailto:co@easyart.cn")!)
        })
        
        _ = self.mViewButton.rx.tap.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            let model = SectionShowModel()
            let goodsInfo = self.pageInfo.value["goods_info"]
            model.imgURL = goodsInfo["cover_url"].stringValue
            if self.selectedSKUInfo["length_mount"].intValue > 0 && self.selectedSKUInfo["width_mount"].intValue > 0 {
                model.length = self.selectedSKUInfo["length_mount"].floatValue
                model.width = self.selectedSKUInfo["width_mount"].floatValue
            } else {
                model.length = self.selectedSKUInfo["length"].floatValue
                model.width = self.selectedSKUInfo["width"].floatValue
            }
            let vc = SectionShowVC(model: model)
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = mBaseInfoView.audioClickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.mAudioPlayerView.show(play: true)
        })
        
        _ = self.mAudioPlayerView.mAudioTool.audioPublish.subscribe(onNext: { [weak self] status in
            guard let self = self else { return }
            if (status == .playing) {
                DispatchQueue.main.async {
                    self.mBaseInfoView.mAudioButton.addRotationAnimation()
                }
            } else if (status == .resume) {
                DispatchQueue.main.async {
                    self.mBaseInfoView.mAudioButton.resumeAnimation()
                }
            } else {
                DispatchQueue.main.async {
                    self.mBaseInfoView.mAudioButton.pauseAnimation()
                }
            }
        })
        
        _ = self.mBottomButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if self.mBottomButton.tag == 1000 {
                UIApplication.shared.open(URL(string: "mailto:info@easyart.cn")!)
            } else if self.mBottomButton.tag == 1001 {
                if self.selectedSKUInfo["mount_type"].intValue == 1 && !self.pageInfo.value["useDecorate"].arrayValue.isEmpty && !self.isOnleStatus && self.packageViewModel.packageIndex.value == nil {
                    //可选装裱时没有选装裱增加弹窗确认
                    let warn = DDWarnPopView(title: "", content: "This work has been selected without framing, confirm to continue the purchasing".localString)
                    _ = warn.mClickSubject.subscribe(onNext: { [weak self] clickInfo in
                        guard let self = self else { return }
                        DDPopView.hide()
                        if clickInfo.clickType == .confirm {
                            //跳到详情页
                            self._confirmOrder()
                        }
                    })
                    DDPopView.show(view: warn)
                } else {
                    //直接跳到详情页
                    self._confirmOrder()
                }
            } else if self.mBottomButton.tag == 1002 {
                //交易中无需点击
            } else if self.mBottomButton.tag == 1003 {
                //已售
                UIApplication.shared.open(URL(string: "mailto:info@easyart.cn")!)
            } else if self.mBottomButton.tag == 2001 {
                let vc = ArtistEditVC(bottomPadding: 80)
                vc.goodsID = Int(self.goodsID)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
    
    func _updateBottomButton() {
        let goodsInfo = self.pageInfo.value["goods_info"]
        if self.isOwner {
            if goodsInfo["status"].intValue == 5 {
                self.mBottomButton.isHidden = false
                self.mBottomButton.tag = 2000
                self.mBottomButton.setTitle("Release".localString, for: .normal)
                self.mBottomButton.backgroundColor = ThemeColor.black.color()
            } else if goodsInfo["show_status"].intValue == GoodsShowStatus.normal.rawValue || goodsInfo["show_status"].intValue == GoodsShowStatus.sold.rawValue || goodsInfo["show_status"].intValue == GoodsShowStatus.new.rawValue || goodsInfo["show_status"].intValue == 10 {
                self.mBottomButton.isHidden = false
                self.mBottomButton.tag = 2001
                self.mBottomButton.setTitle("Edit".localString, for: .normal)
                self.mBottomButton.backgroundColor = ThemeColor.black.color()
            } else if goodsInfo["show_status"].intValue == GoodsShowStatus.draf.rawValue {
                self.mBottomButton.isHidden = false
                self.mBottomButton.tag = 2001
                self.mBottomButton.setTitle("Continue Editing".localString, for: .normal)
                self.mBottomButton.backgroundColor = ThemeColor.black.color()
            } else if goodsInfo["show_status"].intValue == GoodsShowStatus.inOrder.rawValue {
                self.mBottomButton.isHidden = false
                self.mBottomButton.tag = 2002
                self.mBottomButton.setTitle("In the process of trading".localString + "...", for: .normal)
                self.mBottomButton.backgroundColor = ThemeColor.gray.color()
            } else if goodsInfo["show_status"].intValue == GoodsShowStatus.waitReview.rawValue {
                self.mBottomButton.isHidden = false
                self.mBottomButton.tag = 2003
                self.mBottomButton.setTitle("Under review".localString + "...", for: .normal)
                self.mBottomButton.backgroundColor = ThemeColor.gray.color()
            } else if goodsInfo["show_status"].intValue == GoodsShowStatus.reviewFail.rawValue {
                self.mBottomButton.isHidden = false
                self.mBottomButton.tag = 2001
                self.mBottomButton.setTitle("Publishing failed, click to republish".localString, for: .normal)
                self.mBottomButton.backgroundColor = ThemeColor.red.color()
            }
        } else {
            if self.pageInfo.value["goods_info"]["buy_type"].intValue == 1 {
                //国籍禁止购买，但需要显示商品价格
                self.mBottomButton.isHidden = false
                self.mBottomButton.tag = 1000
                if self.packageViewModel.packageIndex.value == nil {
                    self.mBottomButton.setTitle("$" + self.selectedSKUInfo["pay_price"].stringValue + "  |  " + "Contact".localString, for: .normal)
                } else {
                    self.mBottomButton.setTitle("$" + self.selectedSKUInfo["pay_price"].stringValue + " + " + self.packageViewModel.getTotalPrice() + "  |  " + "Contact".localString, for: .normal)
                }
                self.mBottomButton.backgroundColor = ThemeColor.black.color()
            } else if self.isOnleStatus {
                //商品禁止购买
                self.mBottomButton.isHidden = false
                self.mBottomButton.tag = 1000
                self.mBottomButton.setTitle("Inquire about artwork".localString, for: .normal)
                self.mBottomButton.backgroundColor = ThemeColor.main.color()
            } else if goodsInfo["show_status"].intValue == 0 {
                self.mBottomButton.isHidden = false
                self.mBottomButton.tag = 1001
                if self.packageViewModel.packageIndex.value == nil {
                    self.mBottomButton.setTitle("$" + self.selectedSKUInfo["pay_price"].stringValue + "  |  " + "Buy".localString, for: .normal)
                } else {
                    self.mBottomButton.setTitle("$" + self.selectedSKUInfo["pay_price"].stringValue + " + " + self.packageViewModel.getTotalPrice() + "  |  " + "Buy".localString, for: .normal)
                }
                self.mBottomButton.backgroundColor = ThemeColor.black.color()
            } else if goodsInfo["show_status"].intValue == GoodsShowStatus.inOrder.rawValue {
                self.mBottomButton.isHidden = false
                self.mBottomButton.tag = 1002
                self.mBottomButton.setTitle("In the process of trading".localString + "...", for: .normal)
                self.mBottomButton.backgroundColor = ThemeColor.gray.color()
            } else if goodsInfo["show_status"].intValue == GoodsShowStatus.sold.rawValue {
                self.mBottomButton.isHidden = false
                self.mBottomButton.tag = 1003
                self.mBottomButton.setTitle("Contact".localString, for: .normal)
                self.mBottomButton.backgroundColor = ThemeColor.black.color()
            }
        }
    }
    
    func _confirmOrder() {
        if !self.selectedSKUInfo["number_list"].arrayValue.isEmpty {
            let numberList =  self.selectedSKUInfo["number_list"].arrayValue.compactMap { model in
                if model["status"].intValue == 0 {
                    return model
                }
                return nil
            }
            let numberPop = DDGoodsNumberPopView(title: "Please select".localString + self.selectedSKUInfo["number_unit"].stringValue, numberList: numberList)
            _ = numberPop.mClickSubject.subscribe(onNext: { [weak self] clickInfo in
                guard let self = self else { return }
                DDPopView.hide()
                if clickInfo.clickType == .confirm, let json = clickInfo.info as? JSON {
                    let model = DDPlaceOrderModel(goodsID: self.goodsID, packageViewModel: self.packageViewModel)
                    model.skuInfo = self.selectedSKUInfo
                    model.numberID = json["id"].stringValue
                    model.numberVal = json["number_val"].intValue
                    let vc = ConfirmOrderVC(model: model)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
            DDPopView.show(view: numberPop, animationType: .bottom)
        } else {
            let model = DDPlaceOrderModel(goodsID: self.goodsID, packageViewModel: self.packageViewModel)
            model.skuInfo = self.selectedSKUInfo
            let vc = ConfirmOrderVC(model: model)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func _collect() {
        var pageInfo = self.pageInfo.value
        var info = pageInfo["goods_info"]
        _ = DDAPI.shared.request("goods/collect", data: ["goods_id": info["goods_id"].stringValue, "type": info["is_collect"].boolValue ? 2 : 1]).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            let json = JSON(response.data)
            info["is_collect"] = JSON(!info["is_collect"].boolValue)
            info["collect_num"] = JSON(json["goods_info"]["collect_num"].intValue)
            pageInfo["goods_info"] = info
            self.pageInfo.accept(pageInfo)
            //更新状态
            DDUserTools.shared.updateCollect(isNew: json["user_info"]["collect_new"].boolValue, number: json["user_info"]["collect_num"].stringValue)
        })
    }
    
    func _collect(indexPath: IndexPath) {
        var model: ArtModel
        model = self.list[indexPath.item]
        _ = DDAPI.shared.request("goods/collect", data: ["goods_id": model.goods_id, "type": model.is_collect ? 2 : 1]).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            let json = JSON(response.data)
            model.is_collect = !model.is_collect
            model.collect_num = json["goods_info"]["collect_num"].intValue
            self.mCollectionView.reloadItems(at: [indexPath])
            //更新状态
            DDUserTools.shared.updateCollect(isNew: json["user_info"]["collect_new"].boolValue, number: json["user_info"]["collect_num"].stringValue)
        })
    }
    
    func _transformFoldInfoList(goodsInfo: JSON) {
        let useDecorate = self.pageInfo.value["useDecorate"].arrayValue.map({ json in
            return json.stringValue
        })
        self.mIntroContractView.updateUI(goodsInfo: goodsInfo, SKUInfo: self.selectedSKUInfo, isOnleStatus: self.isOnleStatus, useDecorate: useDecorate, hasChooseFrame: self.packageViewModel.packageIndex.value != nil)
        self._updateAuthorContractView(author: goodsInfo["artist_info"].stringValue)
        self._updatePackageContractView()
        self._updateTipContractView()
    }
    
    func _updateAuthorContractView(author: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        let attributedString = NSAttributedString(string: author, attributes: [.foregroundColor: ThemeColor.gray.color(), NSAttributedString.Key.paragraphStyle : paragraphStyle])
        
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.attributedText = attributedString
        
//        self.mAuthorContractView.updateUI(title: "Artist profile".localString, intro: author, contentView: [label])
    }
    
    func _updatePackageContractView() {
        let image = UIImage(named: "home_package1")!
        let imageView = UIImageView(image: image)
        imageView.snp.makeConstraints { make in
            make.height.equalTo(imageView.snp.width).multipliedBy(image.size.height/image.size.width)
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        let attributedString = NSAttributedString(string: "Customization: Classic framing".localString + "\n", attributes: [.foregroundColor: ThemeColor.gray.color(), NSAttributedString.Key.paragraphStyle : paragraphStyle])
        
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.attributedText = attributedString
        
        let image2 = UIImage(named: "home_package2")!
        let imageView2 = UIImageView(image: image2)
        imageView2.snp.makeConstraints { make in
            make.height.equalTo(imageView2.snp.width).multipliedBy(image2.size.height/image2.size.width)
        }
        let attributedString2 = NSAttributedString(string: "Professional gift packaging".localString, attributes: [.foregroundColor: ThemeColor.gray.color(), NSAttributedString.Key.paragraphStyle : paragraphStyle])
        let label2 = UILabel()
        label2.numberOfLines = 0
        label2.font = .systemFont(ofSize: 12)
        label2.attributedText = attributedString2
        self.mPackageContractView.updateUI(title: "Framing and packaging".localString, intro: "Professional customization, Expand to view details".localString, contentView: [imageView, label, imageView2, label2])
    }
    
    func _updateTipContractView() {
        let tip = "1. Please make the transaction within 15 minutes after placing the order. Overdue order will be invalid automatically；\n2. Only two terms of payment: Credit card, ApplePay；\n3. All the artworks will be checked and packed by Easyart then shipped to buyers；\n4. All artwork shall be delivered within 15 working days (delivery may be delayed by unexpected accidents or traffic) after checked and confirmed by Easyart. Also, for some artwork, delivery date is shown on the detailed description page；\n5. If Easyart determines that the artwork cannot be arranged, or for other reasons, we may cancel your order；\n6. International shipping fee including logistics and tariffs will be charged；\n7. Please check the delivery status on arrival to confirm the artwork condition；\n8. No returns-with-no-reason for all artwork orders； ".localString
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        let attributedString = NSAttributedString(string: tip, attributes: [.foregroundColor: ThemeColor.gray.color(), NSAttributedString.Key.paragraphStyle : paragraphStyle])
        
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.attributedText = attributedString
        
        self.mTipContractView.updateUI(title: "Purchase notice".localString, intro: "We do not support 7-day no reason returns".localString, contentView: [label])
    }
}

extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = list[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtCollectionViewCell", for: indexPath) as! ArtCollectionViewCell
        cell.favClickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self._collect(indexPath: indexPath)
        }).disposed(by: cell.disposeBag)
        
        cell.imgClickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = DetailVC(goodsID: model.goods_id)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: cell.disposeBag)
        
        cell.authorClickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = DDAuthorDetailVC(id: model.artist_id)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: cell.disposeBag)
        
        cell.updateUI(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
