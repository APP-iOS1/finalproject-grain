//
//  AuthenticationStore.swift
//  Grain
//
//  Created by 조형구 on 2023/01/18.
//

import SwiftUI

import Firebase
import GoogleSignIn
import GoogleSignInSwift


final class AuthenticationStore: ObservableObject {
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var logInCompanyState: LogInCompanyState = .noCompany
    @Published var user: User?
    @Published var displayName = ""
    
    let userDatabasePath = Firestore.firestore().collection("User")
    let authPath = Auth.auth()
    
    init() {
        registerAuthStateHandler()
    }
    
    // MARK: - authState listener
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
                self.displayName = user?.email ?? ""
            }
        }
    }
    
    // MARK: - Google Login
    
    /// 구글 로그인
    public func googleLogin() {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        } else {
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            let configuration = GIDConfiguration(clientID: clientID)
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
            
            GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        }
    }
    /// 유저 승인, user collection에 set data하는  private function
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        if error != nil {
            print(error!.localizedDescription)
            return
        }
        
        guard let authentication = user?.authentication,
              let idToken = authentication.idToken else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { [unowned self] succcess, error in
            let uid = succcess?.user.uid
            if let error = error {
                dump("\(#function) - DEBUG \(error.localizedDescription)")
            } else {
                guard let profile = user?.profile else { return }
                userDatabasePath.document(uid ?? "").getDocument { snapshot, err in
                    if let isExsits = snapshot?.exists,
                       let uid,
                       isExsits == false {
                        self.userDatabasePath.document(uid).setData([
                            "id": uid,
                            "name": profile.name,
                            "email": profile.email
                        ])
                    }
                }
                
                self.authStateAuthenticated(user: CurrentUser(id: uid ?? "", name: profile.name, email: profile.email))
                self.logInCompanyState = .googleLogIn
            }
        }
    }
    // MARK: - Google LogOut
    
    /// 구글 로그아웃
    public func googleLogout() {
        GIDSignIn.sharedInstance.signOut()
        
        do {
            try authPath.signOut()
            self.authenticationState = .unauthenticated
            self.logInCompanyState = .noCompany
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func authStateAuthenticated(user: CurrentUser) {
        self.authenticationState = .authenticated
    }
    
    public func changeLogInCompanyToKakao() {
        self.logInCompanyState = .kakaoLogIn
    }
    
    public func changeLogInCompanyToNil() {
        self.logInCompanyState = .noCompany
    }
    
}


/// 로그인 상태관리
enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum LogInCompanyState{
    case googleLogIn
    case kakaoLogIn
    case noCompany
}


