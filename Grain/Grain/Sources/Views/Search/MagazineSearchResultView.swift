//
//  MagazineSearchResultView.swift
//  Grain
//
//  Created by 조형구 on 2023/02/07.
//

import SwiftUI

struct MagazineSearchResultView: View {
    @StateObject var magazineVM = MagazineViewModel()
    
    @State private var isShownProgress:Bool = true
    @State var ObservingChangeValueLikeNum : String = ""
    
    @Binding var searchWord: String
    
    let magazine: MagazineViewModel
    let userViewModel: UserViewModel
    
    private func ignoreSpaces(in string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "")
    }
    
    var body: some View {
        ZStack{
            VStack{
                List{
                    ForEach(magazine.magazines.filter {
                        ignoreSpaces(in: $0.fields.title.stringValue)
                            .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord)) ||
                        ignoreSpaces(in: $0.fields.content.stringValue)
                            .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord))
                    },id: \.self) { item in
                        NavigationLink {
                            MagazineDetailView(magazineVM: magazineVM, userVM: userViewModel, data: item, ObservingChangeValueLikeNum: $ObservingChangeValueLikeNum)
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
                .emptyPlaceholder(magazine.magazines.filter {
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
            .task(id: ObservingChangeValueLikeNum){
                Task{
                    await magazineVM.fetchMagazine()
                }
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

struct MagazineSearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        MagazineSearchResultView(searchWord: .constant(""), magazine: MagazineViewModel(), userViewModel: UserViewModel())
    }
}
