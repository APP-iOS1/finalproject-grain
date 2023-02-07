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
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("어떤 글을 작성하시겠습니까?")
                    .font(.title)
                    .bold()
                                
                NavigationLink {
                    MagazineContentAddView(presented: $presented, updateNumber: updateNumber)
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Image("magazineSelect")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(12)
                        .shadow(radius: 2)
                        .overlay {
                            VStack(alignment: .leading) {
                                Spacer()
                                Text("매거진 작성하기")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .bold()
                                    .opacity(1)
                                    .shadow(radius: 1)
                                Text("에디터가 되어 사람들과 공유해보세요")
                                    .font(.callout)
                                    .foregroundColor(.white)
                                    .bold()
                                    .opacity(1)
                                    .shadow(radius: 1)
                                Spacer()
                            }
                        }
                }
                .frame(width: Screen.maxWidth, height: Screen.maxHeight * 0.2)
                
                Spacer()
                    .frame(height: Screen.maxHeight * 0.05)
                NavigationLink {
                    AddCommunityView(communityVM: communityVM, presented: $presented)
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Image("communitySelect")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(12)
                        .shadow(radius: 2)
                        .overlay {
                            VStack(alignment: .leading) {
                                Spacer()
                                Text("커뮤니티 작성하기")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .bold()
                                    .opacity(1)
                                    .shadow(radius: 1)
                                Text("사람들을 만나고 의견을 공유해보세요")
                                    .font(.callout)
                                    .foregroundColor(.white)
                                    .bold()
                                    .opacity(1)
                                    .shadow(radius: 1)
                                Spacer()
                            }
                        }
                }
                .frame(width: Screen.maxWidth, height: Screen.maxHeight * 0.2)
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presented.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

//struct SelectPostView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectPostView(presented: .constant(false), updateNumber: NMGLatLng(lat: 0, lng: 0), communityVM:)
//    }
//}
