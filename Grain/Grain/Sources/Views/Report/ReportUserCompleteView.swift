//
//  ReportUserCompleteView.swift
//  Grain
//
//  Created by 조형구 on 2023/04/16.
//

import SwiftUI

struct ReportUserCompleteView: View {
    @ObservedObject var userVM: UserViewModel

    @Binding var isReportAlertShown: Bool
    @Binding var isUserBlockAlertShown: Bool
    
    let reportNickname: String

    var body: some View {
        VStack{
            Image(systemName: "checkmark.circle")
                .font(.system(size: 70))
                .padding()
                .foregroundColor(.green)
            Text("알려주셔서 고맙습니다")
                .font(.title2)
            Text("회원님의 소중한 의견은 Grain 커뮤니티를 안전하게 유지하는데 도움이 됩니다.")
                .font(.subheadline)
                .foregroundColor(.textGray)
                .padding(.vertical, 5)
                .padding(.horizontal, 30)
                .multilineTextAlignment(.center)
            Spacer()

            Text("신고 내용은 검토 후에 24시간 이내에 처리됩니다.")
                .font(.subheadline)
                .foregroundColor(.textGray)
                .padding(.horizontal, 30)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            NavigationLink {
                ReportUserBlockView(userVM: userVM, reportNickname: reportNickname, isUserBlockAlertShown: $isUserBlockAlertShown, isReportAlertShown: $isReportAlertShown)
            } label: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.black)
                    .frame(width: Screen.maxWidth * 0.85, height: Screen.maxHeight * 0.07)
                    .overlay(
                        Text("추가 조치")
                            .font(.headline)
                            .foregroundColor(.white)
                    )
            }
            .padding()
        }
        .navigationTitle("신고")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .presentationDetents([.medium])
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isReportAlertShown = false
                } label: {
                    Text("완료")
                }

            }
        }

    }
}

//struct ReportUserCompleteView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReportUserCompleteView()
//    }
//}
