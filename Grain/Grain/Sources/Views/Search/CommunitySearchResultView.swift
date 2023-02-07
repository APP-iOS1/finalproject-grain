//
//  CommunitySearchResultView.swift
//  Grain
//
//  Created by 조형구 on 2023/02/03.
//

import SwiftUI

struct CommunitySearchResultView: View {
    @ObservedObject var communityViewModel: CommunityViewModel = CommunityViewModel()
    
    @Binding var searchWord: String
    
    private func ignoreSpaces(in string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "")
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                List{
                    ForEach(communityViewModel.communities.filter {
                        ignoreSpaces(in: $0.fields.title.stringValue)
                            .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord)) ||
                        ignoreSpaces(in: $0.fields.content.stringValue)
                            .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord))
                    },id: \.self) { item in
                        NavigationLink {
                            CommunitySearchDetailView(community: item)
                        } label: {
                            HStack{
                                Rectangle()
                                    .foregroundColor(.gray)
                                    .frame(width: 90, height: 90)
                                    .overlay{
                                        Image(systemName: "camera.fill")
                                            .resizable()
                                            .foregroundColor(.white)
                                            .aspectRatio(contentMode: .fit)
                                            .padding()
                                    }
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
                .emptyPlaceholder(communityViewModel.communities.filter {
                    ignoreSpaces(in: $0.fields.title.stringValue)
                        .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord)) || ignoreSpaces(in: $0.fields.content.stringValue)
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
                communityViewModel.fetchCommunity()
        }
        }
    }
}

struct CommunitySearchResultView_Previews: PreviewProvider {
    
    static var previews: some View {
        CommunitySearchResultView(searchWord: .constant(""))
    }
}
