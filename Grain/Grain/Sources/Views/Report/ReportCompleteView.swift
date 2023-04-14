//
//  ReportCompleteView.swift
//  Grain
//
//  Created by 조형구 on 2023/04/14.
//

import SwiftUI

struct ReportCompleteView: View {
    var body: some View {
        VStack{
            Image(systemName: "checkmark.circle")
                .font(.system(size: 70))
                .padding()
                .foregroundColor(.green)
                .padding(.top)
            Text("알려주셔서 고맙습니다")
                .font(.title2)
            Text("회원님의 소중한 의견은 Grain 커뮤니티를 안전하게 유지하는데 도움이 됩니다.")
                .font(.subheadline)
                .foregroundColor(.textGray)
                .padding(.vertical, 5)
                .padding(.horizontal, 30)
                .multilineTextAlignment(.center)
            
            Spacer()
            
        }
        .navigationTitle("신고")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ReportCompleteView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            
            ReportCompleteView()
        }
    }
}
