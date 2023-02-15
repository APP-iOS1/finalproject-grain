//
//  EditMyPageView.swift
//  Grain
//
//  Created by 한승수 on 2023/01/31.
//

import SwiftUI
import Combine
import FirebaseAuth
import PhotosUI
import Kingfisher

// 텍스트 필드 포커스를 위한 열거형
private enum FocusableField: Hashable {
    case nickName
    case introduce
}

struct EditMyPageView: View {
    
    var userVM: UserViewModel
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    @State private var editedNickname = ""
    @State private var editedIntroduce = ""
    
    // 수정전 nickName
    var nickName: String {
        var nickName: String = ""
        if let currentUser = self.userVM.currentUsers {
            nickName = currentUser.nickName.stringValue
        }
        return nickName
    }
    
    // 수정전 introduce
    var introduce: String {
        var introduce: String = ""
        if let currentUser = self.userVM.currentUsers {
            introduce = currentUser.introduce.stringValue
        }
        return introduce
    }
    
    var profileImage: String {
        var profileImage: String = ""
        if let currentUser = self.userVM.currentUsers {
            profileImage = currentUser.profileImage.stringValue
        }
        return profileImage
    }
    
    let nickNameLimit = 15
    let introduceLimit = 50
    
    // 닉네임 정규식
    func checkNicknameRule(string: String) -> Bool {
        let nicknameRegex = "^[a-zA-Z0-9]{4,15}$"
        return  NSPredicate(format: "SELF MATCHES %@", nicknameRegex).evaluate(with: string)
    }
//    let regex = "^[a-zA-Z0-9]{4,15}$"
    
    @FocusState private var focus: FocusableField?
    
    // 이미지 앨범에서 가져오기
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var selectedImages: [UIImage] = []
    
    var body: some View {
        VStack {
//            //MARK: 프로필 이미지 변경 버튼
//            Button {
//                //이미지 선택 동작
//            } label: {
//                Image("2")
//                    .resizable()
//                    .frame(width: 100, height: 100)
//                    .cornerRadius(64)
//                    .overlay {
//                        Circle()
//                            .stroke(lineWidth: 1.5)
//                            .foregroundColor(.black)
//                    }
//                    .overlay {
//                        Circle()
//                            .frame(width: 30, height: 30)
//                            .foregroundColor(.white)
//                            .offset(x: Screen.maxWidth * 0.1, y: Screen.maxHeight * 0.04)
//                            .overlay {
//                                Image(systemName: "camera.circle.fill")
//                                    .resizable()
//                                    .frame(width: 26, height: 26)
//                                    .foregroundColor(.black)
//                                    .offset(x: Screen.maxWidth * 0.1, y: Screen.maxHeight * 0.04)
//                            }
//                    }
//            }
            
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()) {
                    if selectedImages.count == 0{
                        KFImage(URL(string: userVM.currentUsers?.profileImage.stringValue ?? "") ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .cornerRadius(64)
                            .overlay {
                                Circle()
                                    .stroke(lineWidth: 1.2)
                                    .foregroundColor(.black)
                            }
                            .overlay {
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                                    .offset(x: Screen.maxWidth * 0.1, y: Screen.maxHeight * 0.04)
                                    .overlay {
                                        Image(systemName: "camera.circle.fill")
                                            .resizable()
                                            .frame(width: 26, height: 26)
                                            .foregroundColor(.black)
                                            .offset(x: Screen.maxWidth * 0.1, y: Screen.maxHeight * 0.04)
                                    }
                            }
                    } else {
//                        KFImage(URL(string: userVM.currentUsers?.profileImage.stringValue ?? "") ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                        Image(uiImage: selectedImages[selectedImages.count - 1])
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(64)
                            .overlay {
                                Circle()
                                    .stroke(lineWidth: 1.2)
                                    .foregroundColor(.black)
                            }
                            .overlay {
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                                    .offset(x: Screen.maxWidth * 0.1, y: Screen.maxHeight * 0.04)
                                    .overlay {
                                        Image(systemName: "camera.circle.fill")
                                            .resizable()
                                            .frame(width: 26, height: 26)
                                            .foregroundColor(.black)
                                            .offset(x: Screen.maxWidth * 0.1, y: Screen.maxHeight * 0.04)
                                    }
                            }
                    }
        
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                        // MARK: 선택한 이미지 selectedImages배열에 넣어주기
                        if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                            selectedImages.append(uiImage)
                        }
                        
                        print("selectedImages?:\(selectedImages)")
                    }
                }
            
