//
//  MagazineContentAddView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/20.
//

import SwiftUI
import NMapsMap
import PhotosUI
import FirebaseAuth

struct MagazineContentAddView: View {
    @State private var inputTitle: String = ""
    @State private var inputContent: String = ""
    @State private var inputCustomPlace: String = ""
    @State private var selectedImages: [UIImage] = []
    @State private var selectedCamera = 0
    @State private var isShowingModal = false
    @State private var textFieldFocused: Bool = true
    @State private var showingAlert = false
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
    
    @StateObject var userVM = UserViewModel()
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var myCamera = ["camera1", "camera2", "camera3", "camera4"]
    
    var body: some View {
        /// 지도뷰로 이동하기 위해 전체적으로 걸어줌
        ///NavigationStack으로 걸어주면 앱이 폭팔하길래 NavigationView 변경
        NavigationView{
            VStack {
                Rectangle()
                    .fill(Color(UIColor.systemGray5))
                    .frame(width: Screen.maxWidth, height: 1)
                // MARK: 이미지 피커 쪽인거 같음 확인 필요
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
                }
                .padding(.horizontal)
                
                Rectangle()
                    .fill(Color(UIColor.systemGray5))
                    .frame(width: Screen.maxWidth * 0.95, height: 1)
                
                // MARK: 게시물 제목 작성 란
                //Text(updateReverseGeocodeResult1)
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
                
                // MARK: 게시물 내용 작성 란
                TextField("내용을 작성해 주세요.", text: $inputContent, axis: .vertical)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.default)
                    .disableAutocorrection(true)
                    .lineLimit(...25)
                    .padding(.horizontal, 15)
                    .onSubmit {
                        hideKeyboard()
                    }
                Spacer()
            }
            .navigationTitle("글쓰기")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                    Button {
                        self.mode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .bold()
                    }

                }
                if selectedImages.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAlert = true
                        } label: {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.black)
                                .bold()
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("알림"), message: Text("최소 1장 이상의 사진을 업로드하세요."), dismissButton: .default(Text("확인")))
                        }
                    }
                } else {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            AddMarkerMapView(updateNumber: $updateNumber, updateReverseGeocodeResult1: $updateReverseGeocodeResult1, inputTitle: $inputTitle, inputContent: $inputContent, selectedImages: $selectedImages, inputCustomPlace: $inputCustomPlace, presented: $presented)
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.black)
                                .bold()
                        }
                    }
                }
            }
            .onAppear {
                userVM.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
            }
            
        }
    }
}
struct MagazineContentAddView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationStack {
            MagazineContentAddView(presented: .constant(false), updateNumber: NMGLatLng(lat: 0, lng: 0))
        }
    }
}
