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
    
    @ObservedObject var magazineVM : MagazineViewModel
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var mapVM : MapViewModel
    @ObservedObject var locationManager : LocationManager
    
    @State private var inputTitle: String = ""
    @State private var inputContent: String = ""
    @State private var inputCustomPlace: String = ""
    @State private var selectedImages: [UIImage] = []
    @State private var selectedCamera = 0
    @State private var isShowingModal = false
    @State private var textFieldFocused: Bool = true
    @State private var showingAlert = false
    @State private var pickImageCount : Int = 0
    // 모달 내리기
    @Binding var presented : Bool
    // insert
    
    // 지도에서 좌표 값 가져오기
    @State var updateNumber : NMGLatLng
    @State var updateReverseGeocodeResult1 : String = ""
    
    // 이미지 앨범에서 가져오기
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var selectedItems: [PhotosPickerItem] = []
    // 유저 데이터
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var myCamera = ["camera1", "camera2", "camera3", "camera4"]
    @FocusState private var focusField: Fields?
    
    var userLatitude: Double
    var userLongitude: Double
    
    var body: some View {
        /// 지도뷰로 이동하기 위해 전체적으로 걸어줌
        ///NavigationStack으로 걸어주면 앱이 폭팔하길래 NavigationView 변경
        NavigationView{
            GeometryReader { geo in
                VStack {
                    HStack {
                        if pickImageCount < 5 {
                            PhotosPicker(
                                selection: $selectedItem,
                                matching: .images,
                                photoLibrary: .shared()) {
                                    Rectangle()
                                        .fill(.white)
                                        .border(.gray)
                                        .frame(width: 100, height: 100)
                                        .overlay {
                                            VStack {
                                                Spacer()
                                                Image(systemName: "camera.fill")
                                                    .font(.title3)
                                                    .foregroundColor(.black)
                                                Spacer()
                                                Text("\(pickImageCount)/5")
                                                    .font(.headline)
                                                    .foregroundColor(.black)
                                                Spacer()
                                            }
                                        }
                                        .padding(.leading)
                                }
                                .onChange(of: selectedItem) { newItem in
                                    Task {
                                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                            selectedImageData = data
                                        }
                                        // MARK: 선택한 이미지 selectedImages배열에 넣어주기
                                        /// 이미지 선택 버튼 우측으로 이미지 정렬
                                        if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                                            selectedImages.append(uiImage)
                                            pickImageCount = selectedImages.count
                                        }
                                    }
                                }
                        }
                        // MARK: 선택한 이미지를 보여주는 부분
                        ScrollView(.horizontal) {
                            HStack {
                                // MARK: 이미지 선택 버튼 우측으로 이미지 정렬
                                ForEach(selectedImages.indices, id: \.self) { index in
                                    GeometryReader { geometry in
                                        
                                        Rectangle()
                                            .fill(.white)
                                            .frame(width: 100, height: 100)
                                            .overlay {
                                                if index == 0 {
                                                    Image(uiImage: selectedImages[index])
                                                        .resizable()
                                                        .cornerRadius(15)
                                                        
                                                    Rectangle()
                                                        .overlay {
                                                            Text("대표 사진")
                                                                .font(.caption)
                                                                .fontWeight(.bold)
                                                                .foregroundColor(.white)
                                                        }
                                                        .frame(height: geometry.size.width/4)
                                                        .position(CGPoint(x: geometry.size.width/2, y: geometry.size.height-13))
                                                        .cornerRadius(15)
                                                    Image(systemName: "x.circle.fill")
                                                        .position(CGPoint(x: geometry.size.width-2, y: 8))
                                                        .onTapGesture {
                                                            selectedImages.remove(at: index)
                                                            pickImageCount = selectedImages.count
                                                        }
                                                }
                                                else{
                                                    Image(uiImage: selectedImages[index])
                                                        .resizable()
                                                        .cornerRadius(15)
                                                       
                                                    Image(systemName: "x.circle.fill")
                                                        .position(CGPoint(x: geometry.size.width-2, y: 8))
                                                        .onTapGesture {
                                                            selectedImages.remove(at: index)
                                                            pickImageCount = selectedImages.count
                                                        }
                                                }

                                            }
                                    }.frame(width: 100, height: 100)
                                   
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top)
                    
                    //MARK: 제목과 게시물 내용 구분선
                    Image("line")
                        .resizable()
                        .frame(width: Screen.maxWidth * 0.95,height: 1)
                        .padding(.top)
                    
                    // MARK: 게시물 제목 작성 란
                    TextField("제목을 입력해주세요", text: $inputTitle)
                        .font(.title3)
                        .keyboardType(.default)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .padding(.horizontal, 15)
                        .onSubmit {
                            hideKeyboard()
                        }
                        .submitLabel(.done)
                    
                    //MARK: 제목과 게시물 내용 구분선
                    Image("line")
                        .resizable()
                        .frame(width: Screen.maxWidth * 0.95,height: 1)
                    
                    // MARK: 게시물 내용 작성 란
                    TextField("소중한 추억을 기록해주세요", text: $inputContent, axis: .vertical)
                        .font(.title3)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.default)
                        .disableAutocorrection(true)
                        .lineLimit(7)
                        .padding(.horizontal, 15)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button {
                                    hideKeyboard()
                                } label: {
                                    Text("Done")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .frame(height: Screen.maxHeight * 0.4, alignment: .top)
                    
                    
                    Spacer()
                    //MARK: 다음버튼
                    if selectedImages.count == 0 || inputTitle.count == 0 || inputContent.count == 0 {
                        Button {
                            showingAlert = true
                        } label: {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.black)
                                .frame(width: Screen.maxWidth * 0.85, height: Screen.maxHeight * 0.07)
                                .overlay {
                                    Text("다음")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("알림"), message: Text("제목, 내용, 사진은 필수 입력 항목입니다."), dismissButton: .default(Text("확인")))
                        }
                    } else {
                        NavigationLink {
                            AddMarkerMapView(magazineVM: magazineVM, userVM: userVM, mapVM: mapVM, locationManager: locationManager, updateNumber: $updateNumber, updateReverseGeocodeResult1: $updateReverseGeocodeResult1,inputTitle: $inputTitle, inputContent: $inputContent, selectedImages: $selectedImages, inputCustomPlace: $inputCustomPlace, presented: $presented, userLatitude: userLatitude , userLongitude: userLongitude)
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.black)
                                .frame(width: Screen.maxWidth * 0.85, height: Screen.maxHeight * 0.07)
                                .overlay {
                                    Text("다음")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                        }
                    }
                } //vstack
                
                .navigationTitle("나의 필름 공유하기")
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
                }
                .onAppear {
                    userVM.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
                }
                //.ignoresSafeArea(.keyboard)
            }
        }
    }
}
//struct MagazineContentAddView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        NavigationStack {
//            MagazineContentAddView(presented: .constant(false), updateNumber: NMGLatLng(lat: 0, lng: 0))
//        }
//    }
//}
