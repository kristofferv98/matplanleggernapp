import Foundation
import SwiftUI
import Combine

class LoginState: ObservableObject {
    @Published var isLoggedIn: Bool = false
}
