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
import AuthenticationServices
import CryptoKit
import FirebaseAuth
import FirebaseMessaging

/// 로그인 상태관리

enum AuthenticationState: String {
    case unauthenticated
    case authenticating
    case authenticated
    case freshman
}
/// 로그인 회사 상태관리
enum LogInCompanyState: String{
    case googleLogIn
    case appleLogIn
    case noCompany
}

final class AuthenticationStore: ObservableObject {
    @Published var user: User?
    @Published var displayName = ""
    @Published var errorMessage = ""
    
    @Published var userUID = ""
    @Published var userName = ""
    @Published var email = ""
    @Published var users = [UserDocument]()
    @Published var userTemp = [UserDocument]()
    @Published var tokenBool : Bool = false
    
    @AppStorage("authenticationState") var authenticationState: AuthenticationState = .unauthenticated
    @AppStorage("logInCompanyState") var logInCompanyState: LogInCompanyState = .noCompany
    
    var updateUsersArraySuccess = PassthroughSubject<(), Never>()
    var fetchCurrentUsersSuccess = PassthroughSubject<CurrentUserFields, Never>()
    
    fileprivate var currentNonce: String?
    
    let authPath = Auth.auth()
    
    
    // MARK: - Google Login
    
    /// 구글 로그인
    public func googleLogin() {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
            
        } else {//첫 로그인
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            let configuration = GIDConfiguration(clientID: clientID)
            DispatchQueue.main.async {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
                
                GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { [unowned self] user, error in
                    authenticateUser(for: user, with: error)
                }
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
                
                userUID = uid ?? ""
                userName = profile.name
                email = profile.email
                findUserDocID(docID: userUID, nextPageToken: "")
                self.logInCompanyState = .googleLogIn
                
            }
        }
    }
    
    func addToken() {
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM token: \(error.localizedDescription)")
                return
            }
            if let token = token {
                var arr : [String] = []
                
                UserService.getCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
                    .receive(on: DispatchQueue.main)
                    .sink { (completion: Subscribers.Completion<Error>) in
                    } receiveValue: { (data: CurrentUserResponse) in
                        for i in data.fields.fcmToken.arrayValue.values {
                            if i.stringValue == token {
                                continue
                            }
                            arr.append(i.stringValue)
                        }
                    }.store(in: &self.subscription)
                
                arr.append(token)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    // type : fcmToken arr : 토큰값 넣기 docID: 현재 유저 아이디
                    UserService.updateCurrentUserArray(type: "fcmToken", arr: arr, docID: Auth.auth().currentUser?.uid ?? "")
                        .receive(on: DispatchQueue.main)
                        .sink { (completion: Subscribers.Completion<Error>) in
                        } receiveValue: { (data: UserDocument) in
                            self.tokenBool = true
                            self.updateUsersArraySuccess.send()
                        }.store(in: &self.subscription)
                }
            }
        }
    }
    
    func removeToken(tokenArray: [CurrentUserStringValue]) {
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM token: \(error.localizedDescription)")
                return
            }
            if let token = token {
                var arr : [CurrentUserStringValue] = tokenArray
                var arrToString: [String] = []
                
                
                if !(arr.count == 0) {
                    for i in 0..<arr.count{
                        if arr[i].stringValue == token{
                            arr.remove(at: i)
                            break
                        }
                    }
                    for i in arr {
                        arrToString.append(i.stringValue)
                    }
                    
                    
                    UserService.updateCurrentUserArray(type: "fcmToken", arr: arrToString, docID: Auth.auth().currentUser?.uid ?? "")
                        .receive(on: DispatchQueue.main)
                        .sink { (completion: Subscribers.Completion<Error>) in
                        } receiveValue: { (data: UserDocument) in
                            
                            self.updateUsersArraySuccess.send()
                        }.store(in: &self.subscription)
                }else{
                    print("유저 토큰배열이 없습니다")
                }
                
                
            }
        }
        
        
    }
    
    // MARK: - Apple LogIn
    /// 애플 로그인 request
    func hadleSignInwithAppleRequest(_ request: ASAuthorizationAppleIDRequest){
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }
    /// 애플 로그인 completion result
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>){
        if case .failure(let failure) = result {
            errorMessage = failure.localizedDescription
        }
        else if case . success(let success) = result {
            if let appleIDCredential = success.credential as? ASAuthorizationAppleIDCredential{
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: a login callback was receiced, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identity token.")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialise token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
                
                
                Task{
                    do{
                        let result = try await Auth.auth().signIn(with: credential)
                        // diplayName update 시점
                        await updateDisplayName(for: result.user, with: appleIDCredential)
                        DispatchQueue.main.async {
                            self.logInCompanyState = .appleLogIn
                        }
                    }
                    catch{
                        print("Error authenticating: \(error.localizedDescription)")
                    }
                    
                }
            }
        }
    }
    /// displayName update
    func updateDisplayName(for user: User, with appleIDCredential: ASAuthorizationAppleIDCredential, force: Bool = false) async {
        if let currentDisplayName = Auth.auth().currentUser?.displayName, !currentDisplayName.isEmpty {
            // current user is non-empty, don't overwrite it
            self.findUserDocID(docID: user.uid, nextPageToken: "")

        }
        else {
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = appleIDCredential.displayName()
            do {
                try await changeRequest.commitChanges()

                DispatchQueue.main.async {
                    self.displayName = Auth.auth().currentUser?.displayName ?? ""
                    self.userUID = user.uid
                    self.userName = user.displayName ?? ""
                    self.email = user.email ?? ""
                    self.findUserDocID(docID: self.userUID, nextPageToken: "")
                }
            }
            catch {
                print("Unable to update the user's displayname: \(error.localizedDescription)")
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func verifySignInWithAppleAuthenticationState() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let providerData = Auth.auth().currentUser?.providerData
        if let appleProviderData = providerData?.first(where: { $0.providerID == "apple.com" }) {
            Task {
                do {
                    let credentialState = try await appleIDProvider.credentialState(forUserID: appleProviderData.uid)
                    switch credentialState {
                    case .authorized:
                        break // The Apple ID credential is valid.
                    case .revoked, .notFound:
                        // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                        self.appleLogout()
                    default:
                        break
                    }
                }
                catch {
                }
            }
        }
    }
    
    // MARK: - Apple LogOut
    // 기기에서 로그인 하는것이기 때문에 shared instance 까지 로그아웃 시키지 않음
    public func appleLogout() {
        do {
            try authPath.signOut()
            // MARK: isUserLoggedIn, authenticationState 두개 상태 unauthenticated 바꿔서 isUserLoggedIn( 자동로그인 방지 ), authenticationState( 뷰 보여지는 방식 바꾸기 )
            self.authenticationState = .unauthenticated
            self.logInCompanyState = .noCompany
        } catch {
            print(error.localizedDescription)
        }
        //        isUserLoggedIn = false
    }
    // MARK: - Google LogOut
    
    /// 구글 로그아웃
    public func googleLogout() {
        do {
            try authPath.signOut()
            GIDSignIn.sharedInstance.signOut()
            // MARK: isUserLoggedIn, authenticationState 두개 상태 unauthenticated 바꿔서 isUserLoggedIn( 자동로그인 방지 ), authenticationState( 뷰 보여지는 방식 바꾸기 )
            self.authenticationState = .unauthenticated
            self.logInCompanyState = .noCompany
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func authStateAuthenticated(user: CurrentUser) {
        self.authenticationState = .authenticated
    }
    // MARK: - 회원탈퇴 확인해봐야함
    func googleDisconnect() {
        GIDSignIn.sharedInstance.disconnect()
    }
    func deleteAccount() async -> Bool {
        do {
            try await user?.delete()
            return true
        }
        catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    // MARK: - 유저 데이터 만들기
    var subscription = Set<AnyCancellable>()
    var findUserDocIDSuccess = PassthroughSubject<(), Never>()
    var findTokenSuccess = PassthroughSubject<(), Never>()
    
    // 전체 유저데이터 조회 후 비교
    func findUserDocID(docID: String , nextPageToken: String){
        UserService.getUser(nextPageToken: "")
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: UserResponse) in
                self.userTemp.append(contentsOf: data.documents)
                
                if !(data.nextPageToken == nil) {
                    var nextPageToken : String = ""
                    nextPageToken = data.nextPageToken!
                    self.findUserDocID(docID:docID, nextPageToken: nextPageToken)
                }else{
                    self.users = self.userTemp

                    for i in self.users{
                        if i.fields.id.stringValue == docID{
                            self.authenticationState = .authenticated   //authenticationState 상태 변환
                            break
                        }
                        self.authenticationState = .freshman
                    }
                    self.userTemp.removeAll()

                    self.findUserDocIDSuccess.send()

                }

            }.store(in: &subscription)
    }
    
    
    
    // MARK: - 애플 로그인 helper
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
}

extension ASAuthorizationAppleIDCredential {
    func displayName() -> String {
        return [self.fullName?.givenName, self.fullName?.familyName]
            .compactMap( {$0})
            .joined(separator: " ")
    }
}

extension AuthenticationStore {
    public func changeLogInCompanyToNil() {
        logInCompanyState = .noCompany
    }
}
