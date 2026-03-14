//
//  DDSearchArtistsFilterVC.swift
//  easyart
//
//  Created by Damon on 2024/11/25.
//

import UIKit
import SwiftyJSON

class DDSearchArtistsFilterVC: BaseVC {
    private var searchModel: DDSearchModel
    private var list: [DDSearchMulFilterModel] = []
    private var artistList: [JSON] = []
    
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
            make.bottom.equalToSuperview().offset(-71)
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
        let tTableView = UITableView(frame: CGRect.zero, style: .plain)
        tTableView.contentInsetAdjustmentBehavior = .never
        if #available(iOS 15.0, *) {
            tTableView.sectionHeaderTopPadding = 0
        }
        tTableView.allowsMultipleSelection = true
        tTableView.backgroundColor = UIColor.clear
        tTableView.separatorStyle = .none
        tTableView.delegate = self
        tTableView.dataSource = self
        tTableView.showsVerticalScrollIndicator = false
        tTableView.register(DDSearchMulFilterTableViewCell.self, forCellReuseIdentifier: "DDSearchMulFilterTableViewCell")
        tTableView.rowHeight = 50
        return tTableView
    }()
    
    lazy var mSearchFilterBottomView: DDSearchFilterBottomView = {
        let view = DDSearchFilterBottomView()
        return view
    }()
}

extension DDSearchArtistsFilterVC {
    func _bindView() {
        _ = self.mSearchFilterBottomView.confirmPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popToRootViewController(animated: true)
        })
        
        _ = self.mSearchFilterBottomView.clearPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.searchModel.artist_ids = Set<Int>()
            self._reloadData()
        })
    }
    
    func _loadData() {
        _ = DDAPI.shared.request("search/artistList").subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            let data = JSON(response.data)
            self.artistList = data["artist_list"].arrayValue
            self._reloadData()
        }, onFailure: { [weak self] _ in
            guard let self = self else { return }
            self.mTableView.mj_header?.endRefreshing()
            self.mTableView.mj_footer?.endRefreshing()
        })
    }
    
    func _reloadData() {
        self.list = self.artistList.map({ model in
            let filterModel = DDSearchMulFilterModel(id: model["id"].intValue, title: "", isSelected: self.searchModel.artist_ids.contains(where: { id in
                return id == model["id"].intValue
            }))
            let attributed = NSMutableAttributedString(string: model["name"].stringValue, attributes: [.foregroundColor: ThemeColor.black.color()])
            let country = NSAttributedString(string: " , " + model["country_name"].stringValue, attributes: [.foregroundColor: ThemeColor.gray.color()])
            attributed.append(country)
            filterModel.attributed = attributed
            return filterModel
        })
        self.mTableView.reloadData()
    }
}

extension DDSearchArtistsFilterVC: UITableViewDelegate, UITableViewDataSource {
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
        return 100
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let model = list[indexPath.row]
        model.isSelected = !model.isSelected
        if model.isSelected {
            self.searchModel.artist_ids.insert(model.id)
        } else {
            self.searchModel.artist_ids.remove(model.id)
        }
    }

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = list[indexPath.row]
        model.isSelected = !model.isSelected
        if model.isSelected {
            self.searchModel.artist_ids.insert(model.id)
        } else {
            self.searchModel.artist_ids.remove(model.id)
        }
    }
}
