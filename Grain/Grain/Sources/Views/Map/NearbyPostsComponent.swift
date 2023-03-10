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
    
    @StateObject var userVM = UserViewModel()
    
    var body: some View {
        
        ScrollView(.horizontal) {
            HStack(){
                ForEach(nearbyMagazineData,id: \.self) { item in
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(.white)
                            .frame(width:Screen.maxWidth * 0.75, height: Screen.maxHeight * 0.14)
                            .overlay{
                                VStack{
                                    HStack{
                                        Image(systemName: "x.circle")
                                            .foregroundColor(.black)
                                            .position(CGPoint(x: Screen.maxWidth * 0.715 , y: Screen.maxHeight * 0.02))
                                            .onTapGesture {
                                                isShowingPhotoSpot.toggle()
                                            }
                                        KFImage(URL(string: item.fields.image.arrayValue.values[0].stringValue) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .cornerRadius(15)
                                            .frame(width:Screen.maxWidth * 0.25 ,height: Screen.maxHeight * 0.25)
                                        
                                        VStack(alignment: .leading){
                                            Text(item.fields.title.stringValue)
                                                .lineLimit(2)   // 적용이 될지
                                                .fontWeight(.bold)
                                                .font(.system(size: 16))
                                            // MAKR: 취소 버트
                                            Text(item.fields.customPlaceName.stringValue)
                                                .font(.system(size: 9))
                                                .foregroundColor(.gray)
                                            
                                            HStack{
                                                Button{
                                                    isliked.toggle()
                                                } label: {
                                                    if isliked {
                                                        Image(systemName: "heart.fill")
                                                            .foregroundColor(.red)
                                                            .font(.title2)
                                                    } else {
                                                        Image(systemName: "heart")
                                                            .foregroundColor(.black)
                                                            .font(.title2)
                                                    }
                                                }
                                                
                                                
                                                NavigationLink {
                                                    MagazineDetailView(userVM: userVM, currentUsers: userVM.currentUsers, data: item)
                                                }  label: {
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(Color(.black),lineWidth: 2)
                                                        .foregroundColor(.black)
                                                        .frame(width: 80,height: 25)
                                                        .overlay{
                                                            Image(systemName:"pin.fill")
                                                                .foregroundColor(.black)
                                                                .font(.system(size: 13))
                                                                .offset(x: -27)
                                                            Text("보러가기")
                                                                .foregroundColor(.black)
                                                                .font(.system(size: 13))
                                                                .offset(x: 6)
                                                            
                                                        }.padding(.trailing, 5)
                                                        .onTapGesture {
                                                            // MARK: Bool 값을 넘겨 지도 상에서 디테일 뷰 보여주기
                                                            clikedMagazineData = item
                                                            isShowingPhotoSpot.toggle()
                                                            visitButton.toggle()
                                                            
                                                        }
                                                }
                                                
                                            }
                                        }
                                        .padding()
                                    }
                                    .frame(width: Screen.maxWidth * 0.75, height: Screen.maxWidth * 0.3)
                                }
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black, lineWidth: 2)
                                
                            }.padding()

                }
                
            }
        }
        
    }
    
    
}


//struct NearbyPostsComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        NearbyPostsComponent()
//    }
//}
