//
//  AddMagazineView.swift
//  Grain
//
//  Created by 한승수 on 2023/01/20.
//

import SwiftUI

struct AddCommunityView: View {
    @State private var inputTitle: String = ""
    @State private var inputContent: String = ""
    @State private var inputCustomPlace: String = ""
    @State private var selectedImages: [String] = ["1", "2", "3", "editor"]
    @State private var selectedCamera = 0
    @State private var isShowingModal = false
    @State private var textFieldFocused: Bool = true
    
    var myCamera = ["camera1", "camera2", "camera3", "camera4"]

    var body: some View {
        VStack {
            Rectangle()
                .fill(Color(UIColor.systemGray5))
                .frame(width: Screen.maxWidth, height: 1)
            
            HStack {
                Button {
                    //MARK: 사진선택 동작 함수
                    // 사진을 선택하면 선택한 사진이 selectedImages 배열으로
                } label: {
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
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(selectedImages, id: \.self) { img in
                            Image(img)
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
            
            Rectangle()
                .fill(Color(UIColor.systemGray5))
                .frame(width: Screen.maxWidth * 0.95, height: 1)
            
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
            }
            .padding(.horizontal, 15)
//            TextField("customePlaceName", text: $inputCustomPlace)
//                .keyboardType(.default)
//                .textInputAutocapitalization(.never)
//                .disableAutocorrection(true)
//                .padding(.horizontal, 15)
//                .onSubmit {
//                    hideKeyboard()
//                }

            Spacer()
            
        }
        .ignoresSafeArea(.keyboard)
    }}

struct AddCommunityView_Previews: PreviewProvider {
    static var previews: some View {
        AddCommunityView()
    }
}
