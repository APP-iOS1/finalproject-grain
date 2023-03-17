//
//  MyPageModalView.swift
//  Grain
//
//  Created by 한승수 on 2023/01/31.
//

import SwiftUI
import MessageUI

struct MyPageOptionView: View {
//    let optionMenu = ["프로필 편집", "카메라 정보", "저장됨", "로그아웃"]
//    @Environment(\.presentationMode) var presentationMode
//    @StateObject var authVM = AuthenticationStore()
    var userVM: UserViewModel
    var bookmarkedMagazineDocument: [MagazineDocument]
    var bookmarkedCommunityDoument: [CommunityDocument]
    @StateObject var communityVM: CommunityViewModel = CommunityViewModel()
    
    var body: some View {
        VStack(alignment: .leading){
            
            //MARK: 상단바
//            HStack{
//                Button(action: {
//                    presentationMode.wrappedValue.dismiss()
//                }, label: {
//                    HStack {
//                        Image(systemName: "chevron.left")
//                        Text("마이페이지")
//                    }
//                    .padding(.horizontal)
//                })
//
//                Spacer()
//
//                Text("설정")
//                    .font(.title3)
//                    .bold()
//                    .padding(.trailing, 125)
//
//                Spacer()
//            }
//            .accentColor(.black)
            
            ScrollView{
                //MARK: 계정 섹션
                //이거넣음
                AccountSection(communityVM: communityVM, userVM: userVM, bookmarkedMagazineDocument: bookmarkedMagazineDocument, bookmarkedCommunityDoument: bookmarkedCommunityDoument)
                
                //MARK: 지원 섹션
                SupportSection()
                
                //MARK: 정보 섹션
                InfoSection()
                    .padding(.bottom)
            }
            Spacer()
        }
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarHidden(true)
//        .navigationBarBackButtonHidden(true)
        .onAppear {
            // 커뮤니티 데이터 fetch
            communityVM.fetchCommunity()
        }
    }
}

//struct MyPageOptionView_Previews: PreviewProvider {    
//    static var previews: some View {
//        NavigationStack {
//            MyPageOptionView()
//        }
//    }
//}

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

//MARK: - 계정 섹션
struct AccountSection: View {
    //이거 넣고
    @StateObject var communityVM: CommunityViewModel
    var userVM: UserViewModel
//    var community: [CommunityDocument]
    var bookmarkedMagazineDocument: [MagazineDocument]
    var bookmarkedCommunityDoument: [CommunityDocument]

    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Text("계정")
                .font(.title2)
                .bold()
                .padding(.horizontal)
                .padding(.top)
                .padding(.leading, 5)
            
            NavigationLink {
                EditMyPageView(userVM: userVM)
            } label: {
                HStack() {
                    Image(systemName: "person")
                        .font(.system(size: 25))
                        .padding(.trailing, 10)
                    
                    Text("프로필 편집")
                        .font(.title3)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.title3)
                }
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.vertical)
            }
            .padding(.horizontal)
            
            NavigationLink {
                EditCameraView()
            } label: {
                HStack {
                    Image(systemName: "camera")
                        .font(.system(size: 20))
                        .padding(.trailing, 10)
                    
                    Text("나의 장비 정보")
                        .font(.title3)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.title3)
                }
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding(.horizontal)
            
            NavigationLink {
                BookmarkedMagazine(bookmarkedMagazineDocument: bookmarkedMagazineDocument)
            } label: {
                HStack {
                    Image(systemName: "bookmark")
                        .font(.system(size: 22))
                        .padding(.leading, 2.8)
                        .padding(.trailing, 13)
                    
                    Text("저장된 매거진")
                        .font(.title3)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.title3)
                }
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding(.horizontal)
            
            NavigationLink {
                BookmarkedCommunityView(bookmarkedCommunityDoument: bookmarkedCommunityDoument, isLoading: $communityVM.isLoading)
            } label: {
                HStack {
                    Image(systemName: "bookmark")
                        .font(.system(size: 22))
                        .padding(.leading, 2.8)
                        .padding(.trailing, 13)
                    
                    Text("저장된 커뮤니티 글")
                        .font(.title3)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.title3)
                }
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding(.horizontal)
        }
    }
}

