//
//  HDNavigationItemMenuPopView.swift
//  HDPopView
//
//  Created by Damon on 2022/3/15.
//

import UIKit
import RxSwift
import DDUtils

open class HDNavigationItemMenuPopView: HDPopContentView {
    private var mTableViewList = [(UIImage?, NSAttributedString?)]()  //频繁更新的tabview
    private let tableViewClick = PublishSubject<HDPopButtonClickInfo>()
    
    public init() {
        super.init(frame: .zero)
        self.contentOffset = CGPoint(x: 0, y: DDUtils_Default_NavigationBar_Height() - 5)
        self._bindView()
        self._createUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI
    public private(set) lazy var mImageView: UIImageView = {
        let tImageView = UIImageView(image: UIImageHDPopBoundle(named: "pop_white"))
        return tImageView
    }()
    
    public private(set) lazy var mTableView: UITableView = {
        let tTableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        if #available(iOS 15.0, *) {
            tTableView.sectionHeaderTopPadding = 0
        }
        tTableView.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        tTableView.showsVerticalScrollIndicator = false
        tTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tTableView.isScrollEnabled = false
        tTableView.dataSource = self
        tTableView.delegate = self
        tTableView.register(HDNavigationMenuItemTableViewCell.self, forCellReuseIdentifier: HDNavigationMenuItemTableViewCell.dd.className())
        tTableView.layer.cornerRadius = 6
        return tTableView
    }()
}

public extension HDNavigationItemMenuPopView {
    func update(menuItems: [(UIImage?, String?)]) {
        let _menuItems = menuItems.map { items -> (UIImage?, NSAttributedString?) in
            if let string = items.1 {
                return (items.0, NSAttributedString(string: string))
            }
            return (items.0, nil)
        }
        self.update(menuItems: _menuItems)
    }

    func update(menuItems: [(UIImage?, NSAttributedString?)]) {
        self.mTableViewList = menuItems
        self.mTableView.reloadData()
    }
}

private extension HDNavigationItemMenuPopView {
    func _createUI() {
        self.backgroundColor = UIColor.clear
        self.snp.makeConstraints { make in
            make.width.equalTo(115)
        }
        self.addSubview(self.mImageView)
        mImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-7)
            make.top.equalToSuperview()
            make.width.height.equalTo(17)
        }
        
        self.addSubview(mTableView)
        mTableView.snp.makeConstraints { (make) in
            make.top.equalTo(mImageView).offset(8)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
    
    func _bindView() {
        _ = tableViewClick.bind(to: self.clickBinder)
        
        _ = mTableView.rx.observe(CGSize.self, "contentSize").subscribe(onNext: { [weak self] (contentSize) in
            guard let self = self, let contentSize = contentSize else { return }
            DispatchQueue.main.async {
                self.mTableView.isScrollEnabled = contentSize.height > 400
                self.mTableView.snp.updateConstraints({ (make) in
                    make.height.equalTo(min(Int(contentSize.height), 400))
                })
            }
            
        })
    }
}

extension HDNavigationItemMenuPopView: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mTableViewList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.mTableViewList[indexPath.row]
        let cell  = tableView.dequeueReusableCell(withIdentifier: HDNavigationMenuItemTableViewCell.dd.className()) as! HDNavigationMenuItemTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.updateUI(image: model.0, title: model.1)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        return footerView
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableViewClick.onNext(HDPopButtonClickInfo(clickType: .custom, info: indexPath.row))
    }
}
