//
//  MagazineService.swift
//  Grain
//
//  Created by 박희경 on 2023/01/20.
//

import Foundation
import Combine
import UIKit

enum MagazineService {
    
    // MARK: - 매거진 데이터 가져오기
    static func getMagazine() -> AnyPublisher<MagazineResponse, Error> {
        print("FirebaseServic getMagazine start")
        
        do {
            let request = try MagazineRouter.get.asURLRequest()
            return URLSession
                .shared
                .dataTaskPublisher(for: request)
                .map{ $0.data}
                .decode(type: MagazineResponse.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: HTTPError.requestError).eraseToAnyPublisher()
        }
    }
    
    // MARK: - 매거진 데이터 넣기
    static func insertMagazine(userID: String, cameraInfo: String, nickName: String, image: [UIImage], content: String, title: String, lenseInfo:String, longitude: Double, likedNum: Int, filmInfo: String, customPlaceName: String, latitude: Double, comment: String, roadAddress: String ) -> AnyPublisher<MagazineDocument, Error> {
        print("FirebaseServic insertMagazine start")
        
        // 1. 스토리지 라우터에 있는 uploadImage 메소드를 호출해서 여기서 urlArr 를 받는다.
        // 2. 스토리지에 이미지들이 업로드가 된다.
        // 3. 리팩토링 - 라우터에 있는 uploadimage코드를  service, vm로 옮겨야한다.
        var imageUrlArr: [String] = StorageRouter.returnImageRequests(paramName: "1", fileName: "1", image: image)
        print("makeURL: \(imageUrlArr)")
        
        // 여기서 이미지 들어가게 하고 , 그담 이미지 리퀘스트 받아서 url 만들고 저장해서
        // 요기 밑에 지금 오류나는 image 부분에 넣어줘야한다.
        
        let requestRouter = MagazineRouter.post(userID: userID, cameraInfo: cameraInfo, nickName: nickName, image: imageUrlArr, content: content, title: title, lenseInfo: lenseInfo, longitude: longitude, likedNum: likedNum, filmInfo: filmInfo, customPlaceName: customPlaceName, latitude: latitude, comment: comment, roadAddress: roadAddress)
        
        var request: URLRequest =  URLRequest(url: URL(string: "dfsfsdfd")!)
        
        do {
            request = try requestRouter.asURLRequest()
            return URLSession
                .shared
                .dataTaskPublisher(for: request)
                .map{ $0.data }
                .decode(type: MagazineDocument.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: HTTPError.requestError).eraseToAnyPublisher()
            
        }
        
    }
    
    static func updateMagazine(data: MagazineDocument, docID: String) -> AnyPublisher<MagazineDocument, Error> {
    
        print("id: \(docID), MagazineService update method")
        
        do {
            let suffixedId: String = String(docID.suffix(20))
            let request = try MagazineRouter.patch(putData: data, docID: suffixedId).asURLRequest()
            print(request)
            return URLSession
                .shared
                .dataTaskPublisher(for: request)
                .map{ $0.data }
                .decode(type: MagazineDocument.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            // [x] error handling
            return Fail(error: HTTPError.requestError).eraseToAnyPublisher()
        }
        
    }
}
