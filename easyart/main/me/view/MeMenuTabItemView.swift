//
//  MeMenuTabItemView.swift
//  easyart
//
//  Created by Damon on 2025/1/7.
//

import UIKit
import RxRelay

class MeMenuTabItemView: DDView {

    let clickPublish = PublishRelay<Void>()
    
    init(title: String) {
        super.init(frame: .zero)
        self.mLabel.text = title
        self._bindView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isSelected = false {
        didSet {
            self.mLine.backgroundColor = isSelected ? ThemeColor.black.color() : ThemeColor.line.color()
            self.mLabel.textColor = isSelected ? ThemeColor.black.color() : ThemeColor.gray.color()
        }
    }
    
    override func createUI() {
        super.createUI()
        self.addSubview(mLabel)
        mLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
        
        self.addSubview(mLine)
        self.mLine.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
    }
    
    //MARK: UI
    lazy var mLabel: PaddingLabel = {
        let label = PaddingLabel(withInsets: 10, 10, 5, 5)
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mLine: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.black.color()
        return view
    }()

}

extension MeMenuTabItemView {
    func _bindView() {
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clickPublish.accept(())
        })
        self.addGestureRecognizer(tap)
    }
}
