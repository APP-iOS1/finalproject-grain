//
//  CommunitySearchResultView.swift
//  Grain
//
//  Created by 조형구 on 2023/02/03.
//

import SwiftUI

struct CommunitySearchResultView: View {
    @ObservedObject var communtyViewModel: CommunityViewModel = CommunityViewModel()
    
    @State private var searchList: [String] =  ["카메라", "명소", " 출사"]
    @Binding var searchWord: String
    
    var body: some View {
        NavigationStack {
            VStack{
                List(communtyViewModel.communities.filter {
                    $0.fields.title.stringValue
                        .localizedCaseInsensitiveContains(self.searchWord) || $0.fields.content.stringValue
                        .localizedCaseInsensitiveContains(self.searchWord)
                },id: \.self) { item in
                    
                    HStack{
                        Rectangle()
                            .foregroundColor(.gray)
                            .frame(width: 90, height: 90)
                            .overlay{
                                Image(systemName: "person.fill")
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
                .listStyle(.plain)
                Spacer()
            }
            .navigationTitle("\(searchWord)")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear{
                communtyViewModel.fetchCommunity()
            }
        }
        
        
    }
}

struct CommunitySearchResultView_Previews: PreviewProvider {
    
    static var previews: some View {
        CommunitySearchResultView(searchWord: .constant(""))
    }
}
