//
//  MyPageModalView.swift
//  Grain
//
//  Created by 한승수 on 2023/01/31.
//

import SwiftUI

struct MyPageOptionView: View {
    let optionMenu = ["프로필 편집", "카메라 정보", "저장됨", "로그아웃"]
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(alignment: .leading){
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("마이페이지")
                }
                .padding(.horizontal)
            })
            .accentColor(.black)
            
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
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .font(.title2)
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.vertical)
            }
            
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
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .font(.title2)
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.bottom)
            }
            
            NavigationLink {
                EditMyPageView()
            } label: {
                HStack {
                    Image(systemName: "bookmark")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .aspectRatio(contentMode: .fit)
                        .padding(.trailing)
                    Text("저장됨")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .font(.title2)
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.bottom)
            }
            
            NavigationLink {
                EditMyPageView()
            } label: {
                HStack {
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .aspectRatio(contentMode: .fit)
                        .padding(.trailing)
                    Text("로그아웃")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .font(.title2)
                .foregroundColor(.black)
                .padding(.horizontal)
            }
            Spacer()
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
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
