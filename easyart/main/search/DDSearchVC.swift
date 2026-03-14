//
//  DDSearchVC.swift
//  easyart
//
//  Created by Damon on 2024/11/21.
//

import UIKit
import DDUtils
import SwiftyJSON
import MJRefresh

class DDSearchVC: BaseVC {
    var searchModel = DDSearchModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadBarTitle(title: "Search".localString, textColor: ThemeColor.black.color())
        self._bindView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //fix: 返回根目录左侧箭头存在
        self.loadBarItem(image: nil, itemPosition: .left) { _ in
            
        }
        self._loadData()
    }
    
    override func createUI() {
        super.createUI()
        
        self.mSafeView.addSubview(mSearchOptionView)
        mSearchOptionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
        }
        
        self.mSafeView.addSubview(mSearchTextField)
        mSearchTextField.snp.makeConstraints { make in
            make.left.equalTo(mSearchOptionView.snp.right).offset(5)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(36)
        }
        
        self.mSafeView.addSubview(mSearchButton)
        mSearchButton.snp.makeConstraints { make in
            make.right.equalTo(mSearchTextField).offset(-10)
            make.centerY.equalTo(mSearchTextField)
            make.width.equalTo(17)
            make.height.equalTo(15)
        }
        
        self.mSafeView.addSubview(mDefaultView)
        mDefaultView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mSearchTextField.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
        }
        
        self.mSafeView.addSubview(mResultView)
        mResultView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mSearchTextField.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    //MARK: UI
    lazy var mSearchOptionView: DDSearchOptionView = {
        let view = DDSearchOptionView()
        return view
    }()
    
    lazy var mSearchTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.dd.color(hexValue: 0xF5F5F5)
        textField.textColor = ThemeColor.main.color()
        textField.font = .systemFont(ofSize: 14)
        textField.attributedPlaceholder = NSAttributedString(string: "Search artists, artworks, etc".localString, attributes: [NSAttributedString.Key.foregroundColor : ThemeColor.lightGray.color()])
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 12, height: 1)))
        textField.layer.masksToBounds = true
        textField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        textField.layer.cornerRadius = 18
        textField.returnKeyType = .search
        textField.delegate = self
        return textField
    }()
    
    lazy var mSearchButton: DDButton = {
        let button = DDButton(imagePosition: .left)
        button.normalImage = UIImage(named: "icon-search")
        button.imageSize = CGSize(width: 17, height: 15)
        button.contentType = .center(gap: 0)
        return button
    }()
    
    lazy var mDefaultView: DDSearchDefaultView = {
        let view = DDSearchDefaultView()
        return view
    }()
    
    lazy var mResultView: DDSearchResultView = {
        let view = DDSearchResultView()
        view.isHidden = true
        return view
    }()
}

extension DDSearchVC {
    func _bindView() {
        _ = self.mSearchOptionView.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = DDSearchFilterVC(searchModel: self.searchModel)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mDefaultView.authorClickPublish.subscribe(onNext: { [weak self] model in
            guard let self = self else { return }
            let vc = DDAuthorDetailVC(id: model.artist_id)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mDefaultView.imgClickPublish.subscribe(onNext: { [weak self] model in
            guard let self = self else { return }
            let vc = DetailVC(goodsID: model.goods_id)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mDefaultView.recentClickPublish.subscribe(onNext: { [weak self] model in
            guard let self = self else { return }
            if model.type == .goods {
                let vc = DetailVC(goodsID: "\(model.id)")
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = DDAuthorDetailVC(id: "\(model.id)")
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
        
        _ = self.mResultView.authorClickPublish.subscribe(onNext: { [weak self] id in
            guard let self = self else { return }
            let vc = DDAuthorDetailVC(id: id)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mResultView.resultClickPublish.subscribe(onNext: { [weak self] model in
            guard let self = self else { return }
            if model.type == .goods {
                let vc = DetailVC(goodsID: "\(model.id)")
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = DDAuthorDetailVC(id: "\(model.id)")
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
        
        _ = self.mResultView.resetClickPublish.subscribe(onNext: { [weak self] id in
            guard let self = self else { return }
            self.mSearchTextField.text = nil
            self.searchModel.keyword = ""
            self.searchModel.reset()
            self._loadData()
        })
        
        _ = self.mSearchTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let text = self.mSearchTextField.text ?? ""
            self.searchModel.keyword = text
            self._loadData()
        })
    }
    
    func _loadData() {
        let filterCount = self.searchModel.getTotalCount()
        self.mSearchOptionView.updateCount(number: filterCount)
        if filterCount > 0 || String.isAvailable(self.mSearchTextField.text) {
            self.mDefaultView.isHidden = true
            self.mResultView.isHidden = false
            self.mResultView.search(model: self.searchModel)
        } else {
            self.mDefaultView.isHidden = false
            self.mResultView.isHidden = true
            self.mDefaultView.loadData()
        }
    }
}

extension DDSearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
