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

    @State var isShowSheet: Bool = false
    
    var userLatitude : Double
    var userLongitude : Double
    
    var body: some View {
        NavigationView {
            VStack {
                
//                Text("나만의 필름 감성을 공유해보세요!")
//                    .font(.title)
//                    .bold()
//                    .frame(width: Screen.maxWidth * 0.85, alignment: .topLeading)
                                             
                //MARK: 매거진 작성 네비게이션 링크
                NavigationLink {
                    MagazineContentAddView(magazineVM: magazineVM, userVM: userVM,mapVM: mapVM, locationManager: locationManager, presented: $presented, updateNumber: updateNumber, userLatitude: userLatitude , userLongitude: userLongitude)
                        .navigationBarBackButtonHidden(true)
                } label: {
                    VStack {
                        Rectangle()
                            .fill(Color(hex: "1d1d1b"))
                            .frame(width: Screen.maxWidth * 0.9, height: Screen.maxHeight * 0.3)
                            .cornerRadius(15)
                            .shadow(radius: 12)
                            .overlay {
                                VStack {
                                    Text("나의 필름 공유하기 🎞️")
                                        .foregroundColor(.white)
                                        .font(.title2)
                                        .bold()
                                    Text("나만의 감성을 담은 필름사진과 함께 이야기를 남겨보세요!")
                                        .foregroundColor(.white)
                                        .font(.body)
                                        .padding(.top)
                                }
                            }
                    }
                }
                .padding(.vertical, 20)
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
                            .frame(width: Screen.maxWidth * 0.9, height: Screen.maxHeight * 0.3)
                            .shadow(radius: 12)
                            .cornerRadius(15)
                            .overlay {
                                VStack {
                                    Text("커뮤니티 작성하기🗣️")
                                        .foregroundColor(.white)
                                        .font(.title2)
                                        .bold()
                                    Text("사진을 사랑하는 사람들의 모임! 카메라 중고거래, 사진작가와 모델 매칭, 필름카메라 정보 등 다양한 주제로 소통해보세요.")
                                        .foregroundColor(.white)
                                        .font(.body)
                                        .padding(.top)
                                }
                            }
                    }
                }
                .padding(.vertical)
                                
            }
//            .background(Color.black)
            .onAppear {
                if userVM.myCamera.count <= 1 {
                    isShowSheet = true
                }
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
