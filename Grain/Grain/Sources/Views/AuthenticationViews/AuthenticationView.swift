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

struct AuthenticationView: View {
    @EnvironmentObject var authenticationStore: AuthenticationStore
    @EnvironmentObject var kakaoAuthenticationStore: KakaoAuthenticationStore
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
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
            
            // MARK: - 카카오 로그인
            Button{
//                kakaoAuthenticationStore.kakaoSignIn()    
                authenticationStore.changeLogInCompanyToKakao()
            } label: {
                Image("kakaoLoginLarge")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                  
                    .cornerRadius(8)
            }
            .frame(width: Screen.maxWidth * 0.8, height: Screen.maxHeight * 0.06)
            .padding(.bottom, 5)
            Spacer()
                .frame(maxHeight: Screen.maxHeight * 0.12 )
            
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
