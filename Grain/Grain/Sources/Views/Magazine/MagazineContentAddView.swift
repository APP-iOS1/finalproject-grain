//
//  MagazineContentAddView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/20.
//

import SwiftUI
import NMapsMap
import PhotosUI

struct MagazineContentAddView: View {
    @State private var inputTitle: String = ""
    @State private var inputContent: String = ""
    @State private var inputCustomPlace: String = ""
    @State private var selectedImages: [UIImage] = []
    @State private var selectedCamera = 0
    @State private var isShowingModal = false
    @State private var textFieldFocused: Bool = true
    
    // 모달 내리기
    @Binding var presented : Bool
    // insert
    @ObservedObject var magazineVM = MagazineViewModel()
    @ObservedObject var storageVM = StorageViewModel()
   
    // 지도에서 좌표 값 가져오기
    @State var updateNumber : NMGLatLng
    @State var updateReverseGeocodeResult1 : String = ""
    
    // 이미지 앨범에서 가져오기
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    // 유저 데이터
    @AppStorage("docID") private var docID : String?
    @StateObject var userVM = UserViewModel()
    
    var myCamera = ["camera1", "camera2", "camera3", "camera4"]
    
    var body: some View {
        /// 지도뷰로 이동하기 위해 전체적으로 걸어줌
        ///NavigationStack으로 걸어주면 앱이 폭팔하길래 NavigationView 변경
        NavigationView{
            VStack {
                
                // MARK: 상단 기능 ( 취소, 매거진, 글쓰기 )
                VStack{
                    HStack {
                        Button {
                            presented.toggle()
                            //글쓰기 취소
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                                .frame(width: 50, height: 50)
                        }
                        Spacer()
                        // 정훈
                        VStack{
                            Text("매거진")
                        }
                        Spacer()
                        Button {
                            // MARK: 스토리지에 이미지 업로드
//                            storageVM.insertStorageImage(image: selectedImages)
                            // insert 메서드 들어가고
                            /// cameraInfo, lenseInfo, filmInfo 유저가 가지고 있는 데이터에서 패치를 하고 그거를 피커로 보여지게 만들고 그 다음에 고르면 데이터가 넘어 가게끔
                            /// userID, nickName 은 UserDB에서 가져와야 됨 -> 클리어
                            /// comment -> 임시

//                             FIXME: 스토리지 작업중 주석 풀기
                            magazineVM.insertMagazine(userID: userVM.currentUsers?.id.stringValue ?? "", cameraInfo: userVM.currentUsers?.myCamera.arrayValue.values[0].stringValue ?? "", nickName: userVM.currentUsers?.nickName.stringValue ?? "", image: selectedImages, content: inputContent , title: inputTitle , lenseInfo: userVM.currentUsers?.myLens.arrayValue.values[0].stringValue ?? "", longitude: updateNumber.lng, likedNum: 0, filmInfo: userVM.currentUsers?.myFilm.arrayValue.values[0].stringValue ?? "", customPlaceName: "패스", latitude: updateNumber.lat, comment: "임시", roadAddress: updateReverseGeocodeResult1)

                        } label: {
                            Text("글쓰기")
                                .foregroundColor(.black)
                        }
                        
                    }
                    .padding(.horizontal)
                }
                
                
                /// 상단 기능과 구분선
                Rectangle()
                    .fill(Color(UIColor.systemGray5))
                    .frame(width: Screen.maxWidth, height: 1)
                
                // MARK: 이미지 피커 쪽인거 같음 확인 필요
                VStack{
                    HStack {
                        PhotosPicker(
                            selection: $selectedItem,
                            matching: .images,
                            photoLibrary: .shared()) {
                                HStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(UIColor.systemGray4))
                                        .frame(width: 70, height: 70)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(.white)
                                                .frame(width: 68, height: 68)
                                            Image(systemName: "photo.on.rectangle")
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                                .foregroundColor(.black)
                                        }
                                }
                            }
                            // MARK: 이미지가 선택 되었을때
                            .onChange(of: selectedItem) { newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        selectedImageData = data
                                    }
                                    // MARK: 선택한 이미지 selectedImages배열에 넣어주기
                                    /// 이미지 선택 버튼 우측으로 이미지 정렬
                                    if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                                        selectedImages.append(uiImage)
                                    }
                                }
                            }
                            .frame(width: 100,height: 100)
         
                        ScrollView(.horizontal) {
                            HStack {
                                // MARK: 이미지 선택 버튼 우측으로 이미지 정렬
                                ForEach(selectedImages, id: \.self) { img in
                                    Image(uiImage: img)
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        Spacer()
                        
                    }
                    .padding(.horizontal)
                    
                    Rectangle()
                        .fill(Color(UIColor.systemGray5))
                        .frame(width: Screen.maxWidth * 0.95, height: 1)
                }
                
                // MARK: 게시물 글 제목 작성 란
                VStack{
                    Text(updateReverseGeocodeResult1)
                    TextField("글 제목", text: $inputTitle)
                        .keyboardType(.default)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .padding(.horizontal, 15)
                        .onSubmit {
                            hideKeyboard()
                        }
                    
                    Rectangle()
                        .fill(Color(UIColor.systemGray5))
                        .frame(width: Screen.maxWidth * 0.95, height: 1)
                }
           
                // MARK: 게시물 내용 작성 란
                VStack{
                    TextField("내용을 작성해 주세요.", text: $inputContent, axis: .vertical)
                        .keyboardType(.default)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .lineLimit(...25)
                        .padding(.horizontal, 15)
                        .onSubmit {
                            hideKeyboard()
                        }
                    Spacer()
                    
                    // MARK: 위치 받아온 값 ex) 경기도 화성시 석우동
                    VStack{
                        Text(updateReverseGeocodeResult1)
                            .foregroundColor(.gray)
                            .font(.caption2)
                            .offset(x: 125)
                    }
                    
                    Rectangle()
                        .fill(Color(UIColor.systemGray5))
                        .frame(width: Screen.maxWidth * 0.95, height: 1)
                }
                
                
                Group{
                    HStack {
                        Button {
                            isShowingModal.toggle()
                        } label: {
                            Text("장비 선택 임시 버튼")
                        }
                        .foregroundColor(.black)
                        .sheet(isPresented: $isShowingModal) {
                            CameraLenseFilmModalView()
                                .presentationDetents([.medium, .large])
                        }
                        Spacer()
                        ///지도뷰로 이동하기 위해 NavigationLink걸어줌
                        NavigationLink(destination: AddMarkerMapView(updateNumber: $updateNumber, updateReverseGeocodeResult1: $updateReverseGeocodeResult1)) {
                            HStack{
                                Image(systemName: "location.fill")
                                Text("위치 받아오기")
                            }.offset(x: 60) // FIXME: 위치 고치기 offset 사용 X
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading) //
                    }
                    .padding(.horizontal, 15)
                }
               
                
            }.ignoresSafeArea(.keyboard).onAppear{
                userVM.fetchCurrentUser(userID: docID ?? "")
            }
        }
        
    }
}
    //struct MagazineContentAddView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        NavigationStack {
    //            MagazineContentAddView()
    //        }
    //    }
    //}
