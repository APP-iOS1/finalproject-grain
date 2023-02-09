//
//  CameraLenseFilmModalView.swift
//  Grain
//
//  Created by 한승수 on 2023/01/20.
//

import SwiftUI
import NMapsMap
struct CameraLenseFilmModalView: View {
    
    var myCamera = ["camera1asdasdasd", "camera2", "camera3"]
    var myLense = ["lenseA", "lenseB", "lenseC","lense1", "lense2", "lense3"]
    var myFilm = ["film1", "film2", "film3", "film4"]
    
    @ObservedObject var magazineVM = MagazineViewModel()
    @StateObject var userVM = UserViewModel()
    
    @State private var selectedCamera: String? = ""
    @State private var selectedLense: String? = ""
    @State private var selectedFilm: String? = ""
    
    @Binding var inputTitle: String
    @Binding var inputContent: String
    @Binding var updateNumber: NMGLatLng
    @Binding var updateReverseGeocodeResult1: String
    @Binding var selectedImages: [UIImage]
    @Binding var inputCustomPlace: String
    @Binding var presented : Bool
    @AppStorage("docID") private var docID : String?
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var selection: String?
    var body: some View {
        VStack {
            //MARK:
            Rectangle()
                .fill(Color(UIColor.systemGray5))
                .frame(width: Screen.maxWidth, height: 1)
            
            HStack {
                Image("cameraBody")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Screen.maxWidth * 0.1, height: Screen.maxHeight * 0.1)
                Text("카메라 바디")
                    .bold()
                    .padding()
            }
            .padding(.horizontal)
            if userVM.currentUsers?.myCamera.arrayValue.values == [] {
                //카메라 바디없을때 보여줄 뷰
                Text("등록된카메라없음")
            } else {
                Picker("카메라 바디 선택", selection: $selectedCamera) {
                    ForEach(userVM.currentUsers?.myCamera.arrayValue.values ?? [], id: \.self) {
                        Text($0.stringValue)
                    }
                }.pickerStyle(.wheel)
//                List(userVM.currentUsers?.myCamera.arrayValue.values ?? [], id: \.self, selection: $selectedCamera) { camera in
//                    Text(camera.stringValue)
//                }
//                .listStyle(.plain)
//                Spacer()
            }
            
            Divider()
            
            HStack {
                Image("cameraLens")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Screen.maxWidth * 0.1, height: Screen.maxHeight * 0.1)
                Text("렌즈")
                    .bold()
                    .padding(.leading)
            }
            .padding(.horizontal)
            
            if userVM.currentUsers?.myLens.arrayValue.values == [] {
                //필름없을때 보여줄 뷰
            } else {
                Picker("카메라 렌즈 선택", selection: $selectedLense) {
                    ForEach(userVM.currentUsers?.myLens.arrayValue.values ?? [], id: \.self) {
                        Text($0.stringValue)
                    }
                }.pickerStyle(.wheel)
//                List(userVM.currentUsers?.myLens.arrayValue.values ?? [], id: \.self, selection: $selectedLense) { lense in
//                    Text(lense.stringValue)
//                }
//                .listStyle(.plain)
//                Spacer()
            }
            
            
            Divider()
            
            HStack {
                Image(systemName: "film.stack.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Screen.maxWidth * 0.1, height: Screen.maxHeight * 0.1)
                Text("필름")
                    .bold()
                    .padding(.leading)
            }
            .padding(.horizontal)
            
            if userVM.currentUsers?.myFilm.arrayValue.values == [] {
                //렌즈없을때 보여줄 뷰
            } else {
                Picker("카메라 필름 선택", selection: $selectedFilm) {
                    ForEach(userVM.currentUsers?.myFilm.arrayValue.values ?? [], id: \.self) {
                        Text($0.stringValue)
                    }
                }.pickerStyle(.wheel)
//                List(userVM.currentUsers?.myFilm.arrayValue.values ?? [], id: \.self, selection: $selectedFilm) { film in
//                    Text(film.stringValue)
//                }
//                .listStyle(.plain)
//                Spacer()
            }
            
        }
        .navigationTitle("내장비")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                Button {
                    self.mode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .bold()
                        .opacity(1)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {

                    //MARK: 글쓰기 완료 액션
                    // data.field에 데이터 저장
                    var docId = UUID().uuidString
                    
                    var data: MagazineFields = MagazineFields(filmInfo: MagazineString(stringValue: ""),
                                                              id: MagazineString(stringValue: docId),
                                                              customPlaceName: MagazineString(stringValue: ""),
                                                              longitude: MagazineLocation(doubleValue: 0.0),
                                                              title: MagazineString(stringValue: " "),
                                                              comment: MagazineComment(arrayValue: MagazineArrayValue(values: [])),
                                                              lenseInfo: MagazineString(stringValue: ""),
                                                              userID: MagazineString(stringValue: ""),
                                                              image: MagazineComment(arrayValue: MagazineArrayValue(values: [])),
                                                              likedNum: LikedNum(integerValue: "0"),
                                                              latitude: MagazineLocation(doubleValue: 0.0),
                                                              content: MagazineString(stringValue: ""),
                                                              nickName: MagazineString(stringValue: ""),
                                                              roadAddress: MagazineString(stringValue: ""),
                                                              cameraInfo: MagazineString(stringValue: ""))
           
                    
                    data.id.stringValue = docId
                    data.userID.stringValue = userVM.currentUsers?.id.stringValue ?? ""
                    data.filmInfo.stringValue = userVM.currentUsers?.myFilm.arrayValue.values[0].stringValue ?? ""
                    data.customPlaceName.stringValue = "패스"
                    data.title.stringValue = inputTitle
                    data.content.stringValue = inputContent
                    data.cameraInfo.stringValue = userVM.currentUsers?.myCamera.arrayValue.values[0].stringValue ?? ""
                    data.filmInfo.stringValue = userVM.currentUsers?.myFilm.arrayValue.values[0].stringValue ?? ""
                    data.lenseInfo.stringValue = userVM.currentUsers?.myLens.arrayValue.values[0].stringValue ?? ""
                    data.likedNum.integerValue = "0"
                    data.longitude.doubleValue = updateNumber.lng
                    data.latitude.doubleValue = updateNumber.lat
                    data.nickName.stringValue = userVM.currentUsers?.nickName.stringValue ?? ""
                    data.roadAddress.stringValue = updateReverseGeocodeResult1
                    
                    // FIXME: 이부분 나중에 여기서 배열 처리 해야함.. !
                    data.comment.arrayValue = MagazineArrayValue(values: [])
                    data.image.arrayValue = MagazineArrayValue(values: [])
                    
                    // insertMagazine 호출
                    magazineVM.insertMagazine(data: data, images: selectedImages)

                    presented.toggle()
                } label: {
                    Text("완료")
                        .foregroundColor(.black)
                        .opacity(1)
                }
            }
        }
        .onAppear {
            userVM.fetchCurrentUser(userID: docID ?? "")
            //            selectedCamera = myCamera[0]
            //            selectedLense = myLense[0]
            //            selectedFilm = myFilm[0]
        }
        
    }
}

//struct CameraLenseFilmModalView_Previews: PreviewProvider {
//    static var previews: some View {
//        CameraLenseFilmModalView()
//    }
//}
