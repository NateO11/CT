//
//  CTApp.swift
//  CT
//
//  Created by Nate Owen on 12/10/23.
//

import SwiftUI
import Firebase
import FirebaseCore


//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//
//    return true
//  }
//}

@main
struct YourApp: App {
//  // register app delegate for Firebase setup
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    init() {
        FirebaseApp.configure()
    }
    @StateObject var viewModel = AuthViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView().environmentObject(viewModel)
            }
        }
    }
}
