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
    @State private var selectedCamera: String? = ""
    @State private var selectedLense: String? = ""
    @State private var selectedFilm: String? = ""
    @ObservedObject var magazineVM = MagazineViewModel()
    @StateObject var userVM = UserViewModel()
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
                    //MARK: 글쓰기 완료 함수
//                    magazineVM.insertMagazine(userID: "1", cameraInfo: "1", nickName: "1", image: selectedImages, content: "1", title: "1", lenseInfo: "1", longitude: 0.0, likedNum: 0, filmInfo: "1", customPlaceName: "1", latitude: 0.0, comment: "1", roadAddress: "1")
                    magazineVM.insertMagazine(
                        userID: userVM.currentUsers?.id.stringValue ?? "",
                        cameraInfo: userVM.currentUsers?.myCamera.arrayValue.values[0].stringValue ?? "",
                        nickName: userVM.currentUsers?.nickName.stringValue ?? "",
                        image: selectedImages,
                        content: inputContent,
                        title: inputTitle ,
                        lenseInfo: userVM.currentUsers?.myLens.arrayValue.values[0].stringValue ?? "",
                        longitude: updateNumber.lng,
                        likedNum: 0,
                        filmInfo: userVM.currentUsers?.myFilm.arrayValue.values[0].stringValue ?? "",
                        customPlaceName: "패스",
                        latitude: updateNumber.lat,
                        comment: "임시",
                        roadAddress: updateReverseGeocodeResult1 ?? "")
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
