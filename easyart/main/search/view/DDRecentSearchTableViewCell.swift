//
//  DDRecentSearchTableViewCell.swift
//  easyart
//
//  Created by Damon on 2024/11/21.
//

import UIKit
import RxRelay

class DDRecentSearchTableViewCell: DDTableViewCell {
    let deleteClickPublish = PublishRelay<Void>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func createUI() {
        super.createUI()
        self.contentView.addSubview(mImageView)
        mImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.height.equalTo(45)
        }
        
        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(mImageView.snp.right).offset(17)
            make.bottom.equalTo(mImageView.snp.centerY).offset(-2)
        }
        self.contentView.addSubview(mDesLabel)
        mDesLabel.snp.makeConstraints { make in
            make.left.equalTo(mTitleLabel)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(2)
        }
        self.contentView.addSubview(mArrowImageView)
        mArrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(12)
            make.height.equalTo(12)
        }
        self._bindView()
    }
    
    func updateUI(model: DDRecentSearchModel) {
        mImageView.kf.setImage(with: URL(string: model.image))
        mTitleLabel.text = model.title
        mDesLabel.text = model.des
    }

    //
    lazy var mImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mDesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mArrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon-close-black"))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
}

private extension DDRecentSearchTableViewCell {
    func _bindView() {
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.deleteClickPublish.accept(())
        })
        mArrowImageView.addGestureRecognizer(tap)
    }
}
