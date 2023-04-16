//
//  ReportUserBlockView.swift
//  Grain
//
//  Created by 조형구 on 2023/04/16.
//

import SwiftUI

struct ReportUserBlockView: View {
    @ObservedObject var userVM: UserViewModel

    let reportNickname: String

    @State var userData: UserDocument?
    
    @Binding var isUserBlockAlertShown: Bool
    @Binding var isReportAlertShown: Bool

    var body: some View {
        VStack(alignment: .leading){
            Text("해당 유저를 차단하실 수 있습니다.")
                .font(.title3)
                .multilineTextAlignment(.leading)
                .padding()
            Text("상대방은 Grain에서 회원님의 프로필, 게시물을 찾을 수 없습니다. 상대방에게는 회원님이 차단했다는 정보를 알리지 않습니다.")
                .foregroundColor(.textGray)
                .font(.footnote)
                .padding(.horizontal)
          
                Button {
                    self.isReportAlertShown = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                        
                        self.isUserBlockAlertShown = true
                    }

                } label: {
                    HStack{
                        
                        Text("\(reportNickname)님 차단 ")
                            .foregroundColor(.red)
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                    }
                    .padding(.horizontal)
                
                }
                .padding(.top,  50)
                
                Divider()
            Spacer()

        }
    }
}

//struct ReportUserBlockView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack{
//            ReportUserBlockView(reportNickname: "hello")
//        }
//    }
//}
