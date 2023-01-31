//
//  GeocodeRouter.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/01.
//

import Foundation


enum GeocodeRouter {

    case get
    
    private var baseURL: URL {
        let baseUrlString = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query="    // = 주소를 붙이면 에러뜸
        
        return URL(string: baseUrlString)!
    }
    
    private enum HTTPMethod {
            case get
        
            var value: String {
                switch self {
                case .get: return "GET"
                }
            }
        }
    
    private var method: HTTPMethod {
        switch self {
        case .get :
            return .get
        default:
            return .get
        }
    }
   
    
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL
//FIXME: URL의 string:은 영문, 숫자와 특정 문자만 인식 가능하며, 한글, 띄어쓰기 등은 인식하지 못합니다.
        var request = URLRequest(url: url)
        request.setValue(GeocodeAPI.geocode.clientID, forHTTPHeaderField: GeocodeAPI.geocode.clientHeaderKeyID)
        request.setValue(GeocodeAPI.geocode.clientSecret, forHTTPHeaderField: GeocodeAPI.geocode.clientHeaderSecretID)
        request.httpMethod = method.value
        
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
}
