//
//  Error.swift
//  Grain
//
//  Created by 박희경 on 2023/02/07.
//

import Foundation


enum HTTPError: Error {
    case invalidInput  
    case networkError
    case requestError
    case uploadImageError
    case unknownError
}
