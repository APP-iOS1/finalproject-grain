//
//  MyPageModalView.swift
//  Grain
//
//  Created by 한승수 on 2023/01/31.
//

import SwiftUI

struct MyPageOptionView: View {
//    let optionMenu = ["프로필 편집", "카메라 정보", "저장됨", "로그아웃"]
//    @Environment(\.presentationMode) var presentationMode
//    @StateObject var authVM = AuthenticationStore()
    var userVM: UserViewModel
    var bookmarkedMagazineDocument: [MagazineDocument]
    
    @StateObject var communityVM: CommunityViewModel = CommunityViewModel()
    
    var body: some View {
        VStack(alignment: .leading){
            
            //MARK: 상단바
//            HStack{
//                Button(action: {
//                    presentationMode.wrappedValue.dismiss()
//                }, label: {
//                    HStack {
//                        Image(systemName: "chevron.left")
//                        Text("마이페이지")
//                    }
//                    .padding(.horizontal)
//                })
//
//                Spacer()
//
//                Text("설정")
//                    .font(.title3)
//                    .bold()
//                    .padding(.trailing, 125)
//
//                Spacer()
//            }
//            .accentColor(.black)
            
            ScrollView{
                //MARK: 계정 섹션
                AccountSection(userVM: userVM, community: communityVM.communities, bookmarkedMagazineDocument: bookmarkedMagazineDocument)
                
                //MARK: 지원 섹션
                SupportSection()
                
                //MARK: 정보 섹션
                InfoSection()
                    .padding(.bottom)
            }
            Spacer()
        }
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarHidden(true)
//        .navigationBarBackButtonHidden(true)
        .onAppear {
            // 커뮤니티 데이터 fetch
            communityVM.fetchCommunity()
        }
    }
}

//struct MyPageOptionView_Previews: PreviewProvider {    
//    static var previews: some View {
//        NavigationStack {
//            MyPageOptionView()
//        }
//    }
//}

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

//MARK: - 계정 섹션
struct AccountSection: View {
    var userVM: UserViewModel
    var community: [CommunityDocument]
    var bookmarkedMagazineDocument: [MagazineDocument]

    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Text("계정")
                .font(.title2)
                .bold()
                .padding(.horizontal)
                .padding(.top)
                .padding(.leading, 5)
            
            NavigationLink {
                EditMyPageView(userVM: userVM)
            } label: {
                HStack() {
                    Image(systemName: "person")
                        .font(.system(size: 25))
                        .padding(.trailing, 10)
                    
                    Text("프로필 편집")
                        .font(.title3)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.title3)
                }
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.vertical)
            }
            .padding(.horizontal)
            
            NavigationLink {
                EditCameraView()
            } label: {
                HStack {
                    Image(systemName: "camera")
                        .font(.system(size: 20))
                        .padding(.trailing, 10)
                    
                    Text("나의 장비 정보")
                        .font(.title3)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.title3)
                }
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding(.horizontal)
            
            NavigationLink {
                BookmarkedMagazine(bookmarkedMagazineDocument: bookmarkedMagazineDocument)
            } label: {
                HStack {
                    Image(systemName: "bookmark")
                        .font(.system(size: 22))
                        .padding(.leading, 2.8)
                        .padding(.trailing, 13)
                    
                    Text("저장된 매거진")
                        .font(.title3)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.title3)
                }
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding(.horizontal)
            
            NavigationLink {
                BookmarkedCommunityView(community: community)
            } label: {
                HStack {
                    Image(systemName: "bookmark")
                        .font(.system(size: 22))
                        .padding(.leading, 2.8)
                        .padding(.trailing, 13)
                    
                    Text("저장된 커뮤니티 글")
                        .font(.title3)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.title3)
                }
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding(.horizontal)
        }
    }
}

//MARK: - 지원 섹션
struct SupportSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Text("지원")
                .font(.title2)
                .bold()
                .padding()
                .padding(.leading, 5)
            
            NavigationLink {
                Text("고객센터")
            } label: {
                HStack {
                    Image(systemName: "message")
                        .font(.system(size: 19))
                        .padding(.leading, 3)
                        .padding(.trailing, 11)
                    
                    //                            .resizable()
                    //                            .frame(width: 20, height: 20)
                    //                            .aspectRatio(contentMode: .fit)
                    //                            .padding(.trailing)
                    Text("고객센터")
                        .font(.title3)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding(.horizontal)
            
            NavigationLink {
                Text("피드백")
            } label: {
                HStack {
                    Image(systemName: "envelope")
                        .font(.system(size: 19))
                        .padding(.leading, 3)
                        .padding(.trailing, 12)
                    //                            .resizable()
                    //                            .frame(width: 20, height: 20)
                    //                            .aspectRatio(contentMode: .fit)
                    //                            .padding(.trailing)
                    Text("피드백")
                        .font(.title3)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .font(.title2)
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding(.horizontal)
        }
    }
}

//MARK: - 정보 섹션
struct InfoSection: View {
    @ObservedObject var authVM: AuthenticationStore = AuthenticationStore()
    @ObservedObject var kakoAuthVM: KakaoAuthenticationStore = KakaoAuthenticationStore()

    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Text("정보")
                .font(.title2)
                .bold()
                .padding()
                .padding(.leading, 5)
            
            NavigationLink {
                TermsOfServiceView()
            } label: {
                HStack {
                    Image(systemName: "doc")
                        .font(.system(size:22))
                        .padding(.leading, 3.6)
                        .padding(.trailing, 14)
                    
                    Text("이용약관")
                        .font(.title3)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.title3)
                    
                }
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding(.horizontal)
            
            NavigationLink {
                PrivacyPolicyView()
            } label: {
                HStack {
                    Image(systemName: "shield")
                        .font(.system(size:23))
                        .padding(.leading, 2.9)
                        .padding(.trailing, 14)
                    
                    Text("개인 정보 처리방침")
                        .font(.title3)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.title3)
                }
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding(.horizontal)
            
            Button {
                if authVM.logInCompanyState == .appleLogIn {
                    authVM.appleLogout()
                } else if authVM.logInCompanyState == .googleLogIn {
                    authVM.googleLogout()
                } else if authVM.logInCompanyState == .kakaoLogIn {
                    kakoAuthVM.kakaoLogOut()
                } else {
                    authVM.appleLogout()
                    authVM.googleLogout()
                    kakoAuthVM.kakaoLogOut()
                }
            } label: {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size:20))
                        .padding(.leading, 5.5)
                        .padding(.trailing, 12)
                    
                    Text("로그아웃")
                        .font(.title3)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.title3)
                }
                .foregroundColor(.black)
                .padding(.horizontal)
            }
            .padding(.horizontal)
            
        }
    }
}
