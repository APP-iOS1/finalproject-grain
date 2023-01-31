//
//  MagazineFeedView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/20.
//

import SwiftUI

struct MagazineFeedView: View {
    
//    var index : [MagazineDTO]
    @ObservedObject var magazineVM = MagazineViewModel()
    
    var body: some View {
        
        ScrollView{
            LazyVStack{
                ForEach(magazineVM.magazines, id: \.self){ index in
                    MagazineViewCell(index: index)
                }
                
            }
        }.onAppear{
            magazineVM.fetchMagazine()
        }
    }
}
//
//struct MagazineFeedView_Previews: PreviewProvider {
//    static var previews: some View {
//        MagazineFeedView()
//    }
//}
