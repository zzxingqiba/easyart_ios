//
//  SearchVC.swift
//  easyart
//
//  Created by Damon on 2024/9/23.
//

import UIKit
import DDUtils


class SearchVC: BaseVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadBarTitle(title: "Search".localString, textColor: ThemeColor.black.color())
        self._bindView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._loadData()
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.ignoreSafeAreaType = .bottom
        
        self.mSafeView.addSubview(mSearchTextField)
        mSearchTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(40)
        }
        
        self.mSafeView.addSubview(mCategoryTabView)
        mCategoryTabView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mSearchTextField.snp.bottom).offset(16)
            make.height.equalTo(30)
        }
        
        self.mSafeView.addSubview(mSearchGoodsView)
        mSearchGoodsView.snp.makeConstraints { make in
            make.top.equalTo(mCategoryTabView.snp.bottom).offset(16)
            make.left.right.equalTo(mSearchTextField)
            make.bottom.equalToSuperview()
        }
        
        self.mSafeView.addSubview(mSearchOrgView)
        mSearchOrgView.snp.makeConstraints { make in
            make.top.equalTo(mCategoryTabView.snp.bottom).offset(16)
            make.left.right.equalTo(mSearchTextField)
            make.bottom.equalToSuperview()
        }
        
        self.mSafeView.addSubview(mSearchAuthorView)
        mSearchAuthorView.snp.makeConstraints { make in
            make.top.equalTo(mCategoryTabView.snp.bottom).offset(16)
            make.left.right.equalTo(mSearchTextField)
            make.bottom.equalToSuperview()
        }
    }
    
    //MARK: UI
    lazy var mSearchTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.dd.color(hexValue: 0xF5F5F5)
        textField.textColor = ThemeColor.main.color()
        textField.font = .systemFont(ofSize: 14)
        textField.attributedPlaceholder = NSAttributedString(string: "Enter keywords to search for works".localString, attributes: [NSAttributedString.Key.foregroundColor : ThemeColor.lightGray.color()])
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 12, height: 1)))
        return textField
    }()
    
    lazy var mCategoryTabView: DDCategoryTabView = {
        let view = DDCategoryTabView()
        return view
    }()
    
    lazy var mSearchGoodsView: SearchGoodsView = {
        let view = SearchGoodsView()
        return view
    }()
    
    lazy var mSearchAuthorView: SearchAuthorView = {
        let view = SearchAuthorView()
        view.isHidden = true
        return view
    }()
    
    lazy var mSearchOrgView: SearchOrgView = {
        let view = SearchOrgView()
        view.isHidden = true
        return view
    }()

}

extension SearchVC {
    func _loadData() {
        if !self.mSearchGoodsView.isHidden {
            self.mSearchGoodsView.reloadData()
        }
        if !self.mSearchOrgView.isHidden {
            self.mSearchOrgView.reloadData()
        }
        if !self.mSearchAuthorView.isHidden {
            self.mSearchAuthorView.reloadData()
        }
    }
    
    func _bindView() {
        _ = self.mSearchTextField.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            if self.mCategoryTabView.selectedIndex == 0 {
                self.mSearchGoodsView.name = text
            } else if self.mCategoryTabView.selectedIndex == 1 {
                self.mSearchAuthorView.name = text
            } else if self.mCategoryTabView.selectedIndex == 2 {
                self.mSearchOrgView.name = text
            }
        })
        
        _ = self.mCategoryTabView.indexChange.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.mSearchGoodsView.isHidden = index != 0
            self.mSearchAuthorView.isHidden = index != 1
            self.mSearchOrgView.isHidden = index != 2
        })
        
        _ = self.mSearchGoodsView.clickPublish.subscribe(onNext: { [weak self] artModel in
            guard let self = self else { return }
            let vc = DetailVC(goodsID: artModel.goods_id)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mSearchAuthorView.clickPublish.subscribe(onNext: { [weak self] authorModel in
            guard let self = self else { return }
            //跳转作者详情
            let vc = DDAuthorDetailVC(id: authorModel.id)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mSearchOrgView.clickPublish.subscribe(onNext: { [weak self] orgModel in
            guard let self = self else { return }
            let vc = DDOrgDetailVC(id: orgModel.institute_id)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
}
