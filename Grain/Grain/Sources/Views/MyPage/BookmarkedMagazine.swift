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
    
//    @Environment(\.presentationMode) var presentationMode
    
    @State private var bookmarkedMagazineDocument: [MagazineDocument] = []
 
    let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    func errorImage() -> String{
        var https : String = "https://"
        if let infolist = Bundle.main.infoDictionary {
            if let url = infolist["DetailImageError"] as? String {
                https += url
            }
        }
        return https
    }
    
    var body: some View {
        VStack{
            ScrollView{
                LazyVGrid(columns: columns, spacing: 1) {
                    ForEach(bookmarkedMagazineDocument.reversed(), id: \.self) { item in
                        NavigationLink {
                            MagazineDetailView(magazineVM: magazineVM, userVM: userVM, data: item, ObservingChangeValueLikeNum: $ObservingChangeValueLikeNum)
                        } label: {
                            KFImage(URL(string: item.fields.image.arrayValue.values[0].stringValue) ?? URL(string: errorImage()))
                               .resizable()
                               .scaledToFill()
                               .frame(width: Screen.maxWidth / 3 - 1, height: Screen.maxWidth / 3 - 1)
                               .clipped()
                        }
                    }
                }
            }
            .emptyPlaceholder(bookmarkedMagazineDocument.reversed()) {
                BookmarkedMagazinePlaceholderView()
            }
            .onChange(of: ObservingChangeValueLikeNum, perform: { newValue in
                magazineVM.fetchMagazine(nextPageToken: "")
            })
        }
        .navigationTitle("저장된 피드")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            bookmarkedMagazineDocument = magazineVM.userBookmarkedPostsFilter(magazineData: magazineVM.sortedRecentMagazineData, userBookmarkedPostedArr: userVM.bookmarkedMagazineID)
        }
        .refreshable {
            do {
                try await Task.sleep(nanoseconds: UInt64(1.6) * 1_000_000_000)
              } catch {}
            bookmarkedMagazineDocument = magazineVM.userBookmarkedPostsFilter(magazineData: magazineVM.sortedRecentMagazineData, userBookmarkedPostedArr: userVM.bookmarkedMagazineID)
        }
    }
}

