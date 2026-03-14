//
//  DDAuthorDetailVC.swift
//  easyart
//
//  Created by Damon on 2024/9/23.
//

import UIKit
import RxRelay
import SwiftyJSON
import MJRefresh
import DDUtils

class DDAuthorDetailVC: BaseVC {
    var pageCur = 1
    var hasMore = true
    var list = [MeArtistModel?]()
    private var id: String
    private var authorDetail = JSON()
    
    init(id: String) {
        self.id = id
        super.init(bottomPadding: 20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
        self._loadData()
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.contentType = .flex
        self.mSafeView.addSubview(mCoverImageView)
        mCoverImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview()
            make.height.equalTo(mCoverImageView.snp.width)
        }
        
        self.mSafeView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mCoverImageView.snp.bottom).offset(20)
        }
        
        self.mSafeView.addSubview(mFollowLabel)
        mFollowLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mTitleLabel.snp.bottom).offset(5)
        }
        
        self.mSafeView.addSubview(mIntroContractView)
        mIntroContractView.snp.makeConstraints { make in
            make.left.right.equalTo(mCoverImageView)
            make.top.equalTo(mFollowLabel.snp.bottom).offset(24)
        }
        
        self.mSafeView.addSubview(mAuthorTitleLabel)
        mAuthorTitleLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mCoverImageView)
            make.top.equalTo(mIntroContractView.snp.bottom).offset(40)
        }
        
        self.mSafeView.addSubview(mCollectionView)
        mCollectionView.snp.makeConstraints { make in
            make.left.right.equalTo(mCoverImageView)
            make.top.equalTo(mAuthorTitleLabel.snp.bottom).offset(10)
            make.height.equalTo(1)
        }
    }
    
    //MARK: UI
    lazy var mCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mFollowLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mIntroContractView: DetailContractView = {
        let view = DetailContractView()
        view.isExpand = false
        return view
    }()
    
    lazy var mAuthorTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Artworks".localString
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
        tCollection.isScrollEnabled = false
        tCollection.allowsMultipleSelection = false
        tCollection.showsVerticalScrollIndicator = false
        tCollection.backgroundColor = UIColor.clear
        tCollection.delegate = self
        tCollection.dataSource = self
        tCollection.register(ArtistCollectionViewCell.self, forCellWithReuseIdentifier: "ArtistCollectionViewCell")
        return tCollection
    }()
}

extension DDAuthorDetailVC {
    func _loadData() {
        _ = DDAPI.shared.request("settled/getRoleInfo", data: ["id": self.id, "type": 2, "getContent": 1]).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            let data = JSON(response.data)
            self.authorDetail = data
            self.mCoverImageView.kf.setImage(with: URL(string: data["imgUrl"]["fileurl"].stringValue))
            self.mTitleLabel.text = data["name"].stringValue
            self._updateIntroContractView(intro: data["intro"].stringValue)
            if data["is_collect"].boolValue {
                self.mFollowLabel.attributedText = NSAttributedString(string: "Followed".localString, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.gray.color()])
            } else {
                self.mFollowLabel.attributedText = NSAttributedString(string: "Follow".localString, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.gray.color()])
            }
        })
        
        _ = DDAPI.shared.request("settled/goodsList", data: ["page_find": self.pageCur, "artist_id": self.id]).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            self.mCollectionView.mj_header?.endRefreshing()
            self.mCollectionView.mj_footer?.endRefreshing()
            //处理数据
            let data = JSON(response.data)
            let goodsList = (data["goods_list"].arrayObject as? [[String: Any]]) ?? []
            let list =  goodsList.kj.modelArray(MeArtistModel.self)
            if (self.pageCur == 1) {
                self.list = list
            } else {
                self.list.append(contentsOf: list)
            }
            if self.list.isEmpty {
                self.list.append(nil)
            }
            self.hasMore = data["has_more"].boolValue
            self.pageCur = data["page_curr"].intValue
            self.mCollectionView.reloadData()
        }, onFailure: { [weak self] _ in
            guard let self = self else { return }
            self.mCollectionView.mj_header?.endRefreshing()
            self.mCollectionView.mj_footer?.endRefreshing()
        })
    }
    
    func _collect(indexPath: IndexPath) {
        guard let model: MeArtistModel = self.list[indexPath.row] else { return }
        _ = DDAPI.shared.request("goods/collect", data: ["goods_id": model.id, "type": model.is_collect ? 2 : 1]).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            let json = JSON(response.data)
            model.is_collect = !model.is_collect
            model.collect_num = json["goods_info"]["collect_num"].intValue
            self.mCollectionView.reloadItems(at: [indexPath])
            //更新状态
            DDUserTools.shared.updateCollect(isNew: json["user_info"]["collect_new"].boolValue, number: json["user_info"]["collect_num"].stringValue)
        })
    }
    
    func _bindView() {
        _ = mCollectionView.rx.observe(CGSize.self, "contentSize").subscribe(onNext: { [weak self] (contentSize) in
            guard let self = self, let contentSize = contentSize else { return }
            self.mCollectionView.snp.updateConstraints { (make) in
                make.height.equalTo(contentSize.height)
            }
        })
        
        self.mCollectionView.addRefreshHeader { [weak self] in
            guard let self = self else { return }
            self.pageCur = 1
            self._loadData()
        }
        self.mCollectionView.addRefreshFooter { [weak self] in
            guard let self = self else { return }
            if self.hasMore {
                self.pageCur = self.pageCur + 1
                self._loadData()
            } else {
                self.mCollectionView.mj_footer?.endRefreshing()
            }
        }
        
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            _ = DDAPI.shared.request("settled/artistCollect", data: ["artist_id": self.id, "type":  self.authorDetail["is_collect"].boolValue ? 2 : 1]).subscribe(onSuccess: { [weak self] _ in
                guard let self = self else { return }
                //
                self.authorDetail["is_collect"].boolValue =  !self.authorDetail["is_collect"].boolValue
                if self.authorDetail["is_collect"].boolValue {
                    self.mFollowLabel.attributedText = NSAttributedString(string: "Followed".localString, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.gray.color()])
                } else {
                    self.mFollowLabel.attributedText = NSAttributedString(string: "Follow".localString, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.gray.color()])
                }
            })
        })
        self.mFollowLabel.addGestureRecognizer(tap)
        
    }
    
    func _updateIntroContractView(intro: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        let attributedString = NSAttributedString(string: intro, attributes: [.foregroundColor: ThemeColor.gray.color(), NSAttributedString.Key.paragraphStyle : paragraphStyle])
        
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.attributedText = attributedString
        
        self.mIntroContractView.updateUI(title: "Introduction".localString, intro: intro, contentView: [label])
    }
}

extension DDAuthorDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = list[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistCollectionViewCell", for: indexPath) as! ArtistCollectionViewCell
        cell.updateUI(model: model)
        cell.mAddImageView.snp.updateConstraints { make in
            make.width.height.equalTo(0)
        }
        cell.mAddTitleLabel.snp.updateConstraints { make in
            make.top.equalTo(cell.mAddImageView.snp.bottom).offset(-7)
        }
        cell.mAddTitleLabel.text = "Not Found".localString
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = list[indexPath.item] else { return }
        let vc = DetailVC(goodsID: "\(model.id)")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
