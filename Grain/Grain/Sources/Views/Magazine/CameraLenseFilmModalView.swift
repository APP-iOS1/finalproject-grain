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
    @State private var selectedCamera: String = ""
    @State private var selectedLense: String = ""
    @State private var selectedFilm: String = ""
    @ObservedObject var magazineVM = MagazineViewModel()
    @StateObject var userVM = UserViewModel()
    @Binding var inputTitle: String
    @Binding var inputContent: String
    @Binding var updateNumber: NMGLatLng
    @Binding var updateReverseGeocodeResult1: String

    @Binding var selectedImages: [UIImage]
    @Binding var inputCustomPlace: String
    @Binding var presented : Bool
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var selection: String?

    var body: some View {
        VStack {
            HStack {
                Spacer()
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
                    magazineVM.insertMagazine(userID: userVM.currentUsers?.id.stringValue ?? "", cameraInfo: userVM.currentUsers?.myCamera.arrayValue.values[0].stringValue ?? "", nickName: userVM.currentUsers?.nickName.stringValue ?? "", image: selectedImages, content: inputContent , title: inputTitle , lenseInfo: userVM.currentUsers?.myLens.arrayValue.values[0].stringValue ?? "", longitude: updateNumber.lng, likedNum: 0, filmInfo: userVM.currentUsers?.myFilm.arrayValue.values[0].stringValue ?? "", customPlaceName: "패스", latitude: updateNumber.lat, comment: "임시", roadAddress: updateReverseGeocodeResult1)
                    presented.toggle()

                } label: {
                    Text("완료")
                        .foregroundColor(.black)
                }
            }
            .padding(15)
            HStack {
                Spacer()
                Text("카메라 (필수)")
                Spacer()
            }
            Picker("pick camera", selection: $selectedCamera) {
                ForEach(myCamera, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(WheelPickerStyle())
            Spacer()

            Rectangle()
                .fill(Color(UIColor.systemGray5))
                .frame(width: Screen.maxWidth * 0.95, height: 1)
            Spacer()

            HStack {
                Spacer()
                Text("렌즈, 필름 (선택)")
                Spacer()
            }
            Spacer()

            HStack {
                Picker("pick lense", selection: $selectedLense) {
                    ForEach(myLense, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                
                Picker("pick film", selection: $selectedFilm) {
                    ForEach(myFilm, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
            Spacer()
        }
        .toolbar(.hidden)
        .onAppear {
            selectedCamera = myCamera[0]
            selectedLense = myLense[0]
            selectedFilm = myFilm[0]
        }
        
    }
}

//struct CameraLenseFilmModalView_Previews: PreviewProvider {
//    static var previews: some View {
//        CameraLenseFilmModalView()
//    }
//}
