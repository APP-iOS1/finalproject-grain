//
//  CommunitySearchResultView.swift
//  Grain
//
//  Created by 조형구 on 2023/02/03.
//

import SwiftUI

struct CommunitySearchResultView: View {
    @ObservedObject var communtyViewModel: CommunityViewModel = CommunityViewModel()
  
    @Binding var searchWord: String
    @Environment(\.dismiss) private var dismiss
    
    private func ignoreSpaces(in string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "")
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                List(communtyViewModel.communities.filter {
                    ignoreSpaces(in: $0.fields.title.stringValue)
                        .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord)) ||
                    ignoreSpaces(in: $0.fields.content.stringValue)
                        .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord))
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
                .emptyPlaceholder(communtyViewModel.communities.filter {
                    ignoreSpaces(in: $0.fields.title.stringValue)
                        .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord)) || ignoreSpaces(in: $0.fields.content.stringValue)
                        .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord))
                }) {
        
                    SearchPlaceHolderView(searchWord: $searchWord)
                        .frame(height: Screen.maxHeight)
                        
                }
                .listStyle(.plain)
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("\(searchWord)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                    }
                    .tint(.black)
                }
            }
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
