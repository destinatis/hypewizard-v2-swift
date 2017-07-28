//
//  AppDelegate.swift
//  hypewizard
//
//  Created by Konstantin Yurchenko on 1/30/16.
//  Copyright © 2016 Disruptive Widgets. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

let kDatabaseTimeStringFormat:String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

let ERROR_NOT_FOUND = 102
let ERROR_USER_EXISTS = 103

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var push_token: String = ""

    var navigation_controller: UINavigationController!
    var activity_view_controller: ViewController_Activity!
    var is_debug_mode_on: Bool = false
    
//    func grabStoryboard() -> UIStoryboard {
//        var storyboard = UIStoryboard()
//        let height = UIScreen.main.bounds.size.height
//        
//        if height == 480 {
//            storyboard = UIStoryboard(name: "Main3.5", bundle: nil)
//        } else if height == 568 {
//            storyboard = UIStoryboard(name: "Main4.0", bundle: nil)
//        } else if height == 736 {
//            storyboard = UIStoryboard(name: "Main5.5", bundle: nil)
//        } else {
//            storyboard = UIStoryboard(name: "Main4.7", bundle: nil)
//        }
//        print("selected storyboard: \(storyboard)")
//        
//        return storyboard
//    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        
//        self.initialize_notification_services(application: application)
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            window.backgroundColor = UIColor.white
            
            self.navigation_controller = UINavigationController(rootViewController: ViewController_Activity())
            self.navigation_controller.setNavigationBarHidden(true, animated: false)
            window.rootViewController = self.navigation_controller
            
            window.makeKeyAndVisible()
        }
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            self.start()
        }
        
        return true
    }
    
    func start() {
        let view_controller = ViewController_PromoStart()
        
        self.navigation_controller.pushViewController(
            view_controller,
            animated: false
        )
    }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        return GIDSignIn.sharedInstance().handle(url,
//                                                    sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
//                                                    annotation: options[UIApplicationOpenURLOptionsKey.annotation])
//    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: Notifications
    func initialize_notification_services(application: UIApplication) -> Void {
        print("initialize_notification_services")

        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        application.registerForRemoteNotifications()
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print("deviceToken: \(deviceToken)")
        
        self.push_token = self.convert_device_token_to_string(deviceToken: deviceToken as NSData)
        print("self.push_token: \(self.push_token)")
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Device token for push notifications: FAIL -- ")
        print(error.localizedDescription)
    }
    private func convert_device_token_to_string(deviceToken: NSData) -> String {
        
        var device_token_string = deviceToken.description.replacingOccurrences(of: ">", with: "")
        device_token_string = device_token_string.replacingOccurrences(of: "<", with: "")
        device_token_string = device_token_string.replacingOccurrences(of: " ", with: "")
        
        return device_token_string
    }
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        print(userInfo)
    }
    func update_push_token_for_user() {
        print("update_push_token_for_user")
        
//        let parameters = [
//            "push_token": self.push_token as AnyObject,
//            "user_id": "\(self.me.id)" as AnyObject,
//            "api_token": self.me.api_token as AnyObject
//            ] as [String: AnyObject]
//        
//        RestApiManager.sharedInstance.update_user_settings(parameters: parameters) { response in
//            if let error_code = response["error_code"] {
//                if error_code as! Int == 0 {
//                    print("ok")
//                } else {
//                    print("error")
//                }
//            }
//        }
    }
    // MARK: Notifications
    
    // MARK: Activity Controller
    func show_activity_view_controller(message: String) {
        self.activity_view_controller = ViewController_Activity()
        self.navigation_controller.pushViewController(self.activity_view_controller, animated: false)
    }
    func remove_activity_view_controller() {
        sleep(1)
        self.navigation_controller.popViewController(animated: false)
    }
    // MARK: Activity Controller
}
// MARK: Extensions
extension Bundle {
    
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
    var deviceId: String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
}
extension NSDate {
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.current.component(.year, from: date as Date)
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.current.component(.month, from: date as Date)
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.current.component(.weekOfYear, from: date as Date)
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.current.component(.day, from: date as Date)
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.current.component(.hour, from: date as Date)
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.current.component(.minute, from: date as Date)
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.current.component(.second, from: date as Date)
    }
    func offsetFrom(date:NSDate) -> String {
        if yearsFrom(date: date)   > 0 { return "\(yearsFrom(date: date))y"   }
        if monthsFrom(date: date)  > 0 { return "\(monthsFrom(date: date))M"  }
        if weeksFrom(date: date)   > 0 { return "\(weeksFrom(date: date))w"   }
        if daysFrom(date: date)    > 0 { return "\(daysFrom(date: date))d"    }
        if hoursFrom(date: date)   > 0 { return "\(hoursFrom(date: date))h"   }
        if minutesFrom(date: date) > 0 { return "\(minutesFrom(date: date))m" }
        if secondsFrom(date: date) > 0 { return "\(secondsFrom(date: date))s" }
        return ""
    }
    func dateFromISO8601String(dateString: String) -> NSDate {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        dateFormatter.dateFormat = kDatabaseTimeStringFormat
        
        return dateFormatter.date(from: dateString)! as NSDate
    }
    func convertToString() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ssa zzz"
        return dateFormatter.string(from: self as Date)
    }
}
extension UIScrollView {
    func updateContentViewSize() {
        var newHeight: CGFloat = 0
        for view in subviews {
            let ref = view.frame.origin.y + view.frame.height
            if ref > newHeight {
                newHeight = ref
            }
        }
        let oldSize = contentSize
        let newSize = CGSize(width: oldSize.width, height: newHeight + 20)
        contentSize = newSize
    }
}
extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