//MARK: - 지원 섹션
struct SupportSection: View {
    @State private var isShowingMailView = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Text("지원")
                .font(.title2)
                .bold()
                .padding()
                .padding(.leading, 5)
            
//            Button {
//                Text("고객센터")
//                EmailController.shared.sendEmail(subject: "Hello", body: "Hello From ishtiz.com", to: "recipient@example.com")
            NavigationLink {
                UserServiceView()
            } label: {
                HStack {
                    Image(systemName: "message")
                        .font(.system(size: 19))
                        .padding(.leading, 3)
                        .padding(.trailing, 11)
                    
                    //                            .resizable()
                    //                            .frame(width: 20, height: 20)
                    //                            .aspectRatio(contentMode: .fit)
                    //                            .padding(.trailing)
                    Text("고객센터")
                        .font(.title3)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding(.horizontal)
          
            
            NavigationLink {
                UserFeedbackView()
            } label: {
                HStack {
                    Image(systemName: "envelope")
                        .font(.system(size: 19))
                        .padding(.leading, 3)
                        .padding(.trailing, 12)
                    //                            .resizable()
                    //                            .frame(width: 20, height: 20)
                    //                            .aspectRatio(contentMode: .fit)
                    //                            .padding(.trailing)
                    Text("피드백")
                        .font(.title3)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .font(.title2)
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding(.horizontal)
        }
    }
    
    func createEmailUrl(to: String, subject: String, body: String) -> String {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
        let defaultUrl = "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)"
            
        return defaultUrl
    }
}

//MARK: - 정보 섹션
struct InfoSection: View {
    @ObservedObject var authVM: AuthenticationStore = AuthenticationStore()
    @ObservedObject var kakoAuthVM: KakaoAuthenticationStore = KakaoAuthenticationStore()
   
    // Progress 변수
    @State private var isShownProgress: Bool = true

    // Alert 변수
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Text("정보")
                .font(.title2)
                .bold()
                .padding()
                .padding(.leading, 5)
            
            NavigationLink {
                ZStack{
                    MyWebView(urlToLoad: "https://statuesque-cast-fac.notion.site/GRAIN-6d71c1363594444b8c9d4ba9ad6b192d")
                        .navigationTitle(Text("이용약관"))
                        .navigationBarTitleDisplayMode(.inline)
                    if isShownProgress == true {
                        ProgressView()
                            .onAppear{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    self.isShownProgress = false
                                }
                            }
                    }
                }
                .onDisappear{
                    isShownProgress = true
                }
            } label: {
                HStack {
                    Image(systemName: "doc")
                        .font(.system(size:22))
                        .padding(.leading, 3.6)
                        .padding(.trailing, 14)
                    
                    Text("이용약관")
                        .font(.title3)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.title3)
                    
                }
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding(.horizontal)
            
            NavigationLink {
                //PrivacyPolicyView()
                ZStack{
                    MyWebView(urlToLoad: "https://sites.google.com/view/grain-ios/%ED%99%88")
                        .navigationTitle(Text("개인 정보 처리방침"))
                        .navigationBarTitleDisplayMode(.inline)
                    if isShownProgress == true {
                        ProgressView()
                            .onAppear{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    self.isShownProgress = false
                                }
                            }
                    }
                }
                .onDisappear{
                    isShownProgress = true
                }

            } label: {
                HStack {
                    Image(systemName: "shield")
                        .font(.system(size:23))
                        .padding(.leading, 2.9)
                        .padding(.trailing, 14)
                    
                    Text("개인 정보 처리방침")
                        .font(.title3)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.title3)
                }
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding(.horizontal)
            
            NavigationLink {
                ZStack{
                MyWebView(urlToLoad: "https://statuesque-cast-fac.notion.site/Third-Party-Notices-141126a372d64957b9d7a81b02f2f3c1")
                        .navigationTitle(Text("오픈소스 라이선스"))
                        .navigationBarTitleDisplayMode(.inline)
                    if isShownProgress == true {
                        ProgressView()
                            .onAppear{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    self.isShownProgress = false
                                }
                            }
                    }
                }
                .onDisappear{
                    isShownProgress = true
                }
            } label: {
                HStack {
                    Image(systemName: "network")
                        .font(.system(size:23))
                        .padding(.leading, 2.9)
                        .padding(.trailing, 14)
                    
                    Text("오픈소스 라이선스")
                        .font(.title3)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.title3)
                }
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding(.horizontal)
            
            Button {
//                if authVM.logInCompanyState == .appleLogIn {
//                    authVM.appleLogout()
//                } else if authVM.logInCompanyState == .googleLogIn {
//                    authVM.googleLogout()
//                } else if authVM.logInCompanyState == .kakaoLogIn {
//                    kakoAuthVM.kakaoLogOut()
//                } else {
//                    authVM.appleLogout()
//                    authVM.googleLogout()
//                    kakoAuthVM.kakaoLogOut()
//                }
                showAlert.toggle()
                
            } label: {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size:20))
                        .padding(.leading, 5.5)
                        .padding(.trailing, 12)
                    
                    Text("로그아웃")
                        .font(.title3)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.title3)
                }
                .foregroundColor(.black)
                .padding(.horizontal)
            }
            .padding(.horizontal)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("로그아웃 하시겠습니까?"),
                      primaryButton: .destructive(
                        Text("네")
                      ){
                          if authVM.logInCompanyState == .appleLogIn {
                              authVM.appleLogout()
                          } else if authVM.logInCompanyState == .googleLogIn {
                              authVM.googleLogout()
                          } else if authVM.logInCompanyState == .kakaoLogIn {
                              kakoAuthVM.kakaoLogOut()
                          } else {
                              authVM.appleLogout()
                              authVM.googleLogout()
                              kakoAuthVM.kakaoLogOut()
                          }
                      },
                      secondaryButton: .default(
                        Text("아니오")
                      ))
            }
        }
    }
}


