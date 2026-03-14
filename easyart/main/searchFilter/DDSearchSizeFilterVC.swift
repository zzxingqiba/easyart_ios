//
//  DDSearchSizeFilterVC.swift
//  easyart
//
//  Created by Damon on 2024/11/28.
//

import UIKit
import SwiftyJSON

class DDSearchSizeFilterVC: BaseVC {
    private var searchModel: DDSearchModel
    private var list: [DDSearchMulFilterModel] = []
    private let sizeList: [DDSearchSizeRange] = [.small, .medium, .large]
    init(searchModel: DDSearchModel) {
        self.searchModel = searchModel
        super.init()
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._loadData()
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.addSubview(mTableView)
        mTableView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
        
        self.mSafeView.addSubview(mSearchFilterBottomView)
        mSearchFilterBottomView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        self._bindView()
    }

    //MARK: UI
    lazy var mTableView: UITableView = {
        let tTableView = UITableView(frame: CGRect.zero, style: .grouped)
        tTableView.contentInsetAdjustmentBehavior = .never
        if #available(iOS 15.0, *) {
            tTableView.sectionHeaderTopPadding = 0
        }
        tTableView.allowsMultipleSelection = true
        tTableView.backgroundColor = UIColor.clear
        tTableView.separatorStyle = .none
        tTableView.delegate = self
        tTableView.dataSource = self
        tTableView.isScrollEnabled = false
        tTableView.showsVerticalScrollIndicator = false
        tTableView.register(DDSearchMulFilterTableViewCell.self, forCellReuseIdentifier: "DDSearchMulFilterTableViewCell")
        tTableView.rowHeight = 60
        return tTableView
    }()
    
    lazy var mSearchSizeTextView: DDSearchSizeTextView = {
        let view = DDSearchSizeTextView()
        return view
    }()
    
    lazy var mSearchFilterBottomView: DDSearchFilterBottomView = {
        let view = DDSearchFilterBottomView()
        return view
    }()
}

extension DDSearchSizeFilterVC {
    func _bindView() {
        _ = self.mSearchFilterBottomView.confirmPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popToRootViewController(animated: true)
        })
        
        _ = self.mSearchFilterBottomView.clearPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.searchModel.sizeList = []
            self._loadData()
        })
    }
    
    func _loadData() {
        self.list = sizeList.map({ model in
            let model = DDSearchMulFilterModel(id: model.id(), title: model.title(), isSelected: self.searchModel.sizeList.contains(where: { range in
                return range.id() == model.id()
            }))
            return model
        })
        if let first = self.searchModel.sizeList.first {
            switch first {
            case .custom(let min, let max):
                self.mSearchSizeTextView.mMinTextField.text = "\(min)"
                self.mSearchSizeTextView.mMaxTextField.text = "\(max)"
            default:
                break
            }
        }
        self.mTableView.reloadData()
    }
}

extension DDSearchSizeFilterVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DDSearchMulFilterTableViewCell") as! DDSearchMulFilterTableViewCell
        let model = list[indexPath.row]
        cell.selectionStyle = .none
        cell.updateUI(model: model)
        if model.isSelected {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.addSubview(self.mSearchSizeTextView)
        self.mSearchSizeTextView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        if self.searchModel.sizeList.contains(where: { range in
            range.id() == 4
        }) {
            self.mSearchSizeTextView.isSelected = true
        } else {
            self.mSearchSizeTextView.isSelected = false
        }
        _ = self.mSearchSizeTextView.textChangePublish.subscribe(onNext: { [weak self] sizeText in
            guard let self = self else { return }
            if let size = sizeText {
                let range = DDSearchSizeRange.custom(min: size.0, max: size.1)
                self.searchModel.addSizeRange(size: range)
            } else {
                self.searchModel.sizeList = []
            }
            self._loadData()
        })
        return view
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let model = list[indexPath.row]
        let range = sizeList[indexPath.row]
        model.isSelected = !model.isSelected
        if model.isSelected {
            self.searchModel.addSizeRange(size: range)
        } else {
            self.searchModel.removeSizeRange(size: range)
        }
    }

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.mSearchSizeTextView.isSelected = false
        //更新内容
        let model = list[indexPath.row]
        let range = sizeList[indexPath.row]
        model.isSelected = !model.isSelected
        if model.isSelected {
            self.searchModel.addSizeRange(size: range)
        } else {
            self.searchModel.removeSizeRange(size: range)
        }
    }
}

