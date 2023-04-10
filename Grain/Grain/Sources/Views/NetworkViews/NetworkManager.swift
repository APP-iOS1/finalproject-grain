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
    @Published var currentInterface: NWInterface.InterfaceType = .wifi
    
    var isWiFi: Bool = false
    var isCellular: Bool = false
    
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
    
    var wifiConnection: String {
        if isWiFi {
            return "와이파이에 연결되었습니다"
        } else {
            return ""
        }
    }
    
    var cellularConnection: String {
        if isCellular {
            return "셀룰러에 연결되었습니다"
        } else {
            return ""
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
    
    //네트워크 모니터링 시작 함수
    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            
            if path.usesInterfaceType(.wifi) {
                print("Using wifi")
                self.isWiFi = true
                
            } else if path.usesInterfaceType(.cellular) {
                print("Using cellular")
                self.isCellular = true
            }
        }
    }
}
