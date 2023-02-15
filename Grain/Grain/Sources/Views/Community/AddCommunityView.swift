//
//  AddMagazineView.swift
//  Grain
//
//  Created by 한승수 on 2023/01/20.
//

import SwiftUI
import FirebaseAuth
import PhotosUI

struct AddCommunityView: View {
    @StateObject var communityVM : CommunityViewModel
    @StateObject var userVM = UserViewModel()
    @State private var inputTitle: String = ""
    @State private var inputContent: String = ""
    //    @State private var inputCustomPlace: String = ""
    
    @State private var selectedCamera = 0
    //    @State private var userId = Auth.auth().currentUser?.uid
    @State private var isShowingModal = false
    @State private var textFieldFocused: Bool = true
    
    @Binding var presented: Bool
    
    enum CommunityTabs: String, CaseIterable, Identifiable {
        case 매칭, 마켓, 클래스, 정보
        var id: Self { self }
    }
    @State private var selectedTab: CommunityTabs = .매칭
    
    // 이미지 앨범에서 가져오기
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var selectedImages: [UIImage] = []
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var isShowingAlert = false
    
    var myCamera = ["camera1", "camera2", "camera3", "camera4"]
    
    var body: some View {
        GeometryReader{ geo in
            VStack {
                HStack {
                    Spacer()
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
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title3)
                                            .foregroundColor(.black)
                                        Spacer()
                                        Text("사진추가")
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
                                }
                            }
                        }
                        
                    // MARK: 선택한 이미지를 보여주는 부분
                    ScrollView(.horizontal) {
                        HStack {
                            // MARK: 이미지 선택 버튼 우측으로 이미지 정렬
                            ForEach(selectedImages, id: \.self) { img in
                                Image(uiImage: img)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                //MARK: 제목과 게시물 내용 구분선
                Image("line")
                    .resizable()
                    .frame(width: Screen.maxWidth * 0.95,height: 1)
                
                //MARK: 카테고리 피커
                
                HStack {
                    Picker("Tab", selection: $selectedTab){
                        ForEach(CommunityTabs.allCases){ tab in
                            Text(tab.rawValue)
                        }
                    }
                    .font(.title)
                    .colorMultiply(.black)
                    Spacer()
                }
                
                //MARK: 제목과 게시물 내용 구분선
                Image("line")
                    .resizable()
                    .frame(width: Screen.maxWidth * 0.95,height: 1)
                
                //MARK: 게시물 제목 작성 란
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
                Rectangle()
                    .fill(Color(UIColor.systemGray5))
                    .frame(width: Screen.maxWidth * 0.95, height: 1)
                    .border(.black)
                
                // MARK: 게시물 내용 작성 란
                TextField("내용을 입력해주세요", text: $inputContent, axis: .vertical)
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
                
                //MARK: 다음 버튼
                if inputTitle.count == 0 || inputContent.count == 0 {
                    Button {
                        isShowingAlert = true
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.black)
                            .frame(width: Screen.maxWidth * 0.85, height: Screen.maxHeight * 0.07)
                            .overlay {
                                Text("작성 완료")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                    }
                    .alert(isPresented: $isShowingAlert) {
                        Alert(title: Text("알림"), message: Text("제목, 내용은 필수 입력 항목입니다."), dismissButton: .default(Text("확인")))
                        
                    }
                } else {
                    Button {
                        var data = CommunityFields(title: CommunityCategory(stringValue: inputTitle), category: CommunityCategory(stringValue: selectedTab.rawValue), content: CommunityCategory(stringValue: inputContent), profileImage: CommunityCategory(stringValue: userVM.currentUsers?.profileImage.stringValue ?? ""), introduce: CommunityCategory(stringValue: userVM.currentUsers?.introduce.stringValue ?? ""), state: CommunityCategory(stringValue: ""), nickName: CommunityCategory(stringValue: userVM.currentUsers?.nickName.stringValue ?? ""), image: CommunityImage(arrayValue: CommunityArrayValue(values: [CommunityCategory(stringValue: "")])), userID: CommunityCategory(stringValue: userVM.currentUsers?.id.stringValue ?? ""), id: CommunityCategory(stringValue: UUID().uuidString))
                        communityVM.insertCommunity(data: data, images: selectedImages)
                        presented.toggle()
                        communityVM.fetchCommunity()        // 필요한지?
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.black)
                            .frame(width: Screen.maxWidth * 0.85, height: Screen.maxHeight * 0.07)
                            .overlay {
                                Text("작성 완료")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                    }
                }
            }
            .navigationTitle("커뮤니티")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
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
//struct AddCommunityView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddCommunityView(presented: .constant(false))
//    }
//}
