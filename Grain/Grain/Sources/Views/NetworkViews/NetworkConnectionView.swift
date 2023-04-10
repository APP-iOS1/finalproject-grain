//
//  NetworkConnectionView.swift
//  Grain
//
//  Created by 홍수만 on 2023/03/16.
//

import SwiftUI

struct NetworkConnectionView: View {
    var networkManager: NetworkManager
    
    // Progress 변수
    @State private var isShownProgress: Bool = false

    var body: some View {
        ZStack{
            VStack{
                Image(systemName: networkManager.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130, height: 150)
                
                VStack{
                    Text("인터넷에")
                    Text(networkManager.connectionDescription)
                }
                .font(.largeTitle)
                .padding()
                
                if !networkManager.isConnected {
                    VStack{
                        Text("연결 확인 후 다시 시도해 주세요.")
                            .foregroundColor(.textGray)
                        
                            .padding(.bottom)
                        Button{
                            print("Handle action...")
                            networkManager.startMonitoring()
                            self.isShownProgress = true
                        } label: {
                            Text("새로고침")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                        }
                        .frame(width: 150)
                        .background(.black)
                        .clipShape(Capsule())
                        .padding()
                        VStack{
                            Text("네트워크 연결 시")
                            Text("자동으로 이동합니다.")
                        }
                        .bold()
                        .foregroundColor(.vivaMagenta)
                        .padding()
                    }
                }
            }
            
            if isShownProgress == true {
                ProgressView()
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.isShownProgress = false
                        }
                    }
            }
        }
    }
}

struct NetworkConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkConnectionView(networkManager: NetworkManager())
    }
}
