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
    
    @State var ObservingChangeValueLikeNum : String = ""
    
    
    
    var body: some View {
        VStack {
            ScrollView {
                NavigationLink {
                    EditorView()
                } label: {
                    EditorViewCell()
                }
                HStack{
                    Text("인기 게시글")
                        .font(.title)
                        .fontWeight(.bold)
                    Image("line")
                        .resizable()
                        .frame(width: 240, height: 3.5)
                }
                .padding([.leading, .top])
                ForEach(magazineVM.sortedTopLikedMagazineData, id: \.self ){ data in
                    NavigationLink {
                        MagazineDetailView(magazineVM: magazineVM, userVM: userVM, data: data, ObservingChangeValueLikeNum: $ObservingChangeValueLikeNum)
                    } label: {
                        
                        LazyVStack{
                            Top10View(data: data)
                                .padding(.vertical, 7)
                                .padding(.horizontal)
                            
                        }
                        
                    }
                }
            }
            .task(id: ObservingChangeValueLikeNum){
               Task{
                   await magazineVM.fetchMagazine()
               }
           }
            
        }//vstack
        
    }
}

//struct MagazineBestView_Previews: PreviewProvider {
//    static var previews: some View {
//        MagazineBestView()
//    }
//}
