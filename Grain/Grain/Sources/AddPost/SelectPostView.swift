//
//  SelectPostView.swift
//  Grain
//
//  Created by 한승수 on 2023/02/06.
//

import SwiftUI
import NMapsMap
import PhotosUI

struct SelectPostView: View {
    
    var myCamera = ["camera1", "camera2", "camera3", "camera4"]
    @Environment(\.dismiss) private var dismiss
    
    @Binding var presented : Bool
    @StateObject var communityVM: CommunityViewModel
    @State var updateNumber : NMGLatLng
    //@Binding var modalSize: CGFloat
    var body: some View {
        NavigationView {
            VStack {
                
                Text("글쓰기 설명 text")
                                
                //MARK: 매거진 작성 네비게이션 링크
                NavigationLink {
                    MagazineContentAddView(presented: $presented, updateNumber: updateNumber)
                        .navigationBarBackButtonHidden(true)
                } label: {
                    VStack {
                        Rectangle()
                            .frame(width: Screen.maxWidth * 0.85, height: Screen.maxHeight * 0.1)
                        Text("매거진 연결")
                        Text("매거진test")
                    }
                }
                .padding(.vertical)
                
                //MARK: 커뮤니티 작성 네비게이션 링크
                NavigationLink {
                    AddCommunityView(communityVM: communityVM, presented: $presented)
                        .navigationBarBackButtonHidden(true)
                } label: {
                    VStack {
                        Rectangle()
                            .frame(width: Screen.maxWidth * 0.85, height: Screen.maxHeight * 0.1)
                        Text("커뮤니티 연결")
                        Text("커뮤니티 test")
                    }
                }
                .padding(.vertical)
                                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presented.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
            }
            //.background(Color(hex: "F58800"))
        }
    }
}

//struct SelectPostView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectPostView(presented: .constant(false), updateNumber: NMGLatLng(lat: 0, lng: 0), communityVM:)
//    }
//}
