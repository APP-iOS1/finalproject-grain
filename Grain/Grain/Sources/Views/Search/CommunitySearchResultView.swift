//
//  CommunitySearchResultView.swift
//  Grain
//
//  Created by 조형구 on 2023/02/03.
//

import SwiftUI
import Kingfisher

struct CommunitySearchResultView: View {
    @State private var isShownProgress: Bool = true
    @ObservedObject var communityVM: CommunityViewModel
    @ObservedObject var userVM: UserViewModel
    @ObservedObject var magazineVM: MagazineViewModel
    
    @Binding var searchWord: String
    
    private func ignoreSpaces(in string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "")
    }
    
    let community: CommunityViewModel
    
    func errorImage() -> String{
        var https : String = "https://"
        if let infolist = Bundle.main.infoDictionary {
            if let url = infolist["ThumbnailImageError"] as? String {
                https += url
            }
        }
        return https
    }
    
    var body: some View {
        ZStack {
            VStack{
                List{
                    ForEach(community.communities.filter {
                        ignoreSpaces(in: $0.fields.title.stringValue)
                            .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord)) ||
                        ignoreSpaces(in: $0.fields.content.stringValue)
                            .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord))
                    },id: \.self) { item in
                        NavigationLink {
                            CommunityDetailView(communityVM: communityVM, userVM: userVM, magazineVM: magazineVM, community: item)
                        } label: {
                            HStack{
                                KFImage(URL(string: item.fields.image.arrayValue.values[0].stringValue) ?? URL(string: errorImage() ))
                                    .resizable()
                                    .frame(width: 90, height: 90)
                                    .foregroundColor(.white)
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.leading, -5)
                                    .padding(.trailing, 5)
                                 
                                VStack(alignment: .leading){
                                    Text(item.fields.title.stringValue)
                                        .bold()
                                        .padding(.bottom, 5)
                                    Text(item.fields.content.stringValue)
                                        .lineLimit(2)
                                        .foregroundColor(.textGray)
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
                .emptyPlaceholder(community.communities.filter {
                    ignoreSpaces(in: $0.fields.title.stringValue)
                        .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord)) || ignoreSpaces(in: $0.fields.content.stringValue)
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

//struct CommunitySearchResultView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        CommunitySearchResultView(searchWord: .constant(""), community: CommunityViewModel())
//    }
//}
