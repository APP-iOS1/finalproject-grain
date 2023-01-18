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
    
    var body: some View {
        VStack{
            
            Button {
                authenticationStore.googleLogout()
            } label: {
                Text("로그아웃")
            }
            Text("\(Auth.auth().currentUser?.email ?? "")")
            Button {
                print(Auth.auth().currentUser?.email ?? "")
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
