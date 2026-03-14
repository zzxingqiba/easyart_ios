//
//  ArtistEditImageView.swift
//  easyart
//
//  Created by Damon on 2025/1/8.
//

import UIKit
import RxRelay

class ArtistEditImageView: DDView {
    let clickPublish = PublishRelay<Void>()
    
    override func createUI() {
        super.createUI()
        self.addSubview(mImageView)
        mImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(mAddImageView)
        mAddImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(11)
        }
        
        self._bindView()
    }
    
    func updateUI(imgUrl: String) {
        self.mAddImageView.isHidden = true
        self.mImageView.kf.setImage(with: URL(string: imgUrl))
    }

    //MARK: UI
    lazy var mImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.kf.indicatorType = .activity
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.dd.color(hexValue: 0xe6e6e6e).cgColor
        imageView.layer.borderWidth = 0.5
        return imageView
    }()
    
    lazy var mAddImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "me_add"))
        return imageView
    }()

}

extension ArtistEditImageView {
    func _bindView() {
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clickPublish.accept(())
        })
        self.addGestureRecognizer(tap)
    }
}
