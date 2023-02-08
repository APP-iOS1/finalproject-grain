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
import Combine


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
                
                
                insertUser(myFilm: "선택", bookmarkedMagazineID: "", email: profile.email, myCamera: "필수", postedCommunityID: "", postedMagazineID: "", likedMagazineId: "", lastSearched: "", bookmarkedCommunityID: "", recentSearch: "", id: uid ?? "", following: "", myLens: "선택", profileImage: "", name: profile.name, follower: "", nickName: "")
                
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
    // 유저 데이터 만들기

    var subscription = Set<AnyCancellable>()
    var fetchUsersSuccess = PassthroughSubject<(), Never>()
    var insertUsersSuccess = PassthroughSubject<(), Never>()

    func insertUser(myFilm: String,bookmarkedMagazineID: String,email: String,myCamera: String,postedCommunityID: String,postedMagazineID: String,likedMagazineId: String,lastSearched: String,bookmarkedCommunityID: String,recentSearch: String,id: String,following: String,myLens : String,profileImage: String,name: String,follower: String,nickName: String) {

        UserService.insertUser(myFilm: myFilm,bookmarkedMagazineID: bookmarkedMagazineID,email: email,myCamera: myCamera,postedCommunityID: postedCommunityID,postedMagazineID: postedMagazineID,likedMagazineId: likedMagazineId,lastSearched: lastSearched,bookmarkedCommunityID: bookmarkedCommunityID,recentSearch: recentSearch,id: id,following: following,myLens :myLens,profileImage: profileImage,name: name,follower: follower,nickName: nickName)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
        } receiveValue: { (data: UserDocument) in
            UserDefaults.standard.set(String(data.name.suffix(20)), forKey: "docID")
            self.fetchUsersSuccess.send()
        }.store(in: &subscription)
    }

   
    
}

extension AuthenticationStore {
    public func changeLogInCompanyToKakao() {
        logInCompanyState = .kakaoLogIn
    }
    
    public func changeLogInCompanyToNil() {
        logInCompanyState = .noCompany
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


