//
//  NearbyPostsComponent.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/03.
//

import SwiftUI
import Kingfisher

struct NearbyPostsComponent: View {
    @State var isliked : Bool = false
    @Binding var visitButton : Bool
    @Binding var isShowingPhotoSpot : Bool
    var  nearbyMagazineData : [MagazineDocument]    // 값을 받아옴
    @Binding var clikedMagazineData : MagazineDocument?
    @Binding var showResearchButton : Bool
    
    @StateObject var userVM = UserViewModel()
    
    var body: some View {
        
        ScrollView(.horizontal) {
            HStack{
//                ForEach(nearbyMagazineData,id: \.self) { item in
//                        RoundedRectangle(cornerRadius: 15)
//                            .foregroundColor(.white)
//                            .frame(width:Screen.maxWidth * 0.75, height: Screen.maxHeight * 0.14)
//                            .overlay{
//                                VStack{
//                                    HStack{
//                                        Spacer()
//                                        Image(systemName: "x.circle")
//                                            .foregroundColor(.black)
//    //                                        .position(CGPoint(x: Screen.maxWidth * 0.7 , y: Screen.maxHeight * 0.07))
//                                            .padding(.trailing,5)
//                                            .padding(.top, 5)
//                                            .onTapGesture {
//                                                isShowingPhotoSpot = false
//                                                showResearchButton.toggle()
//                                            }
//                                    }
//
//                                    HStack{
//                                        Spacer()
//                                        KFImage(URL(string: item.fields.image.arrayValue.values[0].stringValue) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fit)
//                                            .cornerRadius(15)
//                                            .offset(y: -10)
//                                        Spacer()
//                                        VStack(alignment: .leading){
//                                            Text(item.fields.title.stringValue)
//                                                .lineLimit(2)   // 적용이 될지
//                                                .fontWeight(.bold)
//                                                .font(.system(size: 16))
//                                            // MAKR: 취소 버트
//                                            Text(item.fields.customPlaceName.stringValue)
//                                                .font(.system(size: 9))
//                                                .foregroundColor(.gray)
//
//                                            HStack{
//
//                                                NavigationLink {
//                                                    MagazineDetailView(userVM: userVM, currentUsers: userVM.currentUsers, data: item)
//                                                }  label: {
//                                                    RoundedRectangle(cornerRadius: 10)
//                                                        .stroke(Color(.black),lineWidth: 2)
//                                                        .foregroundColor(.black)
//                                                        .frame(width: 80,height: 25)
//                                                        .overlay{
//                                                            Image(systemName:"pin.fill")
//                                                                .foregroundColor(.black)
//                                                                .font(.system(size: 13))
//                                                                .offset(x: -27)
//                                                            Text("보러가기")
//                                                                .foregroundColor(.black)
//                                                                .font(.system(size: 13))
//                                                                .offset(x: 6)
//
//                                                        }.padding(.trailing, 5)
//                                                        .onTapGesture {
//                                                            // MARK: Bool 값을 넘겨 지도 상에서 디테일 뷰 보여주기
//                                                            clikedMagazineData = item
//                                                            isShowingPhotoSpot = false
//                                                            visitButton.toggle()
//
//                                                        }
//                                                }
//
//                                            }
//                                        }
//                                        Spacer()
//                                    }
//
//                                }
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(.black, lineWidth: 2)
//                                    .frame(width: Screen.maxWidth * 0.75, height: Screen.maxWidth * 0.3)
//
//                            }
//                            .padding()
//
//                }
                
            }
        }
        
    }
    
    
}
