//
//  ReportMainView.swift
//  Grain
//
//  Created by 조형구 on 2023/04/14.
//

import SwiftUI

struct ReportMainView: View {
    private let reportReason = ["스팸", "나체 이미지 또는 성적 행위와 같은 음란물", "사기 또는 거짓","혐오 발언 또는 상징", "거짓 정보", "따돌림 또는 괴롭힘", "폭력 또는 위험한 단체", "지식재산권 침해", "불법 또는 규제 상품 판매", "자살 또는 자해", "섭식 장애", "기타 문제"]
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                Text("이 게시물을 신고하는 이유")
                    .padding()
                    .bold()
                Text("지식재산권 침해를 신고하는 경우를 제외하고 회원님의 신고는 익명으로 처리됩니다. 누군가 위급한 상황에 있다고 생각된다면 즉시 현지 응급 서비스 기관에 연락하시기 바랍니다.")
                    .padding(.horizontal)
                    .font(.footnote)
                    .foregroundColor(.textGray)
                
                    List(reportReason, id:\.self){ item in
                        NavigationLink {
                            ReportDetailView(reportReason: item)
                        } label: {
                            Text("\(item)")
                                .padding(.vertical, 10)
                        }
                    }
                    .listStyle(.plain)
              
            }
        }
        .navigationTitle("신고")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ReportMainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            ReportMainView()
        }
    }
}
