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
    
    @Binding var presented : Bool
    @StateObject var communityVM: CommunityViewModel
    @State var updateNumber : NMGLatLng
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0){
                
                //MARK: 게시글 선택 뷰 취소 버튼
                HStack {
                    Button {
                        presented.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .frame(width: 50, height: 50)
                    }
                    Spacer()
                }
                
                Spacer()
                
                
                Text("게시물선택 임시텍스트")
                
                Spacer()
                
                HStack {
                    NavigationLink {
                        MagazineContentAddView(presented: $presented, updateNumber: updateNumber)
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(.white)
                            .frame(width: Screen.maxWidth / 2,  height: Screen.maxHeight / 4)
                            .shadow(radius: 12)
                            .overlay {
                                VStack {
                                    Text("매거진")
                                        .foregroundColor(.black)
                                    Image(systemName: "film")
                                        .resizable()
                                        .frame(width: Screen.maxWidth / 4, height: Screen.maxHeight / 8)
                                        .foregroundColor(.black)
                                }
                            }
                    }

                    NavigationLink {
                        AddCommunityView(communityVM: communityVM, presented: $presented)
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(.white)
                            .frame(width: Screen.maxWidth / 2,  height: Screen.maxHeight / 4)
                            .shadow(radius: 12)
                            .overlay {
                                VStack {
                                    Text("커뮤니티")
                                        .foregroundColor(.black)
                                    Image(systemName: "text.bubble")
                                        .resizable()
                                        .frame(width: Screen.maxWidth / 4, height: Screen.maxHeight / 8)
                                        .foregroundColor(.black)
                                }
                            }
                    }
                }
                Spacer()
            }
        }
    }
}
//
//struct SelectPostView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectPostView(presented: .constant(false), updateNumber: NMGLatLng(lat: 0, lng: 0), communityVM: <#CommunityViewModel#>)
//    }
//}
