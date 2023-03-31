//
//  AuthenticationView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/18.
//

import SwiftUI

import GoogleSignInSwift
import FirebaseAuth
import _AuthenticationServices_SwiftUI
import Kingfisher
import PhotosUI
import Combine


private enum FocusableField: Hashable {
    case title
    case content
    case nickName
    case introduce
}

struct AuthenticationView: View {
    @EnvironmentObject var authenticationStore: AuthenticationStore
    @ObservedObject var userVM : UserViewModel
    @Environment(\.colorScheme) var colorScheme
    
    @FocusState private var focus: FocusableField?
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var selectedImages: [UIImage] = []
    
    @State private var editedNickname = ""
    @State private var editedIntroduce = ""
    
    @State private var nickName = ""
    @State private var introduce = ""
    
    @State private var exceptCurrentUser: [UserDocument] = []
    
    // 닉네임 정규식
    func checkNicknameRule(string: String) -> Bool {
        let nicknameRegex = "^[a-zA-Z0-9]{4,15}$"
        return  NSPredicate(format: "SELF MATCHES %@", nicknameRegex).evaluate(with: string)
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
    
    let nickNameLimit = 15
    let introduceLimit = 50
    
    
    var body: some View {
        Group{
            switch authenticationStore.authenticationState {
            case .freshman:
                VStack(alignment: .center){
                    // MARK: - 프로필 사진 설정
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            if selectedImages.count == 0{
                                KFImage(URL(string: "https://firebasestorage.googleapis.com/v0/b/grain-final.appspot.com/o/EditorFolder%2FdefaultImage%2Fdefault-user-icon-8.jpg?alt=media&token=1a514506-df59-484f-affb-b000ad1f348d" ?? "") ?? URL(string: "https://firebasestorage.googleapis.com/v0/b/grain-final.appspot.com/o/EditorFolder%2FdefaultImage%2Fdefault-user-icon-8.jpg?alt=media&token=1a514506-df59-484f-affb-b000ad1f348d"))
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
                        .padding(.bottom , 30)
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
                    // MARK: - 닉네임, 자기소개 설정
                    VStack{
                        HStack {
                            Text("닉네임")
                                .padding(.horizontal, 3)
                                .fontWeight(.bold)
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
                            Text("자기소개")
                                .padding(.horizontal, 3)
                                .fontWeight(.bold)
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
                    
                    // MARK: - 결정 버튼
                    Spacer()
                    if (editedNickname.count > 0 || editedIntroduce.count > 0) && checkNicknameRule(string: editedNickname) && !exceptCurrentUser.contains{$0.fields.nickName.stringValue == editedNickname}{
                        Button {
                            // 유저 DB에 데이터 넣기
                            userVM.insertUser(myFilm: "필름 중 하나를 선택해 주세요", bookmarkedMagazineID: "", email: authenticationStore.email, myCamera: "카메라 중 하나를 선택해 주세요", postedCommunityID: "", postedMagazineID: "", likedMagazineId: "", lastSearched: "", bookmarkedCommunityID: "", recentSearch: "", id: authenticationStore.userUID, following: "", myLens: "렌즈 중 하나를 선택해 주세요", profileImage: selectedImages, name: authenticationStore.userName , follower: "", nickName: editedNickname, introduce: editedIntroduce, fcmToken: "")
                            // 로그인 상태값 바꾸기
                            authenticationStore.authenticationState = .authenticated
                        } label: {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.black)
                                .frame(width: Screen.maxWidth * 0.85, height: Screen.maxHeight * 0.07)
                                .overlay {
                                    Text("회원가입하기")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                        }
                    }
                    
                }
                .onAppear{
                    exceptCurrentUser = userVM.users.filter{$0.fields.id.stringValue != userVM.currentUsers?.id.stringValue}
                }
                .padding()
                .navigationTitle("회원가입")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            authenticationStore.authenticationState = .unauthenticated
                        } label: {
                            Image(systemName: "xmark")
                        }

                    }
                    
                }
            case .unauthenticated , .authenticating :
                VStack{
                    Spacer()
                    Text("GRAIN")
                        .font(.largeTitle)
                        .bold()
                        .kerning(7)
                    Spacer()
                        .frame(maxHeight: Screen.maxHeight * 0.25 )
                    VStack(alignment: .leading) {
                        Text("환영해요!")
                            .font(.title)
                            .fontWeight(.semibold)

                        Text("로그인해서 Grain과의 여정을 시작하세요.")
                    }
                    .padding(.bottom)
                    // MARK: - 애플 로그인
                    SignInWithAppleButton { request in
                        authenticationStore.hadleSignInwithAppleRequest(request)
                    } onCompletion: { result in
                        authenticationStore.handleSignInWithAppleCompletion(result)
                    }
                    .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
                    .frame(width: Screen.maxWidth * 0.8, height: Screen.maxHeight * 0.06)
                    .padding(.bottom, 7)

                    // MARK: - 구글 로그인
                    Button {
                        authenticationStore.googleLogin()

                    } label: {
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(lineWidth: 1.3)
                            .foregroundColor(.gray)
                            .overlay{
                                ZStack {
                                    HStack{
                                        Image("googleLogo")
                                            .resizable()
                                            .cornerRadius(4)
                                            .aspectRatio(contentMode: .fit)
                                            .padding([.top,.leading, .bottom], 10)
                                            .padding(.trailing, 3)
                                        Text("Sign in with Google")
                                            .font(.subheadline)
                                            .foregroundColor(.middleDarkGray)
                                            .bold()

                                        Spacer()

                                    }
                                }
                            }

                    }
                    .frame(width: Screen.maxWidth * 0.8, height: Screen.maxHeight * 0.06)
                    .padding(.bottom, 7)
                    Spacer()
                }
            case .authenticated:
                VStack{
                    
                }
            }
            
        }
        
    }
}

//struct AuthenticationView_Previews: PreviewProvider {
//    static var previews: some View {
//        AuthenticationView()
//    }
//}
