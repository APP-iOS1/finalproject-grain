//
//  ReverseGeocodeService.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/01.
//

import Foundation
import Combine


enum ReverseGeocodeService {
    
    static func getReverseGeocode(latitude: Double, longitude: Double) -> AnyPublisher<ReverseGeocodeDTO, Error> {
        // geocode 쿼리 url
        let queryURL = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=\(longitude),\(latitude)&sourcecrs=epsg:4326&output=json&orders=legalcode"
        
        //MARK: URL의 string:은 영문, 숫자와 특정 문자만 인식 가능하며, 한글, 띄어쓰기 등은 인식하지 못합니다.!!
        // 분명 한글로 요청이 올테니 인코딩
        let encodeQueryURL = queryURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        var request = URLRequest(url: URL(string: encodeQueryURL)!)
        do {
            request = try ReverseGeocodeRouter.get.asURLRequest(latitude: latitude, longitude: longitude)
        } catch {
            print("http error")
        }
        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .map{ $0.data}
            .decode(type: ReverseGeocodeDTO.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
