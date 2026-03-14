//
//  DDSearchMulFilterModel.swift
//  easyart
//
//  Created by Damon on 2024/11/25.
//

import Foundation

class DDSearchMulFilterModel {
    var id: Int
    var title: String
    var attributed: NSAttributedString? = nil
    var isSelected: Bool
    
    init(id: Int, title: String, isSelected: Bool) {
        self.id = id
        self.title = title
        self.isSelected = isSelected
    }
}
