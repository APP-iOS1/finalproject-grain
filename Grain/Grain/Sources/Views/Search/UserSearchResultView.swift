//
//  UserSearchResultView.swift
//  Grain
//
//  Created by 조형구 on 2023/02/07.
//

import SwiftUI
import Kingfisher

struct UserSearchResultView: View {
    
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var magazineVM: MagazineViewModel
    
    @State private var isShownProgress: Bool = true
    @Binding var searchWord: String
    
    private func ignoreSpaces(in string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "")
    }

    var body: some View {
            ZStack {
                VStack{
                    List{
                        ForEach(userVM.users.filter {
                            ignoreSpaces(in: $0.fields.nickName.stringValue)
                                .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord)) ||
                            ignoreSpaces(in: $0.fields.name.stringValue)
                                .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord))
                        },id: \.self) { item in
                            NavigationLink {
                                UserSearchDetailView(userVM: userVM, magazineVM: magazineVM, user: item)
                            } label: {
                                HStack{
                                    Circle()
                                        .stroke(lineWidth: 1)
                                        .frame(width: 47, height: 47)
                                        .foregroundColor(.black)
                                        .overlay(
                                            KFImage(URL(string: item.fields.profileImage.stringValue) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                                                .resizable()
                                                .foregroundColor(.brightGray)
                                                .scaledToFill()
                                        )
                                    VStack(alignment: .leading){
                                        Text(item.fields.nickName.stringValue)
                                            .bold()
                                            .padding(.bottom, 5)
                                        Text(item.fields.name.stringValue)
                                            .font(.caption)
                                            .foregroundColor(.textGray)
                                            .frame(alignment: .leading)
                                    }
                                    .padding(.leading)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .emptyPlaceholder(userVM.users.filter {
                        ignoreSpaces(in: $0.fields.nickName.stringValue)
                            .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord)) ||
                        ignoreSpaces(in: $0.fields.name.stringValue)
                            .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord))
                    }) {
                        VStack{
                            Spacer()
                            SearchPlaceHolderView(searchWord: $searchWord)
                            Spacer()
                        }
                    }
                    .listStyle(.plain)
                    Spacer()
                }
                if isShownProgress == true {
                    SearchProgress()
                        .onAppear{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.isShownProgress = false
                            }
                        }
                }
            }
            .navigationTitle("\(searchWord)")
            .navigationBarTitleDisplayMode(.inline)
    }
}

//struct UserSearchResultView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserSearchResultView(searchWord: .constant(""), user: UserViewModel())
//    }
//}
