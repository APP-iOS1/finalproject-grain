//
//  MagazineAddView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/20.
//

import SwiftUI

struct MagazineAddView: View {
    @Binding var isAddViewShown: Bool
    
    var body: some View {
        NavigationStack {
            VStack{
                Text("사진 올리는곳")
                
            }.toolbar {
                ToolbarItem{
                    NavigationLink {
                        MagazineContentAddView(isAddViewShown: $isAddViewShown)
                    } label: {
                        Text("다음")
                    }


                }
                ToolbarItem(placement: .navigationBarLeading){
                    Button {
                        isAddViewShown.toggle()
                    } label: {
                        Text("취소")
                    }
                }
            }
        }
    }
}

struct MagazineAddView_Previews: PreviewProvider {
    static var previews: some View {
        MagazineAddView(isAddViewShown: .constant(false))
    }
}
