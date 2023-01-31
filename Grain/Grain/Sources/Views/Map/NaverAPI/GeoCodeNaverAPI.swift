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

/// 스토리지 값 가져오기 초기 코드
//func networkTest(){
//    let firebaseStorageURL = "https://firebasestorage.googleapis.com/v0/b/grain-final.appspot.com/o"
//    URLSession.shared.dataTask(with: URL(string: firebaseStorageURL)!) { (data, _, error) in
//        guard let data = data, error == nil else{
//            fatalError("error")
//        }
//        let response = try? JSONDecoder().decode(StorageResponse.self, from: data)
//        if let response = response{
//            print(response.items[0].name)
//        }
//    }.resume()
//
//}

///  
//func networkTest(){
//    let firebaseStorageURL = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents/Map"
//    URLSession.shared.dataTask(with: URL(string: firebaseStorageURL)!) { (data, _, error) in
//        guard let data = data, error == nil else{
//            fatalError("error")
//        }
//        let response = try? JSONDecoder().decode(Test333.self, from: data)
//        if let response = response{
//            print(response.documents[0].fields.magazineID.arrayValue.values[0].stringValue)
//        }
//    }.resume()
//
//}
//
//  TestDTO.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/31.
//

//import Foundation
//  맵 배열
//// MARK: - Test333
//struct Test333: Codable {
//    let documents: [Document]
//}
//
//// MARK: - Document
//struct Document: Codable {
//    let name: String
//    let fields: TestFields
//    let createTime, updateTime: String
//}
//
//// MARK: - Fields
//struct TestFields: Codable {
//    let category: TestCategory
//    let magazineID: TestMagazineID
//    let id: ID
//    let latitude: Itude
//    let url: ID
//    let longitude: Itude
//
//    enum CodingKeys: String, CodingKey {
//        case category
//        case magazineID = "magazineId"
//        case id, latitude, url, longitude
//    }
//}
//
//// MARK: - Category
//struct TestCategory: Codable {
//    let integerValue: String
//}
//
//// MARK: - ID
//struct ID: Codable {
//    let stringValue: String
//}
//
//// MARK: - Itude
//struct Itude: Codable {
//    let doubleValue: Double
//}
//
//// MARK: - MagazineID
//struct TestMagazineID: Codable {
//    let arrayValue: TestArrayValue
//}
//
//// MARK: - ArrayValue
//struct TestArrayValue: Codable {
//    let values: [ID]
//}
