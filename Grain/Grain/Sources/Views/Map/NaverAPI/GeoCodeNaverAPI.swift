//
//  GeoCodeNaverAPI.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/29.
//

//import Foundation
//import Combine
//
//
//
//enum GeoCodeNaverAPIService {
//
//    private enum HTTPMethod: String {
//        case get = "GET"
//        case post = "POST"
//        case patch = "PATCH"
//    }
//     MARK: - 매거진 데이터 가져오기
//    static func getNaverAPI() -> AnyPublisher<MagazineResponse, Error> {
//        let NAVER_REVERSE_GEOCODE_URL = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query="
//        let searchText = "경기도 화성시 석우동"
//
//         알라모 파이어 -> URL Session 방법 찾기
//        let header1 = HTTPHeader(name: "X-NCP-APIGW-API-KEY-ID", value: "e74pxe65j7")
//        let header2 = HTTPHeader(name: "X-NCP-APIGW-API-KEY", value: "HNFWk0LMeipNl3nYpciGInljCUOzT0tCpPyqQmAa")
//        let headers = HTTPHeaders([header1,header2])
//         FIXME: 확인 필요  -> firestoreURL)!)
//        AF.request(NAVER_REVERSE_GEOCODE_URL + searchText, method: .get,headers: headers).validate()
//
//         만들어진 값을 firestoreURL 자리에 넣어주기
//        var request = URLRequest(url: URL(string: firestoreURL)!)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = HTTPMethod.get.rawValue
//
//
//         리턴 값으로 decode해주고 가져오면 끝
//        return URLSession
//            .shared
//            .dataTaskPublisher(for: request)
//            .map{ $0.data}
//            .decode(type: MagazineResponse.self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
//        return
//    }
//
//
//}


//AF.request(NAVER_GEOCODE_URL + encodeAddress, method: .get,headers: headers).validate()


// 전략
/// 동적 URL 생성 URL
/// encodeAddress 값을 바인딩 받아야됨
/// 메서드 방식을 헤더로
/// 헤더에 내 네이버API 제공 값 넘기기
/// response 핸들링하고 -> "도로명 주소, 경도위도" 값 뽑기
/// 뽑은 도로명 주소, 경도 위도 값 위로 바인딩해서 넘기기
/// 받은 경도 위도 값으로 카메라 위치 이동 지도 이동시키기
///  그럼 끝
