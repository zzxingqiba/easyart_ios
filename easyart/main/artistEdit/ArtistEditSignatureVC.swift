//
//  ArtistEditSignatureVC.swift
//  easyart
//
//  Created by Damon on 2025/1/16.
//

import UIKit
import SwiftyJSON

class ArtistEditSignatureVC: BaseVC {

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
        tTableView.backgroundColor = UIColor.clear
        tTableView.separatorStyle = .none
        tTableView.delegate = self
        tTableView.dataSource = self
        tTableView.showsVerticalScrollIndicator = false
        tTableView.register(ArtistEditSelecteTableViewCell.self, forCellReuseIdentifier: "ArtistEditSelecteTableViewCell")
        tTableView.rowHeight = 60
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

extension ArtistEditSignatureVC {
    func _bindView() {
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func _loadData() {
        let model = DDSearchMulFilterModel(id: 0, title: "Yes".localString, isSelected: self.SKUModel.hasSignature)
        let model1 = DDSearchMulFilterModel(id: 0, title: "No".localString, isSelected: !self.SKUModel.hasSignature)
        
        self.list = [model, model1]
        self.mTableView.reloadData()
    }
}

extension ArtistEditSignatureVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
        label.text = "Signature".localString
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

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.SKUModel.hasSignature = indexPath.row == 0
    }
}
