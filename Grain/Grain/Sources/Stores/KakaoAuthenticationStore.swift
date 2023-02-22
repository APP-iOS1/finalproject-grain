//
//  KakaoAuthenticationStore.swift
//  Grain
//
//  Created by 조형구 on 2023/01/31.
//

import Foundation
import SwiftUI

import Firebase
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon



final class KakaoAuthenticationStore: ObservableObject {
    @ObservedObject private var authenticationStore: AuthenticationStore = AuthenticationStore()
    
    /// PodFile - Firebase SDK 제거 -> 필요시 사용하기  ( 2022.02.22 / 정훈 )
    //MARK: - KaKao logIn
//    func kakaoSignIn(){
//        // 카카오톡 실행 가능 여부 확인
//        if (UserApi.isKakaoTalkLoginAvailable()) {
//            UserApi.shared.loginWithKakaoTalk { [self](oauthToken, error) in
//                if let error = error {
//                    print(error)
//                }
//                else {
//                    print("loginWithKakaoTalk() success.")
//
//                    //do something
//                    if let token = oauthToken {
//                        print("kakao token: \(token)")
//                        //fireStore data 넣을부분
//                        fetchingFirebase()
//                    }
//
//
//
//                }
//            }
//        } else {
//            UserApi.shared.loginWithKakaoAccount { [self](oauthToken, error) in
//                if let error = error {
//                    print(error)
//                }
//                else {
//                    print("loginWithKakaoAccount() success.")
//                    if let token = oauthToken {
//                        print("kakao token: \(token)")
//                        //fireStore data 넣을부분
//                        fetchingFirebase()
//                    }
//                    //do something
//                    //                    _ = oauthToken
//                    self.authenticationStore.authenticationState = .authenticating
//                    self.authenticationStore.logInCompanyState = .kakaoLogIn
//
//                }
//            }
//        }
//    }
    
    /// PodFile - Firebase SDK 제거 -> 필요시 사용하기  ( 2022.02.22 / 정훈 )
//    func fetchingFirebase(){
//        UserApi.shared.me() {(user, error) in
//            if let error = error {
//                print(error)
//            }
//            else {
//                print("me() success.")
//
//                Auth.auth().createUser(withEmail: (user?.kakaoAccount?.email)!, password: "\(String(describing: user?.id))") { authResult, error in
//                    if let error = error {
//                        print("Firebase 사용자 생성 실패: \(error.localizedDescription)")
//                        Auth.auth().signIn(withEmail: (user?.kakaoAccount?.email)!, password: "\(String(describing: user?.id))")
//                    } else {
//                        print("Firebase 사용자 생성 성공")
//                        let authResult = authResult?.user
//                        let currentKakao = user?.kakaoAccount
//                        // setData 하는 부분
//                        Firestore.firestore().collection("User").document(authResult?.uid ?? "").setData([
//                            "userEmail" : currentKakao?.email ?? "",
//                            "userNickname" : currentKakao?.profile?.nickname ?? "",
//                        ])
//                    }
//                }
//            }
//        }
//    }
    
    func kakaoLogOut() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
                self.authenticationStore.logInCompanyState = .noCompany
                self.authenticationStore.authenticationState = .unauthenticated
                self.signOut()
            }
        }

    }
    
     func signOut() {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print(error.localizedDescription)
        }
    }
}

func unlinkKakao(){
    UserApi.shared.unlink {(error) in
        if let error = error {
            print(error)
        }
        else {
            print("unlink() success.")
        }
    }
}
