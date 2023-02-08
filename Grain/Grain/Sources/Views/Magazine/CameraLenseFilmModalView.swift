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
        VStack(alignment: .leading) {
            Rectangle()
                .fill(Color(UIColor.systemGray5))
                .frame(width: Screen.maxWidth, height: 1)
            
            Text("카메라 바디")
                .bold()
                .padding(.leading)
            List(myCamera, id: \.self, selection: $selectedCamera) { camera in
                Text(camera)
            }
            .listStyle(.plain)
            Divider()
            Text("렌즈")
                .bold()
                .padding(.leading)
            List(myLense, id: \.self, selection: $selectedLense) { lense in
                Text(lense)
            }
            .listStyle(.plain)
            Divider()
            Text("필름")
                .bold()
                .padding(.leading)
            List(myFilm, id: \.self, selection: $selectedFilm) { film in
                Text(film)
            }
            .listStyle(.plain)
        }
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
