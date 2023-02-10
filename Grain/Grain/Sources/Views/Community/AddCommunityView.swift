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

    var myCamera = ["camera1", "camera2", "camera3", "camera4"]
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color(UIColor.systemGray5))
                .frame(width: Screen.maxWidth, height: 1)
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
            
            HStack{
                Picker("Tab", selection: $selectedTab){
                    ForEach(CommunityTabs.allCases){ tab in
                        Text(tab.rawValue)
                    }
                }
                .colorMultiply(.black)
                Spacer()
            }
            
            Rectangle()
                .fill(Color(UIColor.systemGray5))
                .frame(width: Screen.maxWidth * 0.95, height: 1)
            
            TextField("글 제목", text: $inputTitle)
                .keyboardType(.asciiCapable)
                .textContentType(.init(rawValue: ""))
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .padding(.horizontal, 15)
                .onSubmit {
                    hideKeyboard()
                }
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
            
            Rectangle()
                .fill(Color(UIColor.systemGray5))
                .frame(width: Screen.maxWidth * 0.95, height: 1)
            
            TextField("내용을 작성해 주세요.", text: $inputContent, axis: .vertical)
                .keyboardType(.alphabet)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .lineLimit(...25)
                .padding(.horizontal, 15)
                .onSubmit {
                    hideKeyboard()
                }
            Spacer()
        }
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
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    //글쓰기 함수
//                    communityVM.insertCommunity(profileImage: "profileImage", nickName: "nickName", category: selectedTab.rawValue, image: "image", userID: "userID", title: inputTitle, content: inputContent)
//                    communityVM.fetchCommunity()
                    presented.toggle()
                } label: {
                    Text("완료")
                    .foregroundColor(.black)
                    .bold()
                }
            }
        }
    }
}
//struct AddCommunityView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddCommunityView(presented: .constant(false))
//    }
//}
