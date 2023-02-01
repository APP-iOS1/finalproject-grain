



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

