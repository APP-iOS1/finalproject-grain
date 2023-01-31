//
//  AuthenticationTestView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/18.
//

import SwiftUI

import FirebaseAuth

struct AuthenticationTestView: View {
    @EnvironmentObject var authenticationStore: AuthenticationStore
    @EnvironmentObject var kakaoAuthenticationStore: KakaoAuthenticationStore
    
    var body: some View {
        VStack{
            
            Button {
                if authenticationStore.logInCompanyState == .googleLogIn {
                    authenticationStore.googleLogout()
                } else if authenticationStore.logInCompanyState == .kakaoLogIn {
                    kakaoAuthenticationStore.kakaoLogOut()
                } else {
                    kakaoAuthenticationStore.kakaoLogOut()
                }
            } label: {
                Text("로그아웃")
            }
            Text("\(Auth.auth().currentUser?.email ?? "")")
            Button {
                
                print(Auth.auth().currentUser?.email ?? "")
                print(authenticationStore.logInCompanyState)
            } label: {
                Text("프린트")
            }
        }


    }
}

struct AuthenticationTestView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationTestView()
    }
}
