//
//  DDArtistSearchModel.swift
//  easyart
//
//  Created by Damon on 2024/11/21.
//

import UIKit
import KakaJSON

class DDArtistSearchModel: NSObject {
    required override init() {}
    
    var id: Int = 0
    var face_url: String = ""
    var name: String = ""
    var country_name: String = ""
}

extension DDArtistSearchModel: Convertible {
  
}
