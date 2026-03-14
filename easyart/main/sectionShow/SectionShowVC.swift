//
//  SectionShowVC.swift
//  easyart
//
//  Created by Damon on 2024/9/18.
//

import UIKit

class SectionShowVC: BaseVC {
    var model: SectionShowModel
    
    init(model: SectionShowModel) {
        self.model = model
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._loadData()
    }
    
    override func createUI() {
        super.createUI()
        
        self.mSafeView.addSubview(mBanner)
        mBanner.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.mSafeView.addSubview(mImageView)
        mImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.width.equalTo(0)
            make.height.equalTo(0)
            
        }
    }
    
    //MARK: UI
    lazy var mBanner: DDSwiperView = {
        let view = DDSwiperView()
        return view
    }()

    lazy var mImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        view.layer.shadowColor = UIColor.black.cgColor      // 阴影颜色
        view.layer.shadowOpacity = 0.5                     // 阴影透明度
        view.layer.shadowOffset = CGSize(width: 2, height: 2) // 阴影偏移
        view.layer.shadowRadius = 3
        return view
    }()
}

extension SectionShowVC {
    func _loadData() {
        let config = DDServerConfigTools.shared.configInfo.value
        //动态加载图片
        var top: Float = 0
        var imgW: Float = 0
        var imgH: Float = 0
        print(model.width, model.length)
        if model.width < 140 {
            let bgRate: Float = 750 / 180 / 2
            top = 160
            imgW = model.length * bgRate
            imgH = model.width / model.length * imgW
            let images = config["decorate_list2"]["min"].arrayValue
            self.mBanner.updateUI(list: images.map({ json in
                return json.stringValue
            }))
        } else if model.width < 320 {
            let bgRate: Float = 750 / 500 / 2
            top = 320
            imgW = min(model.length, 125) * bgRate
            imgH = model.width / model.length * imgW
            let images = config["decorate_list2"]["medium"].arrayValue
            self.mBanner.updateUI(list: images.map({ json in
                return json.stringValue
            }))
        } else {
            let bgRate: Float = 750 / 1250 / 2
            top = 320
            imgW = min(model.length, 150) * bgRate
            imgH = model.width / model.length * imgW
            let images = config["decorate_list2"]["max"].arrayValue
            self.mBanner.updateUI(list: images.map({ json in
                return json.stringValue
            }))
        }
        
        mImageView.kf.setImage(with: URL(string: model.imgURL))
        mImageView.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(top)
            make.width.equalTo(imgW)
            make.height.equalTo(imgH)
        }
    }
}
