//
//  GeocodeService.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/01.
//

import SwiftUI
import Combine

enum GeocodeService {
    
    
    static func getGeocode() -> AnyPublisher<GeocodeType, Error> {
        
        let naverURL = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query= 경기도 화성시"
        let firestoreURL = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents/Map"
        
        var request = URLRequest(url: URL(string: firestoreURL)!)
        do {
            request = try GeocodeRouter.get.asURLRequest()
        } catch {
            // [x] error handling
            print("http error")
        }
        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .map{ $0.data}
            .decode(type: GeocodeType.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}


//
//class GeocodeService: DataService {
//
//    var geocodePublisher: Published<GeocodeType?>.Publisher {
//        $geocode
//    }
//    @Published var geocode: GeocodeType? = nil
//    var cancellabes = Set<AnyCancellable>()
//
//    func fetchGeocode(_ text: String) {
//        guard let urlRequest = getURLRequest(text) else { return }
//        URLSession.shared.dataTaskPublisher(for: urlRequest)
//            .subscribe(on: DispatchQueue.global(qos: .background))
//            .receive(on: DispatchQueue.main)
//            .tryMap(handleOutput)
//            .decode(type: GeocodeType.self, decoder: JSONDecoder())
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    print("SUCCESS")
//                    break
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            } receiveValue: { [weak self] returnedData in
//                guard let self = self else { return }
//                self.geocode = returnedData
//                print(returnedData)
//            }
//            .store(in: &cancellabes)
//    }
//
//    private func getURL() -> URL? {
//        let urlString = GeocodeAPI.geocode.urlString
//        guard let url = URL(string: urlString) else { return nil }
//        return url
//    }
//
//    private func getURLRequest(_ body: String) -> URLRequest? {
//        guard let url = getURL(), let body = try? JSONSerialization.data(withJSONObject: ["content" : body]) else { return nil }
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "GET"
//        urlRequest.setValue(GeocodeAPI.geocode.clientID, forHTTPHeaderField: GeocodeAPI.geocode.clientHeaderKeyID)
//        urlRequest.setValue(GeocodeAPI.geocode.clientSecret, forHTTPHeaderField: GeocodeAPI.geocode.clientHeaderSecretID)
//        urlRequest.httpBody = body
//        return urlRequest
//    }
//
//    private func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
//        guard
//            let response = output.response as? HTTPURLResponse,
//            response.statusCode == 200 else { throw URLError(.badServerResponse) }
//        return output.data
//    }
//}
//
//protocol DataService {
//    var geocodePublisher: Published<GeocodeType?>.Publisher { get }
//    func fetchGeocode(_ text: String)
//}
//
