//
//  CommunityStore.swift
//  Grain
//
//  Created by 조형구 on 2023/01/18.
//

import Foundation
import SwiftUI
//import FirebaseStorage    /// PodFile - Firebase SDK 제거 -> 필요시 사용하기  ( 2022.02.22 / 정훈 )
//import FirebaseFirestore  /// PodFile - Firebase SDK 제거 -> 필요시 사용하기  ( 2022.02.22 / 정훈 )


class CommunityStore: ObservableObject {
    @Published var communities: [Community] = []
    @Published var images: [UIImage] = []
    
//    let database = Firestore.firestore()
//    let storage = Storage.storage()
//
//    init() {
//        communities = []
//    }
    
    /// PodFile - Firebase SDK 제거 -> 필요시 사용하기  ( 2022.02.22 / 정훈 )
    // FIXME - 불필요한 코드 검토 바람!
    // MARK: - 다이어리 데이터 가져오기 메소드
//    func fetchCommunities() {
//        database.collection("Community")
//            .getDocuments { (snapshot, error) in
//                self.communities.removeAll()
//
//                if let snapshot {
//                    for document in snapshot.documents {
//
//                        let docData = document.data()
//
//                        let id: String = docData["id"] as? String ?? ""
//                        let category: Int = docData["category"] as? Int ?? 0
//                        let userID: String = docData["userID"] as? String ?? ""
//                        let image: [String] = docData["image"] as? [String] ?? []
//                        let title: String = docData["title"] as? String ?? ""
//                        let profileImage: String = docData["profileImage"] as? String ?? ""
//                        let nickName: String = docData["nickName"] as? String ?? ""
//                        let location: String = docData["location"] as? String ?? ""
//                        let content: String = docData["content"] as? String ?? ""
//                        let createdAt: Timestamp = docData["createdAt"] as! Timestamp
//
//                        let community: Community = Community(id: id, category: category, userID: userID, image: image, title: title, profileImage: profileImage, nickName: nickName, location: location, content: content, createdAt: createdAt.dateValue())
//
//                        self.communities.append(community)
//                    }
//                }
//            }
//    }
    
    //    // MARK: - 스토리지에서 이미지 가져오는 메소드
    //    @MainActor // 메인 스레드에서 실행
    //    // throws + do-catch
    //    func fetchImages(_ diary: Diary) async -> [UIImage] {
    //        // @escaping 클로져를 리턴하는 방법 vs async/await로 배열을 리턴하는 방법 ?
    //        // 결론: for문에서 한번 돌 때 클로져 리턴후 함수가 끝나기 때문에 다중이미지에서는 전자로는 불가능
    //        var diaryImage: [UIImage] = []
    //
    //        // await를 뱉는 listAll 가 있고, 아닌 listAll 있음.
    //        // listAll(_, completion: ) -> try await listAll()
    //
    //        // try await (do catch)
    //        // do 가 do 안에 있는 모든 에러들을 잡아줌
    //        do {
    //            // image storage path setting
    //            let result = try await storage.reference().child("\(diary.id)").listAll()
    //            for item in result.items {
    //                // item.getData(maxSize, completion: ) -> try await item.data(maxSize: )
    //                let data = try await item.data(maxSize: 20 * 1024 * 1024)
    //                let image = UIImage(data: data)
    //                diaryImage.append(image!)
    //            }
    //        } catch {
    //            print("error")
    //        }
    //
    //        return diaryImage
    //    }
    //
    //    // MARK: - 다중이미지 추가 메소드
    //    func uploadImages(diaryId: String, image: [UIImage]) {
    //        for i in image {
    //            let storageRef = storage.reference().child("\(diaryId)/\(i)")
    //            let data = i.jpegData(compressionQuality: 0.5)
    //            let metadata = StorageMetadata()
    //            metadata.contentType = "image/jpg"
    //            if let data = data {
    //                storageRef.putData(data, metadata: metadata) { (metadata, err) in
    //                    if let err = err {
    //                        print("err when uploading jpg\n\(err)")
    //                    }
    //
    //                    if let _ = metadata {
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    /// PodFile - Firebase SDK 제거 -> 필요시 사용하기  ( 2022.02.22 / 정훈 )
    // FIXME - 불필요한 코드 검토 바람!
    // MARK: - 다이어리 추가 메소드
//    func addCommunity(_ community: Community) async {
//        do {
//            //            uploadImages(diaryId: diary.id, image: diaryImages.image)
//
//            try await  database.collection("Community")
//                .document(community.id)
//                .setData([               "id": community.id,
//                                         "category": community.category,
//                                         "userID": community.userID,
//                                         "image": community.image,
//                                         "title": community.title,
//                                         "profileImage": community.profileImage,
//                                         "nickName": community.nickName,
//                                         "location": community.location,
//                                         "content": community.content,
//                                         "createdAt": community.createdAt])
//
//            fetchCommunities()
//        } catch {
//            print("\(error.localizedDescription)")
//        }
//
//    }
    
    /// PodFile - Firebase SDK 제거 -> 필요시 사용하기  ( 2022.02.22 / 정훈 )
    // FIXME - 불필요한 코드 검토 바람!
    // MARK: - 다이어리 삭제 메소드
//    func removeCommunity(_ community: Community) {
//        database.collection("Community")
//            .document(community.id).delete()
//
//                let imagesRef = storage.reference().child("\(diary.id)/")
//                imagesRef.delete { error in
//                    if let error = error {
//                        print("Error removing image from storage\n\(error.localizedDescription)")
//                    } else {
//                        print("images directory deleted successfully")
//                    }
//                }
//
//        fetchCommunities()
//    }
    
}
