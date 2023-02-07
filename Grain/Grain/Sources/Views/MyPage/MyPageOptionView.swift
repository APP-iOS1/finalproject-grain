//
//  MyPageModalView.swift
//  Grain
//
//  Created by 한승수 on 2023/01/31.
//

import SwiftUI

struct MyPageOptionView: View {
//    let optionMenu = ["프로필 편집", "카메라 정보", "저장됨", "로그아웃"]
    @Environment(\.presentationMode) var presentationMode
    @StateObject var authVM = AuthenticationStore()
//    @StateObject var communityVM: CommunityViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            
            //MARK: 상단바
            HStack{
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("마이페이지")
                    }
                    .padding(.horizontal)
                })
                
                Spacer()
                
                Text("설정")
                    .font(.title3)
                    .bold()
                    .padding(.trailing, 125)
            
                Spacer()
            }
            .accentColor(.black)
            
            //MARK: 계정 섹션
            VStack(alignment: .leading, spacing: 10){
                Text("계정")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)
                    .padding(.top)
                
                NavigationLink {
                    EditMyPageView()
                } label: {
                    HStack {
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .aspectRatio(contentMode: .fit)
                            .padding(.trailing)
                        Text("프로필 편집")
                            .font(.title3)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .font(.title2)
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
                            .resizable()
                            .frame(width: 20, height: 20)
                            .aspectRatio(contentMode: .fit)
                            .padding(.trailing)
                        Text("나의 장비 정보")
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
                
                NavigationLink {
                    BookmarkedMagazine()
                } label: {
                    HStack {
                        Image(systemName: "bookmark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .aspectRatio(contentMode: .fit)
                            .padding(.trailing)
                        Text("저장된 매거진")
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
                
                NavigationLink {
//                    BookmarkedCommunityView(communityVM: communityVM.communities)
                } label: {
                    HStack {
                        Image(systemName: "bookmark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .aspectRatio(contentMode: .fit)
                            .padding(.trailing)
                        Text("저장된 커뮤니티 글")
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
            
            //MARK: 지원 섹션
            VStack(alignment: .leading, spacing: 10){
                Text("지원")
                    .font(.title2)
                    .bold()
                    .padding()
                
                NavigationLink {
                    Text("고객센터")
                } label: {
                    HStack {
                        Image(systemName: "bookmark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .aspectRatio(contentMode: .fit)
                            .padding(.trailing)
                        Text("고객센터")
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
                
                NavigationLink {
                    Text("피드백")
                } label: {
                    HStack {
                        Image(systemName: "envelope")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .aspectRatio(contentMode: .fit)
                            .padding(.trailing)
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
            
            //MARK: 정보 섹션
            VStack(alignment: .leading, spacing: 10){
                Text("정보")
                    .font(.title2)
                    .bold()
                    .padding()
                
                NavigationLink {
                    Text("이용약관")
                } label: {
                    HStack {
                        Image(systemName: "doc")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .aspectRatio(contentMode: .fit)
                            .padding(.trailing)
                        Text("이용약관")
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
                
                NavigationLink {
                    Text("개인 정보 처리방침")
                } label: {
                    HStack {
                        Image(systemName: "shield")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .aspectRatio(contentMode: .fit)
                            .padding(.trailing)
                        Text("개인 정보 처리방침")
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
                
                Button {
                    authVM.googleLogout()
                } label: {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .aspectRatio(contentMode: .fit)
                            .padding(.trailing)
                        Text("로그아웃")
                            .font(.title3)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                }
                .padding(.horizontal)

            }
            

//            NavigationLink {
//                EditMyPageView()
//            } label: {
//                HStack {
//                    Image(systemName: "person")
//                        .resizable()
//                        .frame(width: 20, height: 20)
//                        .aspectRatio(contentMode: .fit)
//                        .padding(.trailing)
//                    Text("로그아웃")
//                    Spacer()
//                    Image(systemName: "chevron.right")
//                }
//                .font(.title2)
//                .foregroundColor(.black)
//                .padding(.horizontal)
//            }
            Spacer()
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
//        .onAppear {
//            // 커뮤니티 데이터 fetch
//            communityVM.fetchCommunity()
//        }
    }
}

struct MyPageOptionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MyPageOptionView()
        }
    }
}

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
