//
//  QAModel.swift
//  easyart
//
//  Created by Damon on 2024/9/24.
//

import UIKit

class QAModel: BaseModel {
    var title = ""
    var content = ""
    var list = [[String: Any]]()
    
    init(title: String = "", content: String = "") {
        self.title = title
        self.content = content
        super.init()
    }
    
    func addQA(Q: String, A: [String]) {
        self.list.append(["Q": Q, "A": A])
    }
}
