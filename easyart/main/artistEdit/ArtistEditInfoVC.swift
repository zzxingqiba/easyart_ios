//
//  ArtistEditInfoVC.swift
//  easyart
//
//  Created by Damon on 2025/1/16.
//

import UIKit

class ArtistEditInfoVC: BaseVC {
    private var editModel: ArtistEditModel
    init(editModel: ArtistEditModel) {
        self.editModel = editModel
        super.init()
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._reloadData()
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.contentType = .flex
        
        self.mSafeView.addSubview(mIntroTitleLabel)
        mIntroTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalToSuperview().offset(30)
        }
        
        self.mSafeView.addSubview(mNumberLabel)
        mNumberLabel.snp.makeConstraints { make in
            make.right.equalTo(mIntroTitleLabel)
            make.centerY.equalTo(mIntroTitleLabel)
        }
        
        self.mSafeView.addSubview(mUnderlinedTextView)
        mUnderlinedTextView.snp.makeConstraints { make in
            make.left.right.equalTo(mIntroTitleLabel)
            make.top.equalTo(mIntroTitleLabel.snp.bottom).offset(10)
            make.height.equalTo(500)
        }
        
        self.view.addSubview(mConfirmButton)
        mConfirmButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50 + BottomSafeAreaHeight)
        }
    }
    
    //MARK: UI
    lazy var mIntroTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Work Description".localString + " (Optional)".localString
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mNumberLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "0/2000"
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mUnderlinedTextView: UnderlinedTextView = {
        let view = UnderlinedTextView()
        view.font = .systemFont(ofSize: 14)
        view.textColor = ThemeColor.black.color()
        view.text = " Please enter"
        return view
    }()
    
    lazy var mConfirmButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.black.color()), for: .normal)
        tButton.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.gray.color()), for: .disabled)
        tButton.titleLabel?.font = .systemFont(ofSize: 14)
        tButton.setTitleColor(UIColor.dd.color(hexValue: 0xffffff), for: .normal)
        tButton.setTitle("Submit".localString, for: .normal)
        tButton.isEnabled = false
        return tButton
    }()

}

extension ArtistEditInfoVC {
    func _bindView() {
        _ = self.mUnderlinedTextView.rx.observe(CGSize.self, "contentSize").subscribe(onNext: { [weak self] (contentSize) in
            guard let self = self, let contentSize = contentSize else { return }
                self.mUnderlinedTextView.snp.updateConstraints { (make) in
                    make.height.equalTo(max(500, contentSize.height))
                }
        })
        
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            //简介
            self._saveSettled()
        })
        
        
        
        _ = self.mUnderlinedTextView.rx.didEndEditing.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.editModel.intro = self.mUnderlinedTextView.text.dd.subString(rang: NSRange(location: 0, length: 2000))
            self.mNumberLabel.text = "\(self.editModel.intro.count)/2000"
            self._updateButton()
        })
        
       
    }
    
    func _reloadData() {
        self.mUnderlinedTextView.text = self.editModel.intro
        self.mNumberLabel.text = "\(self.editModel.intro.count)/2000"
        self._updateButton()
    }
    
    func _updateButton() {
        self.mConfirmButton.isEnabled = String.isAvailable(self.editModel.intro)
    }
    
    
    func _saveSettled() {
        self.navigationController?.popViewController(animated: true)
    }
}
