//
//  Fields.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/18.
//

import Foundation

struct Fields<T: Codable>: Codable {
    var name: String?
    var fields: T
    var createTime: String?
}

struct StringField: Codable {
    var stringValue: String
}

struct IntegerField: Codable {
    var integerValue: String
}
struct DoubleField: Codable {
    var doubleValue: String
}
struct TimestampField: Codable{
    var timestampValue: String
}

struct ArrayField: Codable{
    var ArrayValue: [InnerArray]
}
struct InnerArray: Codable{
    var innerArrayValue: String
    
    private enum CodingKeys: String, CodingKey {
        case innerArrayValue = "values"
    }
    
}