// WebView로 연결
import WebKit

// UIViewRepresentable 프로토콜을 구현하면 스유에서 UIView 사용가능하다 (UIView가 무엇이지 공부하기)
struct MyWebView: UIViewRepresentable {
    var urlToLoad: String
    
    //ui view
    func makeUIView(context: Context) ->  WKWebView {
        
        //unwrapping
        guard let url = URL(string: self.urlToLoad) else {
            return WKWebView()
        }
        
        // 인스턴스 생성
        let webView = WKWebView()
        
        // 웹뷰 로드
        webView.load(URLRequest(url: url))
        return webView
    }
    
    //업데이트 ui view -> UIViewRepresentable를 따르기 위해 일단 선언한거 같음 (이 함수 선언부를 지우면 프로토콜을 따르지 않는다고 에러가 나타남 / 추후 더 공부해보기)
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
}

/*
 "This method should not be called on the main thread as it may lead to UI unresponsiveness."
 보라색 괴물이 등장하는 이유...
 
 한 블로거에 의하면 대체적으로 다음버전에서 개선될 가능성이 크다는 의견을 보이는 듯...
 일단 무시하고 작업해도 될 듯
 */


// Mail Send
class EmailController: NSObject, MFMailComposeViewControllerDelegate {
    public static let shared = EmailController()
    private override init() { }
    
    func sendEmail(subject:String, body:String, to:String){
        // Check if the device is able to send emails
        if !MFMailComposeViewController.canSendMail() {
           print("This device cannot send emails.")
           return
        }
        // Create the email composer
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients([to])
        mailComposer.setSubject(subject)
        mailComposer.setMessageBody(body, isHTML: false)
        EmailController.getRootViewController()?.present(mailComposer, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        EmailController.getRootViewController()?.dismiss(animated: true, completion: nil)
    }
    
    static func getRootViewController() -> UIViewController? {
        // In SwiftUI 2.0
        UIApplication.shared.windows.first?.rootViewController
    }
}


// mail test (from GPT)
struct MailView: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.setToRecipients(["example@example.com"])
        mailComposeViewController.setSubject("Subject")
        mailComposeViewController.setMessageBody("Message body", isHTML: false)
        mailComposeViewController.mailComposeDelegate = context.coordinator
        return mailComposeViewController
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
        // No update necessary
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isShowing: $isShowing)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var isShowing: Bool
        
        init(isShowing: Binding<Bool>) {
            _isShowing = isShowing
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            defer {
                isShowing = false
            }
            
            switch result {
            case .cancelled:
                print("Mail cancelled")
            case .saved:
                print("Mail saved")
            case .sent:
                print("Mail sent")
            case .failed:
                print("Mail failed: \(String(describing: error))")
            @unknown default:
                fatalError()
            }
            
            controller.dismiss(animated: true, completion: nil)
        }
    }
}

// OpenURL
struct SupportEmail {
    let toAddress: String
    let subject: String
    let messageHeader: String
    var body: String {
        """
        \(messageHeader)
    --------------------------------------
    """
    }
    
    func send(openURL: OpenURLAction) {
        let urlString = "mailto:\(toAddress)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"
        guard let url = URL(string: urlString) else { return }
        openURL(url) { accepted in
            if !accepted {
                print("""
                This device does not support email
                \(body)
                """)
            }
        }
    }
}


//고객센터 View
struct UserServiceView: View{
    // 다른 앱을 열기 위함
    @Environment(\.openURL) var openURL
    
    // text를 클립 보드에 복사하기 위한 변수
    let pastedboard = UIPasteboard.general
    @State private var copiedComplete: Bool = false
    
    // 메일 형식
    private var email = SupportEmail(toAddress: "pkkyung26@gmail.com", subject: "GRAIN 문의사항", messageHeader: "아래에 내용을 입력해주세요. (사용하시는 기기와 iOS버전, 앱의 버전을 입력해주시면 더욱 신속한 처리가 가능합니다. \n 단말기 명: \n iOS 버전: \n GRAIN 버전: ")
    
