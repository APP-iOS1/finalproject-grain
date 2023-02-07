//
//  GeocodeService.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/01.
//

import Combine
import Foundation


enum GeocodeService {
    
    static func getGeocode(requestAddress: String) -> AnyPublisher<GeocodeDTO, Error> {
        // geocode 쿼리 url
        let queryURL = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=\(requestAddress)"
        
        //MARK: URL의 string:은 영문, 숫자와 특정 문자만 인식 가능하며, 한글, 띄어쓰기 등은 인식하지 못합니다.!!
        // 분명 한글로 요청이 올테니 인코딩
        let encodeQueryURL = queryURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        var request = URLRequest(url: URL(string: encodeQueryURL)!)
        do {
            request = try GeocodeRouter.get.asURLRequest(requestAddress: requestAddress)
        } catch {
            print("http error")
        }
        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .map{ $0.data}
            .decode(type: GeocodeDTO.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
