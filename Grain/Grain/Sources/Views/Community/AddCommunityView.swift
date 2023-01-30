//
//  AddMagazineView.swift
//  Grain
//
//  Created by 한승수 on 2023/01/20.
//

import SwiftUI
import FirebaseAuth

struct AddCommunityView: View {
    
    @StateObject var communityVM = CommunityViewModel()
    
    @State private var inputTitle: String = ""
    @State private var inputContent: String = ""
//    @State private var inputCustomPlace: String = ""
    @State private var selectedImages: [String] = ["1", "2", "3", "editor"]
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
    
    var myCamera = ["camera1", "camera2", "camera3", "camera4"]

    var body: some View {
        VStack {
            VStack{
                HStack{
                    Button {
                        presented.toggle()
                        //글쓰기 취소
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .frame(width: 50, height: 50)
                    }
                    Spacer()
                    
                    Text("커뮤니티")
                    
                    Spacer()
                    Button {
                        //글쓰기 동작 함수
                        
                        communityVM.insertCommunity(profileImage: "profileImage", nickName: "nickName", category: selectedTab.rawValue, image: "image", userID: "userID", title: inputTitle, content: inputContent)
                        
                        presented.toggle()

                    } label: {
                        Text("글쓰기")
                            .foregroundColor(.black)
                    }
                    
                }
                .padding(.horizontal)
                
                Rectangle()
                    .fill(Color(UIColor.systemGray5))
                    .frame(width: Screen.maxWidth, height: 1)
            }
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
            
            
//            HStack {
//                Button {
//                    isShowingModal.toggle()
//                } label: {
//                    Text("장비 선택 임시 버튼")
//                }
//                .foregroundColor(.black)
//                .sheet(isPresented: $isShowingModal) {
//                    CameraLenseFilmModalView()
//                        .presentationDetents([.medium, .large])
//                }
//                Spacer()
//            }
//            .padding(.horizontal, 15)
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
        AddCommunityView(presented: .constant(false))
    }
}
