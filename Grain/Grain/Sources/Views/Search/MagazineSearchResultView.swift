//
//  MagazineSearchResultView.swift
//  Grain
//
//  Created by 조형구 on 2023/02/07.
//

import SwiftUI

struct MagazineSearchResultView: View {
    @ObservedObject var magazineViewModel: MagazineViewModel = MagazineViewModel()
    
    @Binding var searchWord: String
    
    private func ignoreSpaces(in string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "")
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                List{
                    ForEach(magazineViewModel.magazines.filter {
                        ignoreSpaces(in: $0.fields.title.stringValue)
                            .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord)) ||
                        ignoreSpaces(in: $0.fields.content.stringValue)
                            .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord))
                    },id: \.self) { item in
                        NavigationLink {
                            MagazineDetailView(data: item)
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
                .emptyPlaceholder(magazineViewModel.magazines.filter {
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
                magazineViewModel.fetchMagazine()
        }
        }

    }
}

struct MagazineSearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        MagazineSearchResultView(searchWord: .constant(""))
    }
}
