//
//  SettleInAuthorModel.swift
//  easyart
//
//  Created by Damon on 2024/12/18.
//
import Foundation
import KakaJSON

class SettleInAuthorModel {
    var coverFile = SettleInFileModel()
    var name: String = ""
    var intro: String = ""
}

extension SettleInAuthorModel {
    func update(model: UserRoleDetail) {
        self.name = model.name
        self.intro = model.intro
        self.coverFile.fileurl = model.imgUrl.fileurl
        self.coverFile.filename = model.imgUrl.filename
    }
}
