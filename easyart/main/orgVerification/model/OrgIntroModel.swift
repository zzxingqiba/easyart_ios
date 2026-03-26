//
//  Untitled.swift
//  easyart
//
//  Created by 崭新的旧刀 on 2026/3/25.
//

import Foundation
import KakaJSON

class OrgIntroModel {
    var coverFile = OrgFileModel()
    var name: String = ""
    var intro: String = ""
}

extension OrgIntroModel {
    func update(model: UserRoleDetail) {
        self.name = model.name
        self.intro = model.intro
        self.coverFile.fileurl = model.imgUrl.fileurl
        self.coverFile.filename = model.imgUrl.filename
    }
}
