//
//  MessageTypeTabView.swift
//  easyart
//
//  Created by Damon on 2025/6/20.
//

import UIKit
import RxRelay

class MessageTypeTabView: DDView {
    let indexChange = PublishRelay<Int>()
    var selectedIndex: Int = 0 {
        didSet {
            self.mFollowItemView.isSelected = selectedIndex == 0
            self.mNotificationItemView.isSelected = selectedIndex == 1
            self.indexChange.accept(self.selectedIndex)
        }
    }
    override func createUI() {
        super.createUI()
        self.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        self.addSubview(mFollowItemView)
        mFollowItemView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalTo(self.snp.centerX)
        }
        mFollowItemView.addSubview(mFollowRedIcon)
        mFollowRedIcon.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-50)
            make.top.equalToSuperview().offset(10)
            make.width.height.equalTo(6)
        }
        
        self.addSubview(mNotificationItemView)
        mNotificationItemView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalTo(self.snp.centerX)
        }
        mNotificationItemView.addSubview(mNotificationRedIcon)
        mNotificationRedIcon.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-50)
            make.top.equalToSuperview().offset(10)
            make.width.height.equalTo(6)
        }
        
        self._bindView()
    }
    
    //MARK: UI
    lazy var mFollowItemView: DDOrderTypeTabItemView = {
        let view = DDOrderTypeTabItemView(title: "Follow")
        view.mLabel.textAlignment = .center
        view.mLine.backgroundColor = ThemeColor.black.color()
        return view
    }()
    
    lazy var mFollowRedIcon: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.dd.color(hexValue: 0x1053FF)
        view.layer.cornerRadius = 3
        return view
    }()
    
    lazy var mNotificationItemView: DDOrderTypeTabItemView = {
        let view = DDOrderTypeTabItemView(title: "Notification")
        view.mLabel.textAlignment = .center
        view.mLine.backgroundColor = ThemeColor.black.color()
        return view
    }()
    
    lazy var mNotificationRedIcon: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.dd.color(hexValue: 0xF50045)
        view.layer.cornerRadius = 3
        return view
    }()
}

extension MessageTypeTabView {
    func _bindView() {
        _ = DDUserTools.shared.userInfo.subscribe(onNext: { [weak self] userModel in
            guard let self = self else { return }
            self.mFollowRedIcon.isHidden = !userModel.new_follow_msg
            self.mNotificationRedIcon.isHidden = !userModel.new_sys_msg
        })
        
        _ = self.mFollowItemView.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.selectedIndex = 0
        })
        
        _ = self.mNotificationItemView.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.selectedIndex = 1
        })
    }
}
