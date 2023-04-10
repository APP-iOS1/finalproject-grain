//
//  CommentRouter.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/10.
//

import Foundation

enum CommentRouter {
    /// docID:  우리가 만들어줄 UUID
    /// collectionName: 콜렉션 이름 ex) Magazine , Community
    /// collectionDocId: 콜렉션 하위 문서ID  ex) Magazine - 1BA19CE5-119C-4898-9EC2-0BB920EAC64D
    case get(collectionName: String, collectionDocId: String)
    case reCommentGet(collectionName: String, collectionDocId: String, commentCollectionName: String,commentCollectionDocId: String)
    case post(collectionName: String, collectionDocId: String, docID: String, commentData: CommentFields )
    case reCommentPost(collectionName: String, collectionDocId: String, commentCollectionName: String,commentCollectionDocId: String, docID: String, commentData: CommentFields)
    case delete(collectionName: String, collectionDocId: String, docID: String)
    case reCommentDelete(collectionName: String, collectionDocId: String, commentCollectionName: String, commentCollectionDocId: String, docID: String)
    case patch(collectionName: String, collectionDocId: String, docID: String, updateComment: String, data: CommentFields )
    case reCommentPatch(collectionName: String, collectionDocId: String, commentCollectionName: String, commentCollectionDocId: String, docID: String, updateComment: String, data: CommentFields)
    
    private var baseURL: URL {
        var baseUrlString : String = "https://"
        if let infolist = Bundle.main.infoDictionary {
            if let url = infolist["FireStore"] as? String {
                baseUrlString += url
            }
        }
        return URL(string: baseUrlString) ?? URL(string: "")!
    }
    
    private var queryItemCommentString: String {
        var commentString : String = ""
        if let infolist = Bundle.main.infoDictionary {
            if let str = infolist["UuidComment"] as? String {
                commentString = str
            }
        }
        return commentString
    }
    private var queryItemRecommentString: String {
        var recommentString : String = ""
        if let infolist = Bundle.main.infoDictionary {
            if let str = infolist["UuidRecomment"] as? String {
                recommentString = str
            }
        }
        return recommentString
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
        case let .get(collectionName, collectionDocId):
            return "/\(collectionName)/\(collectionDocId)/" + "\(queryItemCommentString)"
        case let .reCommentGet(collectionName, collectionDocId, _,commentCollectionDocId):
            return "/\(collectionName)/\(collectionDocId)/" + "\(queryItemCommentString)" + "/" + "\(commentCollectionDocId)/" + "\(queryItemRecommentString)"
        case let .post(collectionName, collectionDocId, _, _):
            return "/\(collectionName)/\(collectionDocId)/" + "\(queryItemCommentString)"
        case let .reCommentPost(collectionName, collectionDocId, _, commentCollectionDocId, _, _):
            return "/\(collectionName)/\(collectionDocId)/" + "\(queryItemCommentString)" + "/" + "\(commentCollectionDocId)" + "/" + "\(queryItemRecommentString)"
        case let .patch(collectionName, collectionDocId, docID, _, _):
            return "/\(collectionName)/\(collectionDocId)/" + "\(queryItemCommentString)" + "/" + "\(docID)"
        case let .reCommentPatch(collectionName, collectionDocId, _, commentCollectionDocId, docID, _, _):
            return "/\(collectionName)/\(collectionDocId)/" + "\(queryItemCommentString)" + "/" + "\(commentCollectionDocId)" + "/" + "\(queryItemRecommentString)" + "/" + "\(docID)"
        case let .delete(collectionName, collectionDocId, docID):
            return "/\(collectionName)/\(collectionDocId)/" + "\(queryItemCommentString)" + "/" + "\(docID)"
        case let .reCommentDelete(collectionName, collectionDocId, _, commentCollectionDocId, docID):
            return "/\(collectionName)/\(collectionDocId)/" + "\(queryItemCommentString)" + "/" + "\(commentCollectionDocId)" + "/" + "\(queryItemRecommentString)" + "/" + "\(docID)"
        default:
            return "/" + "\(queryItemCommentString)"
        }
    }
    var parameters: URLQueryItem? {
        switch self {
        case let .post(_ , _ , docID, _):
            let params: URLQueryItem = URLQueryItem(name: "documentId", value: docID)
            return params
        case let .reCommentPost(_ , _ , _ , _ , docID, _):
            let params: URLQueryItem = URLQueryItem(name: "documentId", value: docID)
            return params
        default :
            let params: URLQueryItem? = nil
            return params
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .get,.reCommentGet:
            return .get
        case .post,.reCommentPost :
            return .post
        case .delete,.reCommentDelete:
            return .delete
        case .reCommentPatch:
            return .patch
        default:
            return .patch
        }
    }
   
    private var data: Data? {
        switch self {
        case let .post(_, _, _, commentData ):
            return CommentQuery.insertCommentQuery(data: commentData)
        case let .reCommentPost( _, _,  _,  _, _ , commentData):
            return CommentQuery.insertRecommentQuery(data: commentData)
        case let .patch(_, _, _, updateComment, data):
            return CommentQuery.updateCommentQuery(updateComment: updateComment, data: data)
        case let .reCommentPatch(_, _, _, _, _, updateComment, data):
            return CommentQuery.updateRecommentQuery(updateComment: updateComment, data: data)
        default:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var component = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        
        if let param = parameters {
            component.queryItems = [param]
        }

        var request = URLRequest(url: component.url!)
        
        request.httpMethod = method.value
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let data = data {
            request.httpBody = data
        }
        
        return request
    }

    
}

