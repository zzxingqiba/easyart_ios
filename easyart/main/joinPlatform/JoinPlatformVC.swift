//
//  JoinPlatformVC.swift
//  easyart
//
//  Created by 崭新的旧刀 on 2026/3/23.
//

import RxRelay
import SnapKit
import UIKit

class JoinPlatformVC: BaseVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
    }

    init() {
        super.init(bottomPadding: 0)
    }

    @available(*, unavailable)
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createUI() {
        super.createUI()
        self.mSafeView.addSubview(self.mJoinPlatformArtist)
        self.mJoinPlatformArtist.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }

        self.mSafeView.addSubview(self.mJoinPlatformOrg)
        self.mJoinPlatformOrg.snp.makeConstraints { make in
            make.top.equalTo(self.mJoinPlatformArtist.snp.bottom)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }

    // MARK: UI

    lazy var mJoinPlatformArtist: JoinPlatformArtist = .init()
    lazy var mJoinPlatformOrg: JoinPlatformOrg = .init()
}

extension JoinPlatformVC {
    func _bindView() {
        _ = self.mJoinPlatformArtist.clickPublish.subscribe(onNext: {
            [weak self] _ in
            guard let self = self else { return }
            let vc = SettleInVC(bottomPadding: 100)
            self.navigationController?.pushViewController(vc, animated: true)
        })
        _ = self.mJoinPlatformOrg.clickPublish.subscribe(onNext: {
            [weak self] _ in
            guard let self = self else { return }
            let vc = OrgVerifVC(bottomPadding: 100)
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
}
