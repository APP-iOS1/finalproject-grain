//
//  MagazineBestView.swift
//  Grain
//
//  Created by 윤소희 on 2023/01/18.
//

import SwiftUI

import FirebaseAuth

fileprivate  enum timePeriod {
    case daily
    case weekly
    case monthly
}

struct MagazineBestView: View {
    @ObservedObject var  userVM: UserViewModel
    @ObservedObject var magazineVM: MagazineViewModel
    @ObservedObject var editorVM : EditorViewModel
    
    @State var ObservingChangeValueLikeNum : String = ""
    
    var body: some View {
        VStack {
            ScrollView {
                NavigationLink {
                    EditorView(editorVM : editorVM, userVM: userVM, magazineVM: magazineVM)
                } label: {
                    EditorViewCell(editorVM: editorVM)
                }
                HStack{
                    Text("인기 필름")
                        .font(.title)
                        .fontWeight(.bold)
                    Image("line")
                        .resizable()
                        .frame(width: Screen.maxWidth * 0.66, height: Screen.maxHeight * 0.003)
                }
                .padding([.leading, .top])
                ForEach(Array(magazineVM.sortedTopLikedMagazineData.prefix(10)), id: \.self ){ data in  // 좋아요 순으로 최대 10개까지만 뷰에 보여짐
                    NavigationLink {
                        MagazineDetailView(magazineVM: magazineVM, userVM: userVM, data: data, ObservingChangeValueLikeNum: $ObservingChangeValueLikeNum)
                    } label: {
                        LazyVStack{
                            Top10View(data: data, userVM: userVM)
                                .padding(.vertical, 7)
                                .padding(.horizontal)
                            
                        }
                        
                    }
                }
            }
            .task(id: ObservingChangeValueLikeNum){
                magazineVM.fetchMagazine() 
           }
            
        }
        .onAppear{
            editorVM.fetchEditor()
        }
    }
}

struct MagazineBestView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            MagazineBestView(userVM: UserViewModel(), magazineVM: MagazineViewModel(), editorVM: EditorViewModel())
                .previewDevice("iPhone 14 Pro")
            
            MagazineBestView(userVM: UserViewModel(), magazineVM: MagazineViewModel(), editorVM: EditorViewModel())
                .previewDevice("iPhone SE (3rd generation)")
            
            MagazineBestView(userVM: UserViewModel(), magazineVM: MagazineViewModel(), editorVM: EditorViewModel())
                .previewDevice("iPhone 12 mini")
        }
    }
}
