//
//  ArtistEditRarityVC.swift
//  easyart
//
//  Created by Damon on 2025/1/16.
//

import UIKit
import SwiftyJSON
import HDHUD

class ArtistEditRarityVC: BaseVC {

    private var SKUModel: ArtistEditSKUModel
    private var list: [[DDSearchMulFilterModel]] = []
    
    init(SKUModel: ArtistEditSKUModel) {
        self.SKUModel = SKUModel
        super.init()
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        self.mSafeView.addSubview(mConfirmButton)
        mConfirmButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(50)
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
//        tTableView.allowsMultipleSelection = true
        tTableView.backgroundColor = UIColor.clear
        tTableView.separatorStyle = .none
        tTableView.delegate = self
        tTableView.dataSource = self
        tTableView.showsVerticalScrollIndicator = false
        tTableView.register(ArtistEditSelecteTableViewCell.self, forCellReuseIdentifier: "ArtistEditSelecteTableViewCell")
        tTableView.register(ArtistEditRarityTableViewCell.self, forCellReuseIdentifier: "ArtistEditRarityTableViewCell")
        tTableView.register(ArtistEditRarityCountTableViewCell.self, forCellReuseIdentifier: "ArtistEditRarityCountTableViewCell")
        return tTableView
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

}

extension ArtistEditRarityVC {
    func _bindView() {
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if (self.SKUModel.realStockNumber == nil && self.SKUModel.numberType != .open) {
                HDHUD.show("Please enter the stockavailable.".localString)
                return
            }
            if let realStockNumber = self.SKUModel.realStockNumber, self.SKUModel.stockNumber < realStockNumber, self.SKUModel.numberType == .limit {
                HDHUD.show("The total number of editionnumbers cannot less than the stock available.".localString)
                return
            }
            self.navigationController?.popViewController(animated: true)
        })
        
        
    }
    
    func _loadData() {
        let numberList = DDServerConfigTools.shared.configInfo.value["number_type_list"].arrayValue
        //数量
        let model = DDSearchMulFilterModel(id: -1, title: "Number of works sold".localString, isSelected: false)
        var firstList = [DDSearchMulFilterModel]()
        firstList.append(model)
        
        var secendList = [DDSearchMulFilterModel]()
        //数组
        for model in numberList {
//            if model["id"].intValue == 11 {
//                //无限量
//                firstList.append(DDSearchMulFilterModel(id: model["id"].intValue, title: model["title"].stringValue, isSelected: self.SKUModel.numberType?.rawValue == model["id"].intValue))
//            } else {
//                let model1 = DDSearchMulFilterModel(id: model["id"].intValue, title: model["title"].stringValue, isSelected: self.SKUModel.numberType?.rawValue == model["id"].intValue)
//                secendList.append(model1)
//            }
            let model1 = DDSearchMulFilterModel(id: model["id"].intValue, title: model["title"].stringValue, isSelected: self.SKUModel.numberType?.rawValue == model["id"].intValue)
            secendList.append(model1)
        }
        
        self.list = [firstList, secendList]
        self.mTableView.reloadData()
    }
}

extension ArtistEditRarityVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.list.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionList = self.list[section]
        return sectionList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionList = self.list[indexPath.section]
        let model = sectionList[indexPath.row]
        
        if model.id == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistEditRarityTableViewCell") as! ArtistEditRarityTableViewCell
            cell.selectionStyle = .none
            cell.updateUI(model: model, SKUModel: self.SKUModel)
            if model.isSelected {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
            //文字输入
            cell.mTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.SKUModel.stockNumber = Int(cell.mTextField.text ?? "0") ?? 0
            }).disposed(by: cell.disposeBag)
            //点击
            cell.deletePublish.subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                self.SKUModel.numberList.remove(at: index)
                self.SKUModel.realStockNumber = (self.SKUModel.realStockNumber ?? 1) - 1
                DispatchQueue.main.async {
                    self._loadData()
                }
            }).disposed(by: cell.disposeBag)
            cell.clickPublish.subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                let pop = ArtistEditRarityNumberPopView(count: self.SKUModel.stockNumber)
                _ = pop.clickPublish.subscribe(onNext: { clickInfo in
                    DDPopView.hide()
                    if clickInfo.clickType == .confirm, let value = clickInfo.info as? Int {
                        self.SKUModel.numberList[index] = String(format: "%03d", value)
                        DispatchQueue.main.async {
                            self._loadData()
                        }
                    }
                })
                DDPopView.show(view: pop, animationType: .bottom)
            }).disposed(by: cell.disposeBag)
            
            cell.contentSizeChange.subscribe(onNext: { index in
                DispatchQueue.main.async {
                    tableView.beginUpdates()
                    tableView.endUpdates()
                }
            }).disposed(by: cell.disposeBag)
            return cell
        } else if model.id == -1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistEditRarityCountTableViewCell") as! ArtistEditRarityCountTableViewCell
            cell.selectionStyle = .none
            cell.updateUI(model: model, count: self.SKUModel.realStockNumber)
            if model.isSelected {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            } else {
                tableView.deselectRow(at: indexPath, animated: false)
            }
            cell.textChange.subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.SKUModel.realStockNumber = Int(text) ?? 0
                self.SKUModel.resetNumberList()
                self.SKUModel.numberType = nil
                DispatchQueue.main.async {
                    self._loadData()
                }
            }).disposed(by: cell.disposeBag)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistEditSelecteTableViewCell") as! ArtistEditSelecteTableViewCell
            cell.selectionStyle = .none
            cell.updateUI(model: model)
            if model.isSelected {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            } else {
                tableView.deselectRow(at: indexPath, animated: false)
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionList = self.list[indexPath.section]
        let model = sectionList[indexPath.row]
        if model.id == 1 {
            return UITableView.automaticDimension
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionList = self.list[indexPath.section]
        let model = sectionList[indexPath.row]
        if model.id == 1 {
            return UITableView.automaticDimension
        } else {
            return 60
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = ThemeColor.white.color()
        //label
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.gray.color()
        label.text = section == 0 ? "Sellable quantity".localString : "Edition".localString
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        if section == self.list.count - 1 {
            return 100
        }
        return 0.1
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == self.list.count - 1 {
            return 100
        }
        return 0.1
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionList = self.list[indexPath.section]
        let model = sectionList[indexPath.row]
        self.SKUModel.numberType = ArtistNumberType(rawValue: model.id)
        self._loadData()
    }
}

