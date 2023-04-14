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
    
    
    func errorImage() -> String{
        var https : String = "https://"
        if let infolist = Bundle.main.infoDictionary {
            if let url = infolist["ThumbnailImageError"] as? String {
                https += url
            }
        }
        return https
    }
    func tagColorFunction(stateColor: String) -> String{
        
        var tagColor: String {
            switch stateColor {
            case "판매중":
                return "#005E5B"
                //            return "#4C9E77"
            case "모집완료", "판매완료":
                return "#A0A0A0"
            case "Tip":
                return "#FAC75B"
                //            return "#F5dF4D"
            case "모집중":
                return "#1E3F66"
            default:
                return "4C9E77"
            }
        }
        return tagColor
    }
    func tagNameColorFunction(stateNameColor: String) -> String{
        
        var tagNameColor: String {
            switch stateNameColor {
            case "모집중", "판매중":
                return "#FFFFFF"
            case "모집완료", "판매완료":
                return "#FFFFFF"
            case "Tip":
                return "000000"
            default:
                return "#FFFFFF"
            }
        }
        return tagNameColor
    }
    
    var body: some View {
        ZStack {
            VStack{
                List{
                    ForEach(communityVM.sortedRecentCommunityData.filter {
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
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 90, height: 90)
                                    .foregroundColor(.white)
                                    .cornerRadius(7)
                                    .clipped()
                                    .padding(.leading, -5)
                                    .padding(.trailing, 5)
                                 
                                VStack(alignment: .leading){
                                    HStack {
                                        
                                        Text("\(item.fields.category.stringValue)")
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 7)
                                            .background(Color.black)
                                            .cornerRadius(20)
                                            .foregroundColor(.white)
                                            .bold()
                                            .font(.caption2)
                                        
                                        Text("\(item.fields.state.stringValue)")
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 7)
                                            .background(Color(hex: tagColorFunction(stateColor: item.fields.state.stringValue)))
                                            .cornerRadius(20)
                                            .foregroundColor(Color(hex: tagNameColorFunction(stateNameColor: item.fields.state.stringValue)))
                                            .bold()
                                            .font(.caption2)
                                    } // hstack
                                    Text(item.fields.title.stringValue)
                                        .bold()
                                        .padding(.bottom, 5)
                                    Text(item.fields.content.stringValue)
                                        .lineLimit(2)
                                        .foregroundColor(.textGray)
                                        .font(.caption)
                                        .padding(.leading, 1)
                                }
                            }
                        }
                    }
                }
                .emptyPlaceholder(communityVM.sortedRecentCommunityData.filter {
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
