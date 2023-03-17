//
//  NetworkManager.swift
//  Grain
//
//  Created by 홍수만 on 2023/03/16.
//

import Foundation
import Network

class NetworkManager: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkManager")
    @Published var isConnected: Bool = true
    
    var imageName: String {
        return isConnected ? "wifi" : "wifi.exclamationmark"
    }
    
    var connectionDescription: String {
        if isConnected {
            return "연결되었습니다."
        } else {
            return "연결되지 않았습니다."
        }
    }
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        
        monitor.start(queue: queue)
    }
}
