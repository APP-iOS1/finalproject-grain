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
    
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var communityVM : CommunityViewModel
    @ObservedObject var magazineVM : MagazineViewModel
    @ObservedObject var mapVM : MapViewModel
    @ObservedObject var locationManager : LocationManager
    
    var myCamera = ["camera1", "camera2", "camera3", "camera4"]
    @Environment(\.dismiss) private var dismiss
    
    @Binding var presented : Bool
    
    @State var updateNumber : NMGLatLng

    @State var isShowSheet: Bool = true
    
    var userLatitude : Double
    var userLongitude : Double
    
    var body: some View {
        NavigationView {
            VStack {
                
                Text("나의 추억을 사람들과 공유해보세요")
                    .font(.title)
                    .bold()
                    .frame(width: Screen.maxWidth * 0.85, alignment: .topLeading)
                                             
                //MARK: 매거진 작성 네비게이션 링크
                NavigationLink {
                    MagazineContentAddView(magazineVM: magazineVM, userVM: userVM,mapVM: mapVM, locationManager: locationManager, presented: $presented, updateNumber: updateNumber, userLatitude: userLatitude , userLongitude: userLongitude)
                        .navigationBarBackButtonHidden(true)
                } label: {
                    VStack {
                        Rectangle()
                            .fill(Color(hex: "1d1d1b"))
                            .frame(width: Screen.maxWidth * 0.85, height: Screen.maxHeight * 0.2)
                            .shadow(radius: 12)
                            .overlay {
                                VStack {
                                    Text("나의 필름 공유하기")
                                        .foregroundColor(.white)
                                        .font(.title2)
                                        .bold()
                                    Text("내가 찍은 필름의 정보와 장소를 공유해보세요")
                                        .foregroundColor(.white)
                                        .font(.body)
                                        .padding(.top)
                                }
                            }
                    }
                }
                .padding(.vertical)
                .sheet(isPresented: $isShowSheet) {
                    AddCameraView(userVM: userVM)
                        .presentationDetents([.medium, .large])
                }
                
                //MARK: 커뮤니티 작성 네비게이션 링크
                NavigationLink {
                    AddCommunityView(communityVM: communityVM, userVM: userVM, presented: $presented)
                        .navigationBarBackButtonHidden(true)
                } label: {
                    VStack {
                        Rectangle()
                            .fill(Color(hex: "1d1d1b"))
                            .frame(width: Screen.maxWidth * 0.85, height: Screen.maxHeight * 0.2)
                            .shadow(radius: 12)
                            .overlay {
                                VStack {
                                    Text("커뮤니티 작성하기")
                                        .foregroundColor(.white)
                                        .font(.title2)
                                        .bold()
                                    Text("사람들과 이야기를 나눠보세요")
                                        .foregroundColor(.white)
                                        .font(.body)
                                        .padding(.top)
                                }
                            }
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("GRAIN")
                        .font(.title)
                        .bold()
                        .kerning(7)
                }
            }
            .frame(width: Screen.maxWidth, height: Screen.maxHeight)
            .background(LinearGradient(gradient: Gradient(colors: [.white, Color(UIColor.systemGray3)]), startPoint: .top, endPoint: .bottom))

        }
    }
}

//struct SelectPostView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectPostView(presented: .constant(false), updateNumber: NMGLatLng(lat: 0, lng: 0), communityVM:)
//    }
//}
