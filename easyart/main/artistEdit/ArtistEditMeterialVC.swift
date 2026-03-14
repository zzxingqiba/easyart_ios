//
//  ArtistEditMeterialVC.swift
//  easyart
//
//  Created by Damon on 2025/1/16.
//

import UIKit
import SwiftyJSON

class ArtistEditMeterialVC: BaseVC {

    private var SKUModel: ArtistEditSKUModel
    private var list: [DDSearchMulFilterModel] = []
    
    init(SKUModel: ArtistEditSKUModel) {
        self.SKUModel = SKUModel
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
        tTableView.allowsMultipleSelection = true
        tTableView.backgroundColor = UIColor.clear
        tTableView.separatorStyle = .none
        tTableView.delegate = self
        tTableView.dataSource = self
        tTableView.showsVerticalScrollIndicator = false
        tTableView.register(ArtistEditSelecteTableViewCell.self, forCellReuseIdentifier: "ArtistEditSelecteTableViewCell")
        tTableView.register(ArtistEditMeterialTableViewCell.self, forCellReuseIdentifier: "ArtistEditMeterialTableViewCell")
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

extension ArtistEditMeterialVC {
    func _bindView() {
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        })
        
        
    }
    
    func _loadData() {
        let materialList = DDServerConfigTools.shared.configInfo.value["material_list"].arrayValue
        self.list = materialList.map({ model in
            let model = DDSearchMulFilterModel(id: model["id"].intValue, title: model["title"].stringValue, isSelected: self.SKUModel.meterialIDList.contains(model["id"].intValue))
            return model
        })
        let model2 = DDSearchMulFilterModel(id: -1, title: "Others".localString, isSelected: self.SKUModel.customMeterial.isSelected)
        self.list.append(model2)
        self.mTableView.reloadData()
    }
}

extension ArtistEditMeterialVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == self.list.count - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistEditMeterialTableViewCell") as! ArtistEditMeterialTableViewCell
            let model = list[indexPath.row]
            cell.selectionStyle = .none
            cell.updateUI(model: model, text: self.SKUModel.customMeterial.title)
            if model.isSelected {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            } else {
                tableView.deselectRow(at: indexPath, animated: false)
            }
            cell.textChange.subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.SKUModel.customMeterial.title = text
            }).disposed(by: cell.disposeBag)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistEditSelecteTableViewCell") as! ArtistEditSelecteTableViewCell
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
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == self.list.count - 1 {
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
        label.text = "Materials Used (Multiple Selections)".localString
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
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
            if indexPath.row == self.list.count - 1 {
                self.SKUModel.customMeterial.isSelected = true
            } else {
                self.SKUModel.meterialIDList.insert(model.id)
            }
        } else {
            if indexPath.row == self.list.count - 1 {
                self.SKUModel.customMeterial.isSelected = false
            } else {
                self.SKUModel.meterialIDList.remove(model.id)
            }
        }
    }

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = list[indexPath.row]
        model.isSelected = !model.isSelected
        if model.isSelected {
            if indexPath.row == self.list.count - 1 {
                self.SKUModel.customMeterial.isSelected = true
            } else {
                self.SKUModel.meterialIDList.insert(model.id)
            }
        } else {
            if indexPath.row == self.list.count - 1 {
                self.SKUModel.customMeterial.isSelected = false
            } else {
                self.SKUModel.meterialIDList.remove(model.id)
            }
        }
    }
}
