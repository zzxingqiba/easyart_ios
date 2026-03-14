//
//  LogisticsListPopView.swift
//  easyart
//
//  Created by Damon on 2025/6/25.
//

import UIKit
import RxRelay

class LogisticsListPopView: DDView {
    let clickPublish = PublishRelay<DDPopButtonClickInfo>()

    override func createUI() {
        super.createUI()
        self.backgroundColor = UIColor.white
        self.layer.borderColor = ThemeColor.lightGray.color().cgColor
        self.layer.borderWidth = 0.5
        
        self.addSubview(mLogisticsListNameView)
        mLogisticsListNameView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(50)
        }
        mLogisticsListNameView.addSubview(mLogisticsListNameLabel)
        mLogisticsListNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        let imageView = UIImageView(image: UIImage(named: "xiala"))
        mLogisticsListNameView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(8)
            make.height.equalTo(4.5)
        }
        //line
        let line = UIView()
        line.backgroundColor = ThemeColor.lightGray.color()
        mLogisticsListNameView.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.right.equalTo(mLogisticsListNameLabel)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        //顺丰
        self.addSubview(mSFLogisticsListNameLabel)
        mSFLogisticsListNameLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mLogisticsListNameLabel)
            make.top.equalTo(mLogisticsListNameView.snp.bottom)
            make.height.equalTo(mLogisticsListNameView)
        }
        let line2 = UIView()
        line2.backgroundColor = ThemeColor.lightGray.color()
        mSFLogisticsListNameLabel.addSubview(line2)
        line2.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        //德邦
        self.addSubview(mDBLogisticsListNameLabel)
        mDBLogisticsListNameLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mLogisticsListNameLabel)
            make.top.equalTo(mSFLogisticsListNameLabel.snp.bottom)
            make.height.equalTo(mLogisticsListNameView)
        }
        let line3 = UIView()
        line3.backgroundColor = ThemeColor.lightGray.color()
        mDBLogisticsListNameLabel.addSubview(line3)
        line3.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        //德邦
        self.addSubview(mUPSLogisticsListNameLabel)
        mUPSLogisticsListNameLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mLogisticsListNameLabel)
            make.top.equalTo(mDBLogisticsListNameLabel.snp.bottom)
            make.height.equalTo(mLogisticsListNameView)
            make.bottom.equalToSuperview()
        }
        let line4 = UIView()
        line4.backgroundColor = ThemeColor.lightGray.color()
        mUPSLogisticsListNameLabel.addSubview(line4)
        line4.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        self._bindView()
    }
    
    //MARK: UI
    lazy var mLogisticsListNameView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mLogisticsListNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Please select the delivery company".localString
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.lightGray.color()
        return label
    }()
    
    lazy var mSFLogisticsListNameLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.text = "SF".localString
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.lightGray.color()
        return label
    }()
    
    lazy var mDBLogisticsListNameLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.text = "DHL".localString
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.lightGray.color()
        return label
    }()
    
    lazy var mUPSLogisticsListNameLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.text = "UPS".localString
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.lightGray.color()
        return label
    }()
}

extension LogisticsListPopView {
    func _bindView() {
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clickPublish.accept(DDPopButtonClickInfo.init(clickType: .cancel, info: nil))
        })
        self.mLogisticsListNameView.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer()
        _ = tap1.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            //弹窗
            self.clickPublish.accept(DDPopButtonClickInfo.init(clickType: .confirm, info: LogisticsType.shunfeng))
        })
        self.mSFLogisticsListNameLabel.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer()
        _ = tap2.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            //弹窗
            self.clickPublish.accept(DDPopButtonClickInfo.init(clickType: .confirm, info: LogisticsType.debang))
        })
        self.mDBLogisticsListNameLabel.addGestureRecognizer(tap2)
    }
}
