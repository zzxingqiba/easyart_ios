//
//  ArtistEditImageListView.swift
//  easyart
//
//  Created by Damon on 2025/1/9.
//

import UIKit
import RxRelay

class ArtistEditImageListView: DDView {
    let clickSubject = PublishRelay<Int>()
    
    var images: [String] = []
    
    override func createUI() {
        super.createUI()
        self.addSubview(mStackView)
        mStackView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.height.equalTo(35)
        }
    }

    //MARK: UI
    lazy var mStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
}

extension ArtistEditImageListView {
    func updateImages(images: [String]) {
        for view in mStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        let count = min(5, images.count + 1)
        
        for i in 0..<count {
            let imageView = ArtistEditImageView()
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(35)
            }
            _ = imageView.clickPublish.subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.clickSubject.accept(i)
            })
            if i < images.count {
                imageView.updateUI(imgUrl: images[i])
            }
            self.mStackView.addArrangedSubview(imageView)
        }
        
    }
}
