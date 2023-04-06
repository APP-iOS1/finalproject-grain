//
//  MagazineBestView.swift
//  Grain
//
//  Created by 윤소희 on 2023/01/18.
//

import SwiftUI

import FirebaseAuth

struct MagazineBestView: View {
    @ObservedObject var  userVM: UserViewModel
    @ObservedObject var magazineVM: MagazineViewModel
    @ObservedObject var editorVM : EditorViewModel
    
    @State var ObservingChangeValueLikeNum: String = ""
    @State private var isMagazineDegtailViewShown: Bool = false
    @State private var isMagazineEditorViewShown: Bool = false
    @State private var selectIndexNum: Int = 0
    
    var body: some View {
        VStack {
            ScrollView {
                
                EditorViewCell(editorVM: editorVM)
                    .onTapGesture {
                        isMagazineEditorViewShown.toggle()
                    }
                
                HStack{
                    Text("인기 피드")
                        .font(.title)
                        .fontWeight(.bold)
                        .fixedSize()
                    Spacer()
                    Image("line")
                        .resizable()
                        .frame(width: Screen.maxWidth * 0.66, height: 2)
                }
                .padding([.leading, .top])
                
                HStack{
                    Text("\(Image(systemName: "info.circle")) 좋아요 수 기준으로 인기 피드를 보여드립니다.")
                        .font(.footnote)
                        .foregroundColor(.middlebrightGray)
                    Spacer()
                   
                }
                .padding(.horizontal,21)
                .padding(.top, 7)
                .padding(.bottom, 2)
                
                ForEach(Array(magazineVM.sortedTopLikedMagazineData.prefix(10).enumerated()), id: \.1.self ){ (index, data) in  // 좋아요 순으로 최대 10개까지만 뷰에 보여짐
                    
                    LazyVStack{
                        Top10View(data: data, userVM: userVM)
                            .padding(.vertical, 7)
                            .padding(.horizontal)
                        
                    }
                    .onTapGesture {
                        selectIndexNum = index
                        isMagazineDegtailViewShown.toggle()
                    }
                    
                    
                }
            }
            .task(id: ObservingChangeValueLikeNum){
                magazineVM.fetchMagazine()
            }
            
        }
        .navigationDestination(isPresented: $isMagazineDegtailViewShown){
            ForEach(Array(magazineVM.sortedTopLikedMagazineData.prefix(10).enumerated()), id: \.1.self ){ (index, data ) in  // 좋아요 순으로 최대 10개까지만 뷰에 보여짐
                if selectIndexNum == index{
                    
                    MagazineDetailView(magazineVM: magazineVM, userVM: userVM, data: data, ObservingChangeValueLikeNum: $ObservingChangeValueLikeNum)
                }
            }
        }
        .navigationDestination(isPresented: $isMagazineEditorViewShown){
            EditorView(editorVM : editorVM, userVM: userVM, magazineVM: magazineVM)
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
