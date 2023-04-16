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
    
    var searchedUser: [UserDocument] {
        var arr = userVM.users.filter {
            ignoreSpaces(in: $0.fields.nickName.stringValue)
                .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord)) ||
            ignoreSpaces(in: $0.fields.introduce.stringValue)
                .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord))
        }
        for i in userVM.blockingList{
            arr.removeAll{$0.fields.id.stringValue == i}
        }

        for i in userVM.blockedList{
            arr.removeAll{$0.fields.id.stringValue == i}
        }
        return Array(arr)
    }
    
    private func ignoreSpaces(in string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "")
    }
    
    func defaultProfileImage() -> String{
        var https : String = "https://"
        if let infolist = Bundle.main.infoDictionary {
            if let url = infolist["FailProfileImage"] as? String {
                https += url
            }
        }
        return https
    }


    var body: some View {
            ZStack {
                VStack{
                    List{
                        if searchedUser.count > 0 {
                            ForEach(0..<searchedUser.count ,id: \.self) { i in
                                NavigationLink {
                                    UserDetailView(userVM: userVM, magazineVM: magazineVM, user: searchedUser[i])
                                } label: {
                                    HStack{
                                        KFImage(URL(string: searchedUser[i].fields.profileImage.stringValue) ?? URL(string: defaultProfileImage()))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 47, height: 47)
                                            .cornerRadius(64)
                                            .overlay {
                                                Circle()
                                                    .stroke(lineWidth: 0.5)
                                            }
                                        
                                        VStack(alignment: .leading){
                                            Text(searchedUser[i].fields.nickName.stringValue)
                                                .bold()
                                                .padding(.bottom, 5)
                                            Text(searchedUser[i].fields.introduce.stringValue)
                                                .font(.caption2)
                                                .foregroundColor(.textGray)
                                                .frame(alignment: .leading)
                                                .lineLimit(1)
                                        }
                                        .padding(.leading)
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                    .emptyPlaceholder(userVM.users.filter {
                        ignoreSpaces(in: $0.fields.nickName.stringValue)
                            .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord)) ||
                        ignoreSpaces(in: $0.fields.introduce.stringValue)
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
            .onAppear{
                userVM.filterBlockUsers()

            }
    }
}

//struct UserSearchResultView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserSearchResultView(searchWord: .constant(""), user: UserViewModel())
//    }
//}
