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
    @State private var isShowSheet : Bool = false
    @State var checkUseButton : Bool = false
    @State var checkPersonalButton : Bool = false
    
    @AppStorage("authenticationState") var authenticationState: AuthenticationState = .unauthenticated
    @AppStorage("logInCompanyState") var logInCompanyState: LogInCompanyState = .noCompany
    
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
            switch authenticationState {
                
            case .freshman:
                VStack(alignment: .center){
                    
                    VStack(alignment: .leading){
                        HStack{
                            Text("닉네임을")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        HStack{
                            Text("입력해주세요.")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                        }

                    }
                    .padding(.top , 10)
                    .padding(.bottom , 30)
                    .padding(.leading, 15)
                    // MARK: - 닉네임, 자기소개 설정
                    VStack{
                        HStack {
                            Text("닉네임")
                                .padding(.horizontal, 3)
                                .fontWeight(.bold)
                            Spacer()
//                            Text("\(editedNickname.count)/15")
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
                            if editedNickname.isEmpty{
                                Text("")
                            }
                            else if editedNickname == nickName || !editedNickname.isEmpty && checkNicknameRule(string: editedNickname) && !exceptCurrentUser.contains{$0.fields.nickName.stringValue == editedNickname}{
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
//                            Text("\(editedIntroduce.count)/50")
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
                    
                
                    Text(" \(Image(systemName: "info.circle")) 이 정보는 다른 사용자들과 함께 활동하시는 동안 보여집니다.")
                        .font(.footnote)
                        .foregroundColor(.middlebrightGray)
                        .padding(.bottom, 20)
                
                
                    VStack(alignment: .leading){
                        // MARK: 이용약관
                        HStack{
                            Button {
                                checkUseButton.toggle()
                            } label: {
                                if checkUseButton {
                                    Image(systemName: "checkmark.seal.fill").foregroundStyle(.black)
                                    
                                }else{
                                    Image(systemName: "checkmark.seal").foregroundColor(.gray)
                                }
                            }.font(.subheadline)
                            Text("GRAIN 이용약관 동의")
                                .font(.subheadline)
                            Text("(필수)")
                                .font(.footnote)
                                .fontWeight(.bold)
                            Spacer()
                            NavigationLink {
                                TermsofUseView()
                            } label: {
                                Text("보러가기 >")
                                    .font(.footnote)
                                    .foregroundColor(.middlebrightGray)
                            }
                        }
                        .padding(.bottom, 5)
                        // MARK: 개인정보 방치
                        HStack{
                            Button {
                                checkPersonalButton.toggle()
                            } label: {
                                if checkPersonalButton {
                                    Image(systemName: "checkmark.seal.fill").foregroundStyle(.black)
                                }else{
                                    Image(systemName: "checkmark.seal").foregroundColor(.gray)
                                }
                            }.font(.subheadline)
                            Text("개인정보 처리방침 동의")
                                .font(.subheadline)
                            Text("(필수)")
                                .font(.footnote)
                                .fontWeight(.bold)
                            Spacer()
                            NavigationLink {
                                PersonalInformationProcessingView()
                            } label: {
                                Text("보러가기 >")
                                    .font(.footnote)
                                    .foregroundColor(.middlebrightGray)
                            }
                            
                        }
                    }
                    
                    // MARK: - 결정 버튼
                    Spacer()

                        Button {
                            // 유저 DB에 데이터 넣기
                            userVM.insertUser(myFilm: "필름은 선택사항입니다.", bookmarkedMagazineID: "", email: authenticationStore.email, myCamera: "카메라 바디는 필수 선택입니다 :)", postedCommunityID: "", postedMagazineID: "", likedMagazineId: "", lastSearched: "", bookmarkedCommunityID: "", recentSearch: "", id: authenticationStore.userUID, following: "", myLens: "렌즈는 선택사항입니다.", profileImage: selectedImages, name: authenticationStore.userName , follower: "", nickName: editedNickname, introduce: editedIntroduce, fcmToken: "", blocking: "", blocked: "")
                            // 로그인 상태값 바꾸기
                            authenticationState = .authenticated
//                            authenticationStore.addToken()
                        } label: {
                            RoundedRectangle(cornerRadius: 12)
                                .fill((editedNickname.count > 0 || editedIntroduce.count > 0) && checkNicknameRule(string: editedNickname) && !exceptCurrentUser.contains{$0.fields.nickName.stringValue == editedNickname } && checkUseButton &&  checkPersonalButton ? .black : .gray)
                                .frame(width: Screen.maxWidth * 0.85, height: Screen.maxHeight * 0.07)
                                .overlay {
                                    Text("회원가입하기")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                        }
                        .disabled( (editedNickname.count > 0 || editedIntroduce.count > 0) && checkNicknameRule(string: editedNickname) && !exceptCurrentUser.contains{$0.fields.nickName.stringValue == editedNickname } && checkUseButton &&  checkPersonalButton ? false : true )
                }
                .sheet(isPresented: $isShowSheet) {
                    TermsofUseView()
                        .presentationDetents([.medium])
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
                            .padding(.bottom, -5)
                        Text("여러분의 특별한 순간을 함께 공유해보세요!")
                            .fontWeight(.semibold)
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
                                    HStack(alignment: .center){
                                        Image("googleLogo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                        Text("Sign in with Google")
                                            .font(.headline)
                                            .foregroundColor(.middleDarkGray)
                                            .bold()
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
