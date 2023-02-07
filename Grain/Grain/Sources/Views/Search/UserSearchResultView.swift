//
//  UserSearchResultView.swift
//  Grain
//
//  Created by 조형구 on 2023/02/07.
//

import SwiftUI

struct UserSearchResultView: View {
    @ObservedObject var magazineViewModel: MagazineViewModel = MagazineViewModel()
    @ObservedObject var userViewModel: UserViewModel = UserViewModel()
    @Binding var searchWord: String
    
    private func ignoreSpaces(in string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "")
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                List{
                    ForEach(userViewModel.users.filter {
                        ignoreSpaces(in: $0.fields.nickName.stringValue)
                            .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord)) ||
                        ignoreSpaces(in: $0.fields.name.stringValue)
                            .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord))
                    },id: \.self) { item in
                        NavigationLink {
                            UserSearchDetailView(user: item)
                        } label: {
                            VStack(alignment: .leading){
                                HStack{
                                    Circle()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.brightGray)
                                        .overlay(
                                            Image(systemName: "person.fill")
                                        )
                                    VStack{
                                        Text(item.fields.nickName.stringValue)
                                            .bold()
                                            .padding([.bottom, .leading], 5)
                                        Text(item.fields.name.stringValue)
                                            .font(.caption)
                                            .foregroundColor(.textGray)
                                    }
                                }
                                
                            }
                        }
                    }
                }
                .emptyPlaceholder(userViewModel.users.filter {
                    ignoreSpaces(in: $0.fields.nickName.stringValue)
                        .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord))
                }) {
                    VStack{
                        VStack{
                            Spacer()
                            SearchPlaceHolderView(searchWord: $searchWord)
                                .frame(height: 600)
                            Spacer()
                        }
                    }
                }
                .listStyle(.plain)
                Spacer()
            }
            .navigationTitle("\(searchWord)")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear{
                magazineViewModel.fetchMagazine()
                userViewModel.fetchUser()
            }
        }
        
    }
}


struct UserSearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        UserSearchResultView(searchWord: .constant(""))
    }
}
