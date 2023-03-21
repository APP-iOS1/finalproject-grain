//
//  BookmarkedMagazine.swift
//  Grain
//
//  Created by 홍수만 on 2023/02/06.
//

import SwiftUI
import Kingfisher

struct BookmarkedMagazine: View {
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var magazineVM: MagazineViewModel
    
    @State var ObservingChangeValueLikeNum : String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var bookmarkedMagazineDocument: [MagazineDocument]
 
    let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        VStack{
            ScrollView{
                LazyVGrid(columns: columns, spacing: 1) {
                    ForEach(bookmarkedMagazineDocument, id: \.self) { item in
                        NavigationLink {
                            MagazineDetailView(magazineVM: magazineVM, userVM: userVM, data: item, ObservingChangeValueLikeNum: $ObservingChangeValueLikeNum)
                        } label: {
                            KFImage(URL(string: item.fields.image.arrayValue.values[0].stringValue) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                               .resizable()
                               .scaledToFill()
                               .frame(width: Screen.maxWidth / 3 - 1, height: Screen.maxWidth / 3 - 1)
                               .clipped()
                        }
                    }
                }
            }
            .task(id: ObservingChangeValueLikeNum){
                Task{
                    await magazineVM.fetchMagazine()
                }
            }
        }
        .navigationTitle("저장된 매거진")
        .navigationBarTitleDisplayMode(.inline)
    }
}