    var body: some View {
            VStack(alignment: .leading){
                Image(systemName: "message")
                    .font(.title)
                    .padding(.bottom, 1)
                
                Text("문의사항이 있으신가요?")
                    .font(.title2)
                    .bold()
                    .padding(.bottom)
                
                VStack(alignment: .leading){
                    HStack(spacing: 0){
                        Text("문의사항은 ")
                        Text(verbatim: "pkkyung26@gmail.com")
                            .foregroundColor(.vivaMagenta)
                            .onTapGesture {
                                pastedboard.string = "pkkyung26@gmail.com"
                                self.copiedComplete = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    self.copiedComplete = false
                                }
                            }
                        Text(" 으로")
                    }
                    Text("메일을 보내주세요.")
                }
                .font(.headline)
                .bold()
                .padding(.bottom)
                
                
                Text("""
(화면이나 기능에 이상이 있을 시, 사용 중이신 기기와 iOS 버전, 앱의 버전을 함께 알려주시면 보다 빠르게 처리가 가능합니다.)
""")
                .padding(.bottom, 30)
                .foregroundColor(.textGray)
                
                HStack{
                    Spacer()
                    
                    VStack{
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 180, height: 50)
                            .overlay{
                                Button{
                                    email.send(openURL: openURL)
                                    
                                } label: {
                                    Text("메일 앱에서 작성하기")
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.top)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 180, height: 50)
                            .overlay{
                                Button{
                                    pastedboard.string = "pkkyung26@gmail.com"
                                    self.copiedComplete = true
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                        self.copiedComplete = false
                                    }
                                    
                                } label: {
                                    Text("메일 주소 복사하기")
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.top)
                        
                    }
                    Spacer()
                }
                
                Spacer()
                
                if copiedComplete {
                    HStack{
                        Spacer()
                        Text("복사되었습니다")
                            .font(.callout)
                            .foregroundColor(.middlebrightGray)
                            .padding(.bottom)
                        Spacer()
                    }
                }
            }
            .padding()
            .padding(.top, 50)
            .navigationTitle(Text("고객센터"))
            .navigationBarTitleDisplayMode(.inline)
    }
}

//struct UserServiceView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack{
//            UserServiceView()
//        }
//    }
//}


//피드백 View
struct UserFeedbackView: View{
    // 다른 앱을 열기 위함

    @Environment(\.openURL) var openURL
    
    // text를 클립 보드에 복사하기 위한 변수
    let pastedboard = UIPasteboard.general
    @State private var copiedComplete: Bool = false
    
    // 메일 형식
    private var email = SupportEmail(toAddress: "pkkyung26@gmail.com", subject: "GRAIN 피드백 메일", messageHeader: "GRAIN에서 좋았던 점이나 불편했던 점, 바라는 점을 보내주세요.")
    
    var body: some View {
        VStack(alignment: .leading){
            Image(systemName: "envelope")
                .font(.title)
                .padding(.bottom, 5)
            
                Text("GRAIN에서의 경험이 만족스러우신가요?")
                .font(.title2)
                .bold()
                .padding(.bottom)
            
            VStack(alignment: .leading){
                Text("GRAIN에 전달해주실 피드백을")
                
                HStack(spacing: 0){
                    Text(verbatim:"pkkyung@gmail.com")
                        .foregroundColor(.vivaMagenta)
                        .onTapGesture {
                            pastedboard.string = "pkkyung26@gmail.com"
                            self.copiedComplete = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.copiedComplete = false
                            }
                        }
                    
                    Text("으로 보내주세요")
                }
            }
            .font(.headline)
            .bold()
            .padding(.bottom)
            
            VStack{
                Text("GRAIN")
                    .bold() +
                Text("""
에서 좋았던 점이나 불편했던 점, 바라는 점을 보내주세요.
여러분의 소중한 피드백을 기다립니다!
""")
            }
                .foregroundColor(.boxGray)
                .padding(.bottom)
            
            HStack{
                Spacer()
                
                VStack{
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 180, height: 50)
                        .overlay{
                            Button{
                                email.send(openURL: openURL)
                                
                            } label: {
                                Text("메일 앱에서 작성하기")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.top)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 180, height: 50)
                        .overlay{
                            Button{
                                pastedboard.string = "pkkyung26@gmail.com"
                                self.copiedComplete = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                    self.copiedComplete = false
                                }
                                
                            } label: {
                                Text("메일 주소 복사하기")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.top)
                    
                }
                .padding(.top)
                
                Spacer()
                
            }
            Spacer()
            
            if copiedComplete {
                HStack{
                    Spacer()
                    Text("복사되었습니다")
                        .font(.callout)
                        .foregroundColor(.middlebrightGray)
                        .padding(.bottom)
                    Spacer()
                }
            }

        }
        .padding()
        .padding(.top, 50)
        .navigationTitle(Text("피드백"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct UserFeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            UserFeedbackView()
        }
    }
}


