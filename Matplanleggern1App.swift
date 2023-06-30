import SwiftUI
import FirebaseCore
import GoogleSignIn
import AuthenticationServices

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct MatplanleggernApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var loginState = LoginState()
    // Create a ViewModel instance here
    @StateObject var viewModel = ViewModel(api: ChatGPTAPI(apiKey: "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")) // replace "YOUR_API_KEY" with your actual API key

    var body: some Scene {
        WindowGroup {
            NavigationView {
                if loginState.isLoggedIn {
                    ContentView(vm: viewModel) // pass the ViewModel instance
                        .environmentObject(loginState)
                } else {
                    LoginView()
                        .environmentObject(loginState)
                        .environmentObject(AuthenticationViewModel())
                }
            }
        }
    }
}
