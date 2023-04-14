//
//  ReportDetailView.swift
//  Grain
//
//  Created by 조형구 on 2023/04/14.
//

import SwiftUI

struct ReportDetailView: View {
    @State private var detailReportReason: String = ""
    @State private var isDone: Bool = false
    
    let reportReason: String
    
    var body: some View {
        VStack{
            Text("이 게시물을 '**\(reportReason)**' 의 사유로 신고하시겠습니까?")
                .padding()
                .multilineTextAlignment(.center)
                .font(.subheadline)
            
            Text("\(Image(systemName: "info.circle")) 이 게시물을 신고하는 상세한 이유를 작성해주시면 빠른 처리가 가능합니다.")
                .padding(.top, 10)
                .foregroundColor(.middlebrightGray)
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)
            
            Form{
                TextEditor(text: $detailReportReason)
                    .frame(height: Screen.maxHeight * 0.4)
                    .padding(.horizontal)
                
            }
            
            Spacer()
            Button {
                
            } label: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.black)
                    .frame(width: Screen.maxWidth * 0.85, height: Screen.maxHeight * 0.07)                    .overlay(
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
            ReportCompleteView()
        }
    }
}

struct ReportDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            
            ReportDetailView(reportReason: "dd")
        }
    }
}
