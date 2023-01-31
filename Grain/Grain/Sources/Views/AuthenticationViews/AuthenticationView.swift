//
//  AuthenticationView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/18.
//

import SwiftUI

import GoogleSignInSwift
import FirebaseAuth

struct AuthenticationView: View {
    @EnvironmentObject var authenticationStore: AuthenticationStore
    @StateObject var kakaoAuthenticationStore: KakaoAuthenticationStore = KakaoAuthenticationStore()
    
    var body: some View {
        VStack{
            Text("GRAIN")
                .font(.largeTitle)
                .bold()
                .kerning(7)
            Spacer()
                .frame(maxHeight: Screen.maxHeight * 0.3 )
            VStack(alignment: .leading) {
                Text("환영해요!")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("로그인해서 Grain과의 여정을 시작하세요.")
            }
            GoogleSignInButton(style:.standard) {
                authenticationStore.googleLogin()
            }
            .frame(maxWidth: Screen.maxWidth * 0.8)
            
            Button{
                kakaoAuthenticationStore.kakaoSignIn()
            } label: {
                Image("kakaoLoginLarge")
                    .resizable()
                    .frame(maxWidth: Screen.maxWidth * 0.8, maxHeight: Screen.maxHeight * 0.05)
                    .shadow(radius: 7)
            }
            Button {
                print(Auth.auth().currentUser?.email ?? "")
                print(authenticationStore.logInCompanyState)
            } label: {
                Text("프린트")
            }
            Spacer()
                .frame(maxHeight: Screen.maxHeight * 0.1 )
            
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
