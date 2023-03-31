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
//        addToken()
        
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
        print("Device token: ", deviceToken) // This token can be used for testing notifications on FCM
        
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


//class PushNotificationSender {
//    func sendPushNotification(to token: String, title: String, body: String) {
//        let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
//        var request = URLRequest(url: url)
//        let body: [String: Any] = [
//            "to": token,
//            "notification": [
//                "title": title,
//                "body": body
//            ]
//        ]
////        let body: [String: Any] = [
////            "notification": [
////                "title": title,
////                "body": body,
////                "sound": "default",
////                "badge": 0
////            ],
////            "data": [
////                "key_1": "Value_1",
////                "key_2": 2
////            ],
////            "content_available": true,
////            "mutable_content": true,
////            "priority": "high",
////            "to": token
////        ]
////        let request = NSMutableURLRequest(url: url as URL)
//        request.httpMethod = "POST"
//        request.httpBody = try? JSONSerialization.data(withJSONObject:body, options: [.prettyPrinted])
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("AAAAmgIQJT8:APA91bEYeo_vCw2JzuCiVcAeaZMjlGq_uJV8UtHYykPu-_9yQuiNlwtz6-obJWkIfeCLz6fljjhdhfMmLiCrG8sZ8AjerFunTwxG08af61sJzrFovijmELKPES4eeFmvuG3-kVa-IIip", forHTTPHeaderField: "Authorization")
//        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
//            do {
//                if let jsonData = data {
//                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
//                        NSLog("Received data:\n\(jsonDataDict))")
//                    }
//                }
//            } catch let err as NSError {
//                print(err.debugDescription)
//            }
//        }
//        task.resume()
////        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
////            if let error = error {
////                print("Error: \(error.localizedDescription)")
////                return
////            }
////
////            guard let data = data else {
////                print("Error: No data returned from server")
////                return
////            }
////
////            do {
////                let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
////                if let jsonDataDict = jsonData as? [String: AnyObject] {
////                    print("Received data:\n\(jsonDataDict))")
////                }
////            } catch let error as NSError {
////                print("Error parsing data: \(error.localizedDescription)")
////            }
////        }
////        task.resume()
//    }
//}

//gpt try 1
class PushNotificationSender {
    
    var serverKeyString: String


//    let serverKey: String
//
    init(serverKeyString: String) {
        self.serverKeyString = serverKeyString
    }

    func sendPushNotification(to deviceToken: String, title: String, message: String) {

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

//        let payload: [String: Any] = [
//            "message": [
//                "token": deviceToken,
//                "notification": [
//                    "title": "Your app name",
//                    "body": message,
//                    "click_action": "FLUTTER_NOTIFICATION_CLICK"
//                ]
//            ]
//        ]

//        let paramString: [String : Any] = ["to" : deviceToken,
//                                           "notification" : ["title" : title, "body" : message],
//                                           "data" : ["user" : "test_id"]
//        ]
        let body: [String: Any] = [
            "notification": [
                "title": title,
                "body": message,
                "sound": "default",
                "badge": 1
            ],
            "data": [
                "key_1": "Value_1",
                "key_2": 2
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

// gpt try2
//class PushNotificationSender {
//    let serverKey: String
//
//    init(serverKey: String) {
//        self.serverKey = serverKey
//    }
//
//    func sendPushNotification(deviceToken: String, message: String) {
//        let url = URL(string: "https://fcm.googleapis.com/v1/projects/grain-final/databases/messages:send")!
////        let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
//        let body: [String: Any] = [
//            "to": deviceToken,
//            "notification": [
//                "title": "Your app name",
//                "body": message
//            ]
//        ]
//        let bodyData = try! JSONSerialization.data(withJSONObject: body)
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpBody = bodyData
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
//
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                print("Error sending push notification: \(error.localizedDescription)")
//                return
//            }
//
//            if let data = data, let dataString = String(data: data, encoding: .utf8) {
//                print("Push notification response: \(dataString)")
//            }
//        }
//        task.resume()
//    }
//
//    func send(key: String, deviceToken: String) {
////        let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
//        let url = URL(string: "https://fcm.googleapis.com/v1/projects/grain-final/databases/messages:send")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("key=\(key)", forHTTPHeaderField: "Authorization")
//
//        let message = ["to": deviceToken, "notification": ["title": "Title", "body": "Body"]] as [String : Any]
//
//        let jsonData = try! JSONSerialization.data(withJSONObject: message, options: [])
//        request.httpBody = jsonData
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error sending push notification: \(error.localizedDescription)")
//            } else if let data = data {
//                let responseString = String(data: data, encoding: .utf8)!
//                print("Push notification sent: \(responseString)")
//            }
//        }
//        task.resume()
//    }
//}

// gpt 3
//class PushNotificationSender {
//    func sendNotification(to token: String, title: String, body: String, data: [String: Any]) {
//        let urlString = "https://fcm.googleapis.com/fcm/send"
//        guard let url = URL(string: urlString) else { return }
//        let paramString: [String : Any] = ["to" : token,
//                                           "notification" : ["title" : title, "body" : body],
//                                           "data" : data]
//        let request = NSMutableURLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("key=YOUR_SERVER_KEY", forHTTPHeaderField: "Authorization")
//        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
//            do {
//                if let jsonData = data {
//                    if let jsonDataDict = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
//                        print("Received data: \(jsonDataDict)")
//                    }
//                }
//            } catch let err as NSError {
//                print(err.debugDescription)
//            }
//        }
//        task.resume()
//    }
//
//}
