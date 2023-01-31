//
//  GeocodeAPI.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/01.
//

import Foundation

///https://velog.io/@j_aion/iOS-%EB%84%A4%EC%9D%B4%EB%B2%84-%ED%81%B4%EB%A1%9C%EB%B0%94-API-%EC%97%B0%EB%8F%99 <- 참고자료

enum GeocodeAPI {
    case geocode
    
//    var addressQuery: String {
//        switch self {
//        case .geocode: return
//        }
//    }
    var clientHeaderKeyID: String {
        switch self {
        case .geocode: return "X-NCP-APIGW-API-KEY-ID"
        }
    }
    
    var clientHeaderSecretID: String {
        switch self {
        case .geocode: return "X-NCP-APIGW-API-KEY"
        }
    }
    
    
    var clientID: String {
        switch self {
        case .geocode: return "e74pxe65j7"
        }
    }
    var clientSecret: String {
        switch self {
        case .geocode: return "HNFWk0LMeipNl3nYpciGInljCUOzT0tCpPyqQmAa"
        }
    }
    
    var urlString: String {
        switch self {
        case .geocode: return "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=경기도 화성시 석우동 "
        }
    }
}
