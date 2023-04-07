//
//  GrainApp.swift
//  Grain
//
//  Created by 조형구 on 2023/01/18.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import Combine
import FirebaseAuth

@main
struct GrainApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @EnvironmentObject var authenticationStore: AuthenticationStore
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(AuthenticationStore())
            
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    @ObservedObject var magazineVM = MagazineViewModel()
    @ObservedObject var communityVM = CommunityViewModel()
    @ObservedObject var userVM = UserViewModel()
    @ObservedObject var editorVM = EditorViewModel()
    
    let gcmMessageIDKey = "gcm.message_id"
    var subscription = Set<AnyCancellable>()
    var updateUsersArraySuccess = PassthroughSubject<(), Never>()
    var fetchCurrentUsersSuccess = PassthroughSubject<CurrentUserFields, Never>()

    // 앱이 켜졌을 때
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Use Firebase library to configure APIs
        // 파이어베이스 설정
        FirebaseApp.configure()
        
        // 메세징 delegate
        Messaging.messaging().delegate = self
            
        // 원격 알림 등록
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        // 푸시 foregorund 설정
        UNUserNotificationCenter.current().delegate = self
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print("userInfo: \(userInfo)")
        
        completionHandler(UIBackgroundFetchResult.newData)
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if let aps = userInfo["aps"] as? [String: Any], let alert = aps["alert"] as? [String: Any], let title = alert["title"] as? String, let body = alert["body"] as? String {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default
            content.userInfo = userInfo
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error displaying remote notification: \(error.localizedDescription)")
                }
            }
        }
        completionHandler(.newData)
    }
    
}

extension AppDelegate: MessagingDelegate {
    // fcm 등록 토큰을 받았을 때
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        let deviceToken:[String: String] = ["token": fcmToken ?? ""]
//        print("Device token: ", deviceToken) // This token can be used for testing notifications on FCM
        
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    // 푸시 메시지가 보여질 때 (앱이 실행 중일 때 푸시 메시지가 나오는 경우)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 푸시 메시지로부터 들어오는 정보
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print("willPresent: userInfo: ", userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([[.banner, .badge, .sound]])
    }
    
    // fcm 토큰이 등록 되었을 때
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    // 푸시 메시지를 받았을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID from userNotificationCenter didReceive: \(messageID)")
        }
        
        print("didReceive: userInfo: ", userInfo)
        
        completionHandler()
    }
    
}


class PushNotificationSender {
    
    var serverKeyString: String


    init(serverKeyString: String) {
        self.serverKeyString = serverKeyString
    }

    func sendPushNotification(to deviceToken: String, title: String, message: String, image: String) {

        if let infolist = Bundle.main.infoDictionary {
            if let serverkeystr = infolist["serverkey"] as? String {
                serverKeyString = serverkeystr
            }
        }
        
        let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(serverKeyString)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = [
            "notification": [
                "title": title,
                "body": message,
                "image": image,
                "sound": "default",
                "badge": 1
            ],
            "data": [
                "view": "view",
                "detailData": "jsonData"
            ],
            "content_available": true,
            "mutable_content": true,
            "priority": "high",
            "to": deviceToken
        ]

        do {
            let data = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = data
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error sending push notification: \(error.localizedDescription)")
                }
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Push notification sent successfully: \(responseString)")
                }
            }
            task.resume()
        } catch {
            print("Error creating JSON payload: \(error.localizedDescription)")
        }
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let rootView = ContentView() // 화면 전환을 원하는 뷰
            let navigationController = UINavigationController(rootViewController: UIHostingController(rootView: rootView))
            window.rootViewController = navigationController
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
