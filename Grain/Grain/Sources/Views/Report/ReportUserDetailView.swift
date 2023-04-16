//
//  ReportUserDetailView.swift
//  Grain
//
//  Created by 조형구 on 2023/04/16.
//

import SwiftUI

private enum FocusableField: Hashable {
    case search
}

struct ReportUserDetailView: View {
    @ObservedObject var userVM : UserViewModel
    
    @State private var detailReportReason: String = ""
    @State private var isDone: Bool = false

    let reportID: String
    let reportCategory: String
    let reportReason: String
    let reportNickname: String

    @Binding var isReportAlertShown: Bool
    @Binding var isUserBlockAlertShown: Bool
    
    @FocusState private var focus: FocusableField?

    var body: some View {
        VStack{
            Text("**\(reportNickname)** 님을 '**\(reportReason)**' 의 사유로 신고하시겠습니까?")
                .padding()
                .multilineTextAlignment(.center)
            
            Text("\(Image(systemName: "info.circle")) 이 유저를 신고하는 상세한 이유를 작성해 주시면 빠른 처리가 가능합니다.")
                .padding(.top, 10)
                .foregroundColor(.middlebrightGray)
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)
            
            ScrollView {
                VStack {
                    TextField("상세한 문제 내용을 작성해 주세요...", text: $detailReportReason, axis: .vertical)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .focused($focus, equals: .search)
                        .font(.subheadline)
                        .padding()
                    Spacer()
                }
            }
            .onTapGesture {
                if focus == .search{
                    focus = nil
                }else if focus == nil{
                    focus = .search
                }
            }
      
            Button {
                userVM.declaration(id: reportID, category: reportCategory, reason: reportReason, reasonDetail: detailReportReason)
                self.isDone.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.black)
                    .frame(width: Screen.maxWidth * 0.85, height: Screen.maxHeight * 0.07)
                    .overlay(
                        Text("신고 제출")
                            .font(.headline)
                            .foregroundColor(.white)
                    )
            }
            .padding()
            
        }
        .navigationTitle("신고")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $isDone) {
            ReportUserCompleteView(userVM: userVM, isReportAlertShown: $isReportAlertShown, isUserBlockAlertShown: $isUserBlockAlertShown, reportNickname: reportNickname)
        }
    }
}

//struct ReportUserDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReportUserDetailView()
//    }
//}
