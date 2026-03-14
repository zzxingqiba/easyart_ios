//
//  ArtistSortVC.swift
//  easyart
//
//  Created by Damon on 2025/2/27.
//

import UIKit
import SwiftyJSON

class ArtistSortVC: BaseVC {
    private var list = [MeArtistModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
        self._loadData()
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.addSubview(mTableView)
        mTableView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(-10)
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(BottomSafeAreaHeight + 50)
        }
        
        self.mSafeView.addSubview(mConfirmButton)
        mConfirmButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(BottomSafeAreaHeight + 50)
        }
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
        tTableView.register(ArtistSortVCTableViewCell.self, forCellReuseIdentifier: "ArtistSortVCTableViewCell")
        tTableView.rowHeight = 80
        tTableView.isEditing = true
        return tTableView
    }()
    
    lazy var mConfirmButton: UIButton = {
            let tButton = UIButton(type: .custom)
            tButton.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.black.color()), for: .normal)
            tButton.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.gray.color()), for: .disabled)
            tButton.titleLabel?.font = .systemFont(ofSize: 14)
            tButton.setTitleColor(UIColor.dd.color(hexValue: 0xffffff), for: .normal)
            tButton.setTitle("Save".localString, for: .normal)
            return tButton
        }()
}

extension ArtistSortVC {
    func _bindView() {
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self._saveData()
        })
    }
    
    func _loadData() {
        _ = DDAPI.shared.request("settled/goodsList", data: ["page_type": 1], autoShowError: false).subscribe(onSuccess: {  [weak self] response in
            guard let self = self else { return }
            let data = JSON(response.data)
            let goodsList = (data["goods_list"].arrayObject as? [[String: Any]]) ?? []
            self.list =  goodsList.kj.modelArray(MeArtistModel.self)
            self.mTableView.reloadData()
        })
    }
    
    func _saveData() {
        let sortId = self.list.map { model in
            return "\(model.id)"
        }
        _ = DDAPI.shared.request("settled/artistSortGoods", data: ["artist_id": DDUserTools.shared.userInfo.value.role.id, "sortId": sortId.joined(separator: ",")]).subscribe(onSuccess: {  [weak self] response in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        })
    }
}

extension ArtistSortVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistSortVCTableViewCell") as! ArtistSortVCTableViewCell
        let model = list[indexPath.row]
        cell.selectionStyle = .none
        cell.updateUI(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedItem = self.list.remove(at: sourceIndexPath.row) // 移除拖拽的元素
        self.list.insert(movedItem, at: destinationIndexPath.row) // 插入到目标位置
    }

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
