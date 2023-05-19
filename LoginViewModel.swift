import Foundation
import SwiftUI
import FirebaseAuth

class LoginViewModel: ObservableObject {
    func signInWithGoogle(presentationAnchor: UIWindow, completion: @escaping (Result<Void, Error>) -> Void) {
        let provider = OAuthProvider(providerID: "google.com")
        provider.getCredentialWith(nil) { credential, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let credential = credential {
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
                func signInWithApple(completion: @escaping (Result<Void, Error>) -> Void) {
                        Task.init {
                            guard let window = await getKeyWindow() else {
                                completion(.failure(NSError(domain: "Unable to get key window", code: -1, userInfo: nil)))
                                return
                            }
                            let viewModel = AuthenticationViewModel()
                            viewModel.mainAppWindow = window
                            viewModel.signInWithApple()
                        }
                    }
                }
        }
    }
}
