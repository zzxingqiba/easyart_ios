//
//  DDPackageViewController.swift
//  easyart
//
//  Created by Damon on 2024/11/5.
//

import UIKit
import SwiftyJSON

class DDPackageViewController: BaseVC {
    var model: SectionShowModel
    private var viewModel: DDPackageViewModel
    
    init(model: SectionShowModel, viewModel: DDPackageViewModel) {
        self.model = model
        self.viewModel = viewModel
        super.init(bottomPadding: 150)
        self.viewModel.width = model.width
        self.viewModel.height = model.length
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._loadData()
        self._bindView()
    }

    override func createUI() {
        super.createUI()
        self.mSafeView.contentType = .flex
        
        self.view.addSubview(mPreviewView)
        mPreviewView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(360)
        }
        
        self.mSafeView.addSubview(mPackageContentView)
        mPackageContentView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(380)
        }
        
        self.view.addSubview(mPackageBottomView)
        mPackageBottomView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(50 + BottomSafeAreaHeight)
        }
    }
    
    //MARK: UI
    lazy var mPreviewView: DDPreviewView = {
        let view = DDPreviewView(viewModel: self.viewModel)
        return view
    }()
    
    lazy var mPackageContentView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var mPackageBottomView: DDPackageBottomView = {
        let view = DDPackageBottomView(viewModel: self.viewModel)
        return view
    }()
}

extension DDPackageViewController {
    func _loadData() {
        if model.width > 0 && model.length > 0 {
            self.mPreviewView.updateImageSize(size: CGSize(width: CGFloat(model.length), height: CGFloat(model.width)))
        }
        self.mPreviewView.mPreviewImageView.kf.setImage(with: URL(string: model.imgURL))
    }
    
    func _bindView() {
        _ = self.viewModel.packageConfigList.subscribe(onNext: { [weak self] list in
            guard let self = self else { return }
            self._updateUI(list: list)
        })
        
        _ = self.viewModel.packageIndex.subscribe(onNext: { [weak self]  index in
            guard let self = self else { return }
            for i in 0..<self.mPackageContentView.subviews.count {
                if let view = self.mPackageContentView.subviews[i] as? DDXylonPreviewContractView {
                    view.reset()
                }
            }
        })
        
        _ = self.mPackageBottomView.clickPublish.subscribe(onNext: { [weak self] clickInfo in
            guard let self = self else { return }
            if clickInfo.clickType == .confirm {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.viewModel.packageIndex.accept(nil)
            }
        })
        
    }
    
    func _updateUI(list: [JSON]) {
        for view in self.mPackageContentView.subviews {
            view.removeFromSuperview()
        }
        var posView: UIView?
        for i in 0..<list.count {
            let view = DDXylonPreviewContractView(viewModel: self.viewModel)
            if let packageIndex = self.viewModel.packageIndex.value, packageIndex == i {
                view.isExpand = true
            } else if i == 0 {
                view.isExpand = true
            }
            self.mPackageContentView.addSubview(view)
            view.updateUI(packageIndex: i)
            view.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                if let posView = posView {
                    make.top.equalTo(posView.snp.bottom).offset(20)
                } else {
                    make.top.equalToSuperview()
                }
                if i == list.count - 1 {
                    make.bottom.equalToSuperview()
                }
            }
            posView = view
        }
        
    }
}