            //MARK: 닉네임, 소개 변경 텍스트 필드
            VStack{
                HStack {
                    Text("닉네임")
                        .padding(.horizontal, 3)
                    Spacer()
                    Text("\(editedNickname.count)/15")
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading){
                    HStack{
                        TextField("\(nickName)", text: $editedNickname)
                            .focused($focus, equals: .nickName)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .onReceive(Just(editedNickname)) { _ in
                                limitNickname(nickNameLimit)
                            }
                        
                        if (focus == .nickName) || editedNickname.count > 0 {
                            HStack{
                                Button {
                                    self.editedNickname = ""
                                } label: {
                                    Image(systemName: "x.circle.fill")
                                }
                                .tint(.gray)
                                .padding(.trailing, 7)
                                .animation(.easeInOut, value: focus)
                            }
                        }
                    }
                    .underlineTextField()
                    .padding(.bottom, 30)
                    
//                    if editedNickname.range(of: regex, options: .regularExpression) == nil {
//                        Text("맞아요")
//                            .padding(.leading)
//                            .padding(.bottom)
//                    } else {
//                        Text("틀려요")
//                            .padding(.leading)
//                            .padding(.bottom)
//                    }
                    if !editedNickname.isEmpty && checkNicknameRule(string: editedNickname) {
                        Text("올바른 형식입니다")
                            .font(.subheadline)
                            .padding(.horizontal, 20)
                            .padding(.top, -20)
                            .padding(.bottom)
                            .foregroundColor(.black)
                        
                    } else {
                        Text("영문, 숫자를 포함하여 4~15 글자로 작성해주세요")
                            .font(.subheadline)
                            .padding(.horizontal, 20)
                            .padding(.top, -20)
                            .padding(.bottom)
                            .foregroundColor(.middlebrightGray)
                    }
                }

                
                HStack {
                    Text("소개")
                        .padding(.horizontal, 3)
                    Spacer()
                    Text("\(editedIntroduce.count)/50")
                }
                .padding(.horizontal)
                
                HStack{
                    TextField("\(introduce)", text: $editedIntroduce)
                        .focused($focus, equals: .introduce)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .onReceive(Just(editedIntroduce)) { _ in
                            limitIntroduce(introduceLimit)
                        }
                    
                    if (focus == .introduce) || editedIntroduce.count > 0 {
                        HStack{
                            Button {
                                self.editedIntroduce = ""
                            } label: {
                                Image(systemName: "x.circle.fill")
                            }
                            .tint(.gray)
                            .padding(.trailing, 7)
                            .animation(.easeInOut, value: focus)
                        }
                    }
                }
                .underlineTextField()
                .padding(.bottom, 30)
            }
            
            Spacer()
            
            Button {
                print("nickName: \(nickName), editintro: \(editedIntroduce)")
            } label: {
                Text("testtest")
            }


        }
        .navigationTitle("프로필 편집")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                if (editedNickname.count > 0 || editedIntroduce.count > 0) && checkNicknameRule(string: editedNickname) {
                    Button {
                        if var currentUser = userVM.currentUsers {
                            let docID = currentUser.id.stringValue
                            currentUser.nickName.stringValue = editedNickname
                            
                            // 선택된 이미지 배열에서 마지막 요소만 반환
                            if selectedImages.count > 0{
                                selectedImages.removeSubrange(0 ..< selectedImages.count - 1)
                            }
                            userVM.updateCurrentUserProfile(profileImage: selectedImages.count > 0 ? selectedImages : [], nickName: editedNickname.count > 0 ? editedNickname : nickName, introduce: editedIntroduce.count > 0 ? editedIntroduce : "", docID: docID)

                            print("selectedImages:\(selectedImages)")
    
                            dismiss()
                        }
                    }label: {
                        Text("저장")
                            .foregroundColor(.black)
                    }
                } else {
                    Text("저장")
                        .foregroundColor(.brightGray)
                }
            }
        }
        .onAppear{
            focus = .nickName
            editedNickname = userVM.currentUsers?.nickName.stringValue ?? ""
            editedIntroduce = userVM.currentUsers?.introduce.stringValue ?? ""
            print("selectedImages:\(selectedImages)")
        }
    }
    
    func limitNickname(_ upper: Int) {
        if editedNickname.count > upper {
            editedNickname = String(editedNickname.prefix(upper))
        }
    }
    func limitIntroduce(_ upper: Int) {
        if editedIntroduce.count > upper {
            editedIntroduce = String(editedIntroduce.prefix(upper))
        }
    }
}

struct EditMyPageView_Previews: PreviewProvider {
//    @StateObject var userVM: UserViewModel = UserViewModel()
    static var previews: some View {
        NavigationStack{
            EditMyPageView(userVM: UserViewModel())
        }
    }
}


extension View {
    func underlineTextField() -> some View {
        self
            .padding(.horizontal, 10)
            .overlay(Rectangle().frame(width: Screen.maxWidth * 0.9, height: 1.3).padding(.top, 35).padding(.horizontal))
            .foregroundColor(Color(UIColor.black))
            .padding(.horizontal,10)
    }
}
