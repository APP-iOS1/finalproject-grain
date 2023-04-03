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
enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
    case freshman
}
/// 로그인 회사 상태관리
enum LogInCompanyState{
    case googleLogIn
    case appleLogIn
    case noCompany
}

enum MemberState{
    case member   // 이미 가입된 상태
    case freshman   //아직 가입되지 않은 상태
//    case defaultState // 디폴트 상태값 주기
}

final class AuthenticationStore: ObservableObject {
    
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var logInCompanyState: LogInCompanyState = .noCompany
    @Published var memberState: MemberState = .freshman
    @Published var user: User?
    @Published var displayName = ""
    @Published var errorMessage = ""
    @Published var checkUsers = [UserDocument]()
    
    @Published var userUID = ""
    @Published var userName = ""
    @Published var email = ""
    
    var updateUsersArraySuccess = PassthroughSubject<(), Never>()
    var fetchCurrentUsersSuccess = PassthroughSubject<CurrentUserFields, Never>()

    fileprivate var currentNonce: String?
    
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
            
        } else {//첫 로그인
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
            
                userUID = uid ?? ""
                userName = profile.name
                email = profile.email
                findUserDocID(docID: uid ?? "")
                self.logInCompanyState = .googleLogIn
                
                addToken()
                print("로그인됨")

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
//                            print("updateUserToke:\(arr)")
                            self.updateUsersArraySuccess.send()
                        }.store(in: &self.subscription)
                }
            }
        }
    }
    
    func removeToken(tokenArray: [CurrentUserStringValue]) {
//        print("tokenArray: \(tokenArray)")
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM token: \(error.localizedDescription)")
                return
            }
            if let token = token {
                var arr : [CurrentUserStringValue] = tokenArray
                var arrToString: [String] = []

                for i in 0..<arr.count{
                    if arr[i].stringValue == token{
                        arr.remove(at: i)
                        break
                    }
                }
//                print("arr:\(arr)")

                for i in arr {
                    arrToString.append(i.stringValue)
                }
                print("arrToString: \(arrToString)")
                
                UserService.updateCurrentUserArray(type: "fcmToken", arr: arrToString, docID: Auth.auth().currentUser?.uid ?? "")
                    .receive(on: DispatchQueue.main)
                    .sink { (completion: Subscribers.Completion<Error>) in
                    } receiveValue: { (data: UserDocument) in
                        print("updateUserToke:\(arrToString)")
                        self.updateUsersArraySuccess.send()
                    }.store(in: &self.subscription)
                
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
                        addToken()
                        self.logInCompanyState = .appleLogIn
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
        }
        else {
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = appleIDCredential.displayName()
            do {
                try await changeRequest.commitChanges()
                self.displayName = Auth.auth().currentUser?.displayName ?? ""
                
                userUID = user.uid
                userName = user.displayName ?? ""
                email = user.email ?? ""
                findUserDocID(docID: user.uid)
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
            self.authenticationState = .unauthenticated
            self.logInCompanyState = .noCompany
        } catch {
            print(error.localizedDescription)
        }
    }
    // MARK: - Google LogOut
    
    /// 구글 로그아웃
    public func googleLogout() {
        do {
            try authPath.signOut()
            GIDSignIn.sharedInstance.signOut()
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
    
    // 전체 유저데이터 조회 후 비교
    func findUserDocID(docID: String){
        UserService.getUser()
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: UserResponse) in
                print("finduserdocid 실행됨")
                self.checkUsers = data.documents
                for i in data.documents{
                    if i.fields.id.stringValue == docID{
                        self.authenticationState = .authenticated
//                        self.addToken()
                        break
                    }
                    self.authenticationState = .freshman
                }
                self.findUserDocIDSuccess.send()
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
