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
    
    @State private var showModal: Bool = false
    @State private var inputTitle: String = ""
    @State private var inputContent: String = ""
    @State private var inputCustomPlace: String = ""
    @State private var selectedImages: [UIImage] = []
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
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var showingSelectBodyAlert: Bool = false
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @FocusState private var focusField: Fields?
    
    var userLatitude: Double
    var userLongitude: Double

    @State var selectedCamera: String = ""
    @State var selectedLense: String = ""
    @State var selectedFilm: String = ""
    
    
    var body: some View {
        /// 지도뷰로 이동하기 위해 전체적으로 걸어줌
        ///NavigationStack으로 걸어주면 앱이 폭팔하길래 NavigationView 변경
            GeometryReader { geo in
                VStack {
                    Divider()
                    HStack {
                        if selectedImages.count < 5 {
                            PhotosPicker(
                                selection: $selectedItems, maxSelectionCount: 5,selectionBehavior: .ordered ,
                                matching: .images) {
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: 100, height: 100)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.middlebrightGray, lineWidth: 1)
                                        )
                                        .overlay {
                                            VStack {
                                                Spacer()
                                                Image(systemName: "camera.fill")
                                                    .font(.title3)
                                                    .foregroundColor(.black)
                                                Text("\(selectedItems.count)/5")
                                                    .font(.footnote)
                                                    .foregroundColor(.gray)
                                                    .padding(.top, 5)
                                                    .monospacedDigit()
                                                Spacer()
                                            }
                                        }
                                        .padding(.leading)
                                }
                                .onChange(of: selectedItems) { newItem in
                                    Task {
                                        selectedImages = []
                                        
                                        for value in newItem {
                                            if let imageData = try? await value.loadTransferable(type: Data.self),
                                               let image = UIImage(data: imageData) {
                                                selectedImages.append(image)
                                            }
                                        }
                                    }
                                }
                        }
                        // MARK: 선택한 이미지를 보여주는 부분
                        ScrollView(.horizontal) {
                            HStack {
                                // MARK: 이미지 선택 버튼 우측으로 이미지 정렬
                                ForEach(Array(selectedImages.enumerated()), id: \.1.self) { (index, item) in
                                    GeometryReader { geometry in
                                        Rectangle()
                                            .fill(.white)
                                            .frame(width: 100, height: 100)
                                            .overlay {
                                                if index == 0 {
                                                    Image(uiImage: item)
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
                                                            if selectedItems.count == selectedImages.count{
                                                                selectedItems.remove(at: index)
                                                                selectedImages.remove(at: index)
                                                            }else{
                                                                print("삭제 실패")
                                                            }
                                                        }
                                                }
                                                else{
                                                    Image(uiImage: item)
                                                        .resizable()
                                                        .cornerRadius(15)
                                                    
                                                    Image(systemName: "x.circle.fill")
                                                        .position(CGPoint(x: geometry.size.width-2, y: 8))
                                                        .onTapGesture {
                                                            if selectedItems.count == selectedImages.count{
                                                                selectedItems.remove(at: index)
                                                                selectedImages.remove(at: index)
                                                            }else{
                                                                print("삭제 실패")
                                                            }
                                                        }
                                                }
                                                
                                            }
                                    }.frame(width: 100, height: 100)
                                    
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    
                    Divider()
                    

                    HStack {
                        Button {
                            showModal.toggle()
                        } label: {
                            HStack {
                                Text("장비선택하기")
                                    .foregroundColor(.black)
                                    .font(.subheadline)
                                    .bold()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                            }
                        }
                        .padding(.horizontal)
                        .sheet(isPresented: $showModal) {
                            ItemListView(userVM: userVM, selectedCamera: $selectedCamera, selectedLense: $selectedLense, selectedFilm: $selectedFilm)
                                .presentationDetents([.medium, .large])
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 6)

                    
                    Divider()
                    
                    // MARK: 게시물 제목 작성 란
                    TextField("필름의 제목을 입력해주세요", text: $inputTitle)
                        .font(.body)
                        .bold()
                        .keyboardType(.default)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .padding(.horizontal)
                        .onSubmit {
                            hideKeyboard()
                        }
                        .submitLabel(.done)
                        .padding(.vertical, 6)
                       
                    Divider()
                    
                    // MARK: 게시물 내용 작성 란
//                    TextField("필름에 담긴 이야기와, 설명을 기록해보세요.", text: $inputContent, axis: .vertical)
//                        .font(.body)
//                        .bold()
//                        .textInputAutocapitalization(.never)
//                        .keyboardType(.default)
//                        .disableAutocorrection(true)
//                        .lineLimit(7)
//                        .padding(.horizontal, 15)
//                        .toolbar {
//                            ToolbarItemGroup(placement: .keyboard) {
//                                Spacer()
//                                Button {
//                                    hideKeyboard()
//                                } label: {
//                                    Text("Done")
//                                        .foregroundColor(.blue)
//                                }
//                            }
//                        }
//                        .frame(height: Screen.maxHeight * 0.65, alignment: .top)
//                        .padding(.vertical, 6)
                        
                    TextEditor(text: $inputContent)
                        .frame(height: 400)
                        .lineSpacing(4.0)
                        .padding(.horizontal)
                        .overlay(
                            // Placeholder를 Text로 구현하고, text가 비어있을 때만 표시되도록 조건문 추가
                            Group {
                                if inputContent.isEmpty {
                                    Text("필름에 담긴 이야기와, 설명을 기록해보세요 📸")
                                        .foregroundColor(Color(.placeholderText))
                                        .font(.body)
                                        .bold()
                                }
                            }
                            
                        )
                        .font(.body)
                        .bold()
                    
                    
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
                    } else if selectedCamera == "" {
                        Button {
                            showingSelectBodyAlert = true
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
                        .alert(isPresented: $showingSelectBodyAlert) {
                            Alert(title: Text("알림"), message: Text("카메라 바디 선택은 필수입니다."), dismissButton: .default(Text("확인")))
                        }
                    }
                    else {
                        NavigationLink {
                            AddMarkerMapView(magazineVM: magazineVM, userVM: userVM, mapVM: mapVM, locationManager: locationManager, updateNumber: $updateNumber, updateReverseGeocodeResult1: $updateReverseGeocodeResult1,inputTitle: $inputTitle, inputContent: $inputContent, selectedImages: $selectedImages, inputCustomPlace: $inputCustomPlace, presented: $presented,selectedCamera: $selectedCamera, selectedLense: $selectedLense, selectedFilm: $selectedFilm, userLatitude: userLatitude , userLongitude: userLongitude)
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
            }
    }
}



struct SelectModalView: View {
    @ObservedObject var userVM: UserViewModel
    
    @Binding var selectedCamera: String
    @Binding var selectedLense: String
    @Binding var selectedFilm: String
    
    var body: some View {
        Form {
            Picker("바디", selection: $selectedCamera) {
                Text("없음")
                ForEach(userVM.myCamera, id: \.self) {
                    Text($0) //  2: laica 3" ㅇㄹㄴㅇㄹ 4ㅇㄹㄴㅇㄹ
                }
            }
            .pickerStyle(.inline)
            
            Picker("렌즈", selection: $selectedLense) {
                ForEach(userVM.myLens, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.inline)
            
            Picker("필름", selection: $selectedFilm) {
                ForEach(userVM.myFilm, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.inline)
            
        }
    }
    
}
