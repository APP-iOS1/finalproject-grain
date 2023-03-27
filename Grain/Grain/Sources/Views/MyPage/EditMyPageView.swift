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
    @State private var editedNickname = ""
    @State private var editedIntroduce = ""
    
    var userVM: UserViewModel
    //본인 이외의 사용자들의 정보 필터링한 값을 담는 변수
    @State private var exceptCurrentUser: [UserDocument] = []
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    
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
    
    @FocusState private var focus: FocusableField?
    
    // 이미지 앨범에서 가져오기
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var selectedImages: [UIImage] = []
    
    var body: some View {
        VStack {
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()) {
                    if selectedImages.count == 0{
                        KFImage(URL(string: userVM.currentUsers?.profileImage.stringValue ?? "") ?? URL(string: "https://firebasestorage.googleapis.com/v0/b/grain-final.appspot.com/o/EditorFolder%2FdefaultImage%2Fdefault-user-icon-8.jpg?alt=media&token=1a514506-df59-484f-affb-b000ad1f348d"))
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
                
                    if editedNickname == nickName || !editedNickname.isEmpty && checkNicknameRule(string: editedNickname) && !exceptCurrentUser.contains{$0.fields.nickName.stringValue == editedNickname}{
                        Text("올바른 형식입니다")
                            .font(.subheadline)
                            .padding(.horizontal, 20)
                            .padding(.top, -20)
                            .padding(.bottom)
                            .foregroundColor(.black)
                        
                    } else if !editedNickname.isEmpty && exceptCurrentUser.contains{$0.fields.nickName.stringValue == editedNickname} {
                        Text("중복된 닉네임입니다")
                            .font(.subheadline)
                            .padding(.horizontal, 20)
                            .padding(.top, -20)
                            .padding(.bottom)
                            .foregroundColor(.red)
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
        }
        .navigationTitle("프로필 편집")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                if (editedNickname.count > 0 || editedIntroduce.count > 0) && checkNicknameRule(string: editedNickname) && !exceptCurrentUser.contains{$0.fields.nickName.stringValue == editedNickname} {
                    Button {
                        if var currentUser = userVM.currentUsers {
                            let docID = currentUser.id.stringValue
                            currentUser.nickName.stringValue = editedNickname
                            
                            // 선택된 이미지 배열에서 마지막 요소만 반환
                            if selectedImages.count > 0{
                                selectedImages.removeSubrange(0 ..< selectedImages.count - 1)
                            }
                            userVM.updateCurrentUserProfile(profileImage: selectedImages.count > 0 ? selectedImages : [], nickName: editedNickname.count > 0 ? editedNickname : nickName, introduce: editedIntroduce.count > 0 ? editedIntroduce : "", docID: docID)
    
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
            exceptCurrentUser = userVM.users.filter{$0.fields.id.stringValue != userVM.currentUsers?.id.stringValue}
        }
        .onDisappear{
            userVM.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
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


