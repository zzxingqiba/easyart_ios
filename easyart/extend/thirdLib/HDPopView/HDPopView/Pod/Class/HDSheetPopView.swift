//
//  HDSheetPopView.swift
//  HDPopViewDemo
//
//  Created by Damon on 2020/12/26.
//

import UIKit
import DDUtils
import RxSwift

open class HDSheetPopView: HDPopContentView {
    private var buttonList = [NSAttributedString]()
    private var showCancel = true
    private let tableViewClick = PublishSubject<HDPopButtonClickInfo>()

    public convenience init(title: String?, content: String, buttonList: [NSAttributedString], showCancel: Bool = true) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        paragraphStyle.alignment = .center
        let attributed = NSAttributedString(string: content, attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        self.init(title: title, content: attributed, buttonList: buttonList, showCancel: showCancel)
    }

    public init(title: String?, content: NSAttributedString, buttonList: [NSAttributedString], showCancel: Bool = true) {
        super.init(frame: .zero)
        self.p_createUI()
        self.p_bindView()
        self.mTitleLabel.text = title
        self.mContentLabel.attributedText = content
        self.buttonList = buttonList
        self.showCancel = showCancel
        if showCancel {
            let attributed = NSAttributedString(string: NSLocalizedString("取消", comment: ""), attributes: [NSAttributedString.Key.foregroundColor : UIColor.dd.color(hexValue: 0xFF584E)])
            self.buttonList.append(attributed)
        }
        self.mTableView.reloadData()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lazy
    public lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.textColor = UIColor.dd.color(hexValue: 0x000000)
        tLabel.font = .systemFont(ofSize: 20, weight: .medium)
        tLabel.textAlignment = .center
        return tLabel
    }()

    lazy var mContentLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.numberOfLines = 0
        tLabel.textColor = UIColor.dd.color(hexValue: 0x666666)
        tLabel.font = .systemFont(ofSize: 14)
        tLabel.lineBreakMode = .byCharWrapping
        return tLabel
    }()
    
    public private(set) lazy var mTableView: UITableView = {
        let tTableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        if #available(iOS 15.0, *) {
            tTableView.sectionHeaderTopPadding = 0
        }
        tTableView.backgroundColor = UIColor.clear
        tTableView.rowHeight = 48
        tTableView.estimatedRowHeight = 48
        tTableView.showsVerticalScrollIndicator = false
        tTableView.separatorStyle = .singleLine
        tTableView.separatorColor = UIColor.dd.color(hexValue: 0xeeeeee)
        tTableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tTableView.dataSource = self
        tTableView.delegate = self
        tTableView.register(HDSheetTableViewCell.self, forCellReuseIdentifier: "HDSheetTableViewCell")
        return tTableView
    }()
}

private extension HDSheetPopView {
    func p_createUI() {
        self.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 12
        self.snp.makeConstraints { (make) in
            make.width.equalTo(310)
        }

        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
        }

        self.addSubview(mContentLabel)
        mContentLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(20)
        }

        self.addSubview(mTableView)
        mTableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(mContentLabel.snp.bottom).offset(20)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
    
    func p_bindView() {
        _ = mTableView.rx.observe(CGSize.self, "contentSize").subscribe(onNext: { [weak self] (contentSize) in
            guard let self = self, let contentSize = contentSize else { return }
            DispatchQueue.main.async {
                self.mTableView.isScrollEnabled = contentSize.height > 400
                self.mTableView.snp.updateConstraints({ (make) in
                    make.height.equalTo(min(Int(contentSize.height), 400))
                })
            }
        })

        _ = tableViewClick.bind(to: self.clickBinder)
    }
}

extension HDSheetPopView: UITableViewDataSource, UITableViewDelegate {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.buttonList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let attributed = self.buttonList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "HDSheetTableViewCell") as! HDSheetTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.updateUI(title: attributed)
        return cell
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
        if self.showCancel {
            if indexPath.row == self.buttonList.count - 1 {
                self.tableViewClick.onNext(HDPopButtonClickInfo(clickType: .cancel, info: nil))
            } else {
                self.tableViewClick.onNext(HDPopButtonClickInfo(clickType: .custom, info: indexPath.row))
            }
        } else {
            self.tableViewClick.onNext(HDPopButtonClickInfo(clickType: .custom, info: indexPath.row))
        }
        
    }
}
