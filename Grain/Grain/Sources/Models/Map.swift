//
//  Map.swift
//  Grain
//
//  Created by 조형구 on 2023/01/18.
//

import Foundation

struct Map :Identifiable{
    var id: String?
    var category : Int?
    var latitude : Double
    var longitude : Double
    var magazineId: [String]?
    var url: String
}
