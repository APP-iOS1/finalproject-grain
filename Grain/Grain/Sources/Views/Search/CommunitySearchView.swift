//
//  CommunitySearchView .swift
//  Grain
//
//  Created by 조형구 on 2023/02/06.
//

import SwiftUI

struct CommunitySearchView: View {
    @ObservedObject var communtyViewModel: CommunityViewModel = CommunityViewModel()
    
    @Binding var searchWord: String
    @State private var isCommunitySearchResultShown: Bool = false

    private func ignoreSpaces(in string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "")
    }
    var body: some View {
        VStack{
                HStack{
                    Text("\(Image(systemName: "magnifyingglass")) \(searchWord)")
                    Spacer()
                }
            List(communtyViewModel.communities.filter {
               ignoreSpaces(in: $0.fields.title.stringValue)
                    .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord)) || ignoreSpaces(in: $0.fields.content.stringValue)
                    .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord))
            },id: \.self) { item in
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
            .listStyle(.plain)
        }
        .navigationDestination(isPresented: $isCommunitySearchResultShown, destination: {
            CommunitySearchResultView(searchWord: $searchWord)
        })
        .onAppear{
            communtyViewModel.fetchCommunity()
        }
    }
}

struct CommunitySearchView_Previews: PreviewProvider {
    static var previews: some View {
        CommunitySearchView(searchWord: .constant(""))
    }
}
