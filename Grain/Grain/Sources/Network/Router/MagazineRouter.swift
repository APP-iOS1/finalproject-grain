//
//  MagazineRouter.swift
//  Grain
//
//  Created by 박희경 on 2023/01/20.
//

import Foundation


enum MagazineRouter {

    case get
    case post(userID: String, cameraInfo: String, nickName: String, image: String, content: String, title: String,lenseInfo:String,longitude: Double,likedNum: Int,filmInfo: String, customPlaceName: String,latitude: Double,comment: String,roadAddress: String )
    case delete
    case put
    case patch
    
    private var baseURL: URL {
        let baseUrlString = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents"
    
        return URL(string: baseUrlString)!
    }
    
    private enum HTTPMethod {
            case get
            case post
            case patch
            case delete
            
            var value: String {
                switch self {
                case .get: return "GET"
                case .post: return "POST"
                case .patch: return "PATCH"
                case .delete: return "DELETE"
                }
            }
        }
    
    private var endPoint: String {
        switch self {
        default:
            return "/Magazine"
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .get :
            return .get
        case .post :
            return .post
        case .delete:
            return .delete
        case .patch:
            return .patch
        default:
            return .get
        }
    }
   
    private var data: Data? {
        switch self {
        case let .post(userID, cameraInfo, nickName, image, content, title, lenseInfo, longitude, likedNum, filmInfo, customPlaceName, latitude, comment, roadAddress):
            return MagazineQuery.insertMagazineQuery(userID: userID, cameraInfo: cameraInfo, nickName: nickName, image: image, content: content, title: title,lenseInfo:lenseInfo,longitude: longitude,likedNum: likedNum,filmInfo: filmInfo, customPlaceName: customPlaceName,latitude: latitude,comment: comment,roadAddress: roadAddress)
        default:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method.value
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let data = data {
            request.httpBody = data
        }
        
        // [x] TODO: Encoding 하는 방식으로 data 넘겨주기
//        request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
        return request
    }

    
    // MARK: 실험 코드
    func asURLPatch(token: String) throws -> URLRequest {
        let url = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents" + "/Magazine/\(token)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method.value
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let data = data {
            request.httpBody = data
        }
        return request
    }
    
    func asURLUpdate(token: String,updateMagazineData : MagazineDocument) throws -> URLRequest {
        let url = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents" + "/Magazine/\(token)"
                
        var request = URLRequest(url: URL(string: url)!)
        ///switch? 이거를 써야 하나?
        request.httpMethod = method.value
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = """
                {
                    "fields": {
                                "longitude": {
                                    "integerValue": \(updateMagazineData.fields.longitude.doubleValue)
                                },
                                "likedNum": {
                                    "integerValue": \(updateMagazineData.fields.likedNum)
                                },
                                "nickName": {
                                    "stringValue": "\(updateMagazineData.fields.likedNum.integerValue)"
                                },
                                "cameraInfo": {
                                    "stringValue": "\(updateMagazineData.fields.cameraInfo.stringValue)"
                                },
                                "latitude": {
                                    "integerValue": \(updateMagazineData.fields.latitude.doubleValue)
                                },
                                "title": {
                                    "stringValue": "\(updateMagazineData.fields.title.stringValue)"
                                },
                                "image": {
                                    "arrayValue": {
                                        "values": [
                                            {
                                                "stringValue":  "image"
                                            }
                                        ]
                                    }
                                },
                                "filmInfo": {
                                    "stringValue": "\(updateMagazineData.fields.filmInfo.stringValue)"
                                },
                                "customPlaceName": {
                                    "stringValue": "\(updateMagazineData.fields.customPlaceName.stringValue)"
                                },
                                "content": {
                                    "stringValue": "\(updateMagazineData.fields.content.stringValue)"
                                },
                                "userID": {
                                    "stringValue": "\(updateMagazineData.fields.userID.stringValue)"
                                },
                                "lenseInfo": {
                                    "stringValue": "\(updateMagazineData.fields.lenseInfo.stringValue)"
                                },
                                "comment": {
                                    "arrayValue": {
                                        "values": [
                                            {
                                                "stringValue": "\(updateMagazineData.fields.comment)"
                                            }
                                        ]
                                    }
                                },
                                "id": {
                                    "stringValue":  "id패스"
                                },
                                "roadAddress": {
                                    "stringValue": "\(updateMagazineData.fields.roadAddress.stringValue)"
                                }
                            }
                    }
                """.data(using: .utf8)
        
        
        if let data = data {
            request.httpBody = data
        }
        return request
    }
}

