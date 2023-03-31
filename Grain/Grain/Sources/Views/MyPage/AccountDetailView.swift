//
//  AccountDetailView.swift
//  Grain
//
//  Created by 박희경 on 2023/03/28.
//

import SwiftUI

struct AccountDetailView: View {
    @ObservedObject var userVM: UserViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink {
                DeleteUserView(userVM: userVM)
            } label: {
                HStack() {
                    Text("계정 삭제")
                        .font(.title3)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.title3)
                }
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.vertical)
            }
            .padding(.horizontal)
            Spacer()
        }
    }
}

//struct AccountDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        AccountDetailView()
//    }
//}
