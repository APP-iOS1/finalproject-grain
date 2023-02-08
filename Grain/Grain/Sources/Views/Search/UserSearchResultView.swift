//
//  UserSearchResultView.swift
//  Grain
//
//  Created by 조형구 on 2023/02/07.
//

import SwiftUI

struct UserSearchResultView: View {
    @State private var isShownProgress: Bool = true
    @Binding var searchWord: String
    
    private func ignoreSpaces(in string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "")
    }
    let user: UserViewModel
    var body: some View {
            ZStack {
                VStack{
                    List{
                        ForEach(user.users.filter {
                            ignoreSpaces(in: $0.fields.nickName.stringValue)
                                .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord)) ||
                            ignoreSpaces(in: $0.fields.name.stringValue)
                                .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord))
                        },id: \.self) { item in
                            NavigationLink {
                                UserSearchDetailView(user: item)
                            } label: {
                                HStack{
                                    Circle()
                                        .stroke(lineWidth: 1)
                                        .frame(width: 47, height: 47)
                                        .foregroundColor(.black)
                                        .overlay(
                                            Image(systemName: "person.fill")
                                                .resizable()
                                                .foregroundColor(.brightGray)
                                                .aspectRatio(contentMode: .fit)
                                                .padding(9)
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
                    .emptyPlaceholder(user.users.filter {
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


struct UserSearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        UserSearchResultView(searchWord: .constant(""), user: UserViewModel())
    }
}
