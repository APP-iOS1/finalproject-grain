//
//  NearbyPostsComponent.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/03.
//

import SwiftUI
import Kingfisher

struct NearbyPostsComponent: View {
    @ObservedObject var userVM: UserViewModel
    @ObservedObject var magazineVM: MagazineViewModel
    
    @State var ObservingChangeValueLikeNum : String = ""
    @State var isliked : Bool = false
    @Binding var visitButton : Bool
    @Binding var isShowingPhotoSpot : Bool
    var  nearbyMagazineData : [MagazineDocument] // 값을 받아옴
    @Binding var clikedMagazineData : MagazineDocument?
    @Binding var showResearchButton : Bool
    
    func errorImage() -> String{
        var https : String = "https://"
        if let infolist = Bundle.main.infoDictionary {
            if let url = infolist["ThumbnailImageError"] as? String {
                https += url
            }
        }
        return https
    }
    
    var body: some View {
        
        ScrollView(.horizontal) {
            HStack{
                ForEach(nearbyMagazineData,id: \.self) { item in
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(.white)
                            .shadow(color: .gray, radius: 5)
                            .frame(width:Screen.maxWidth * 0.75, height: Screen.maxHeight * 0.14)
                            .overlay{
                                
                                HStack{
                                    
                                    KFImage(URL(string: item.fields.image.arrayValue.values[0].stringValue) ?? URL(string: errorImage()))
                                        .resizable()
                                        .frame(width: 90, height: 90)
                                        .cornerRadius(10)
                                        .aspectRatio(contentMode: .fill)
                                        .clipped()
                                        .offset(y: -9)
                                        .padding(.leading, 20)
                                    
                                    VStack(alignment: .leading){
                                        VStack(alignment: .leading){
                                            Text(item.fields.title.stringValue)
                                                .lineLimit(2)   // 적용이 될지
                                                .fontWeight(.bold)
                                                .font(.body)
                                            // MAKR: 취소 버트
                                            Text(item.fields.customPlaceName.stringValue)
                                                .font(.footnote)
                                                .foregroundColor(.gray)
                                        }.padding(.leading,3)
                                        HStack{
//                                            Spacer()
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.black)
                                                .frame(width: 140,height: 25)
                                                .overlay{
                                                    Text("보러가기")
                                                        .foregroundColor(.white)
                                                        .font(.system(size: 13))
                                                        .fontWeight(.bold)

                                                }.padding(.trailing, 5)
                                                .onTapGesture {
                                                    // MARK: Bool 값을 넘겨 지도 상에서 디테일 뷰 보여주기
                                                    clikedMagazineData = item
                                                    isShowingPhotoSpot = false
                                                    visitButton.toggle()

                                                }
//                                            Spacer()
                                        }
                                        
                                    }
                                    .padding(.leading, 10)
                                    .padding(.bottom, 9)
                                    Spacer()
                                }
                                .padding(.top , 20)
                                    
                                
                                
                                Image(systemName: "xmark")
                                    .font(.footnote)
//                                    .foregroundColor(.black)
                                    .position(CGPoint(x: Screen.maxWidth * 0.7 , y: Screen.maxHeight * 0.015))
                                    .padding(.trailing,5)
                                    .padding(.top, 5)
                                    .onTapGesture {
                                        isShowingPhotoSpot = false
                                        showResearchButton.toggle()
                                    }
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(.black, lineWidth: 2)
//                                    .frame(width: Screen.maxWidth * 0.75, height: Screen.maxWidth * 0.3)

                            }
                            .padding()
                            
                }
                
            }
        }
        
    }
    
    
}
