import SwiftUI
import FirebaseAuth
import Firebase
import GoogleSignIn
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var loginState: LoginState
    @State private var showEmailLogin = false
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel

    @State private var email = ""
    @State private var password = ""

    @Environment(\.presentationMode) var presentationMode
    @FocusState private var focus: FocusableField?

    private enum FocusableField: Hashable {
        case email
        case password
    }

    private func signInWithEmailPassword() {
        Task {
            let success = await authenticationViewModel.signInWithEmailPassword()
            loginState.isLoggedIn = success
        }
    }

    private func signInWithGoogle() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }

        authenticationViewModel.signInWithGoogle(presentationAnchor: window) { result in
            switch result {
            case .success:
                print("Google sign-in successful")
                loginState.isLoggedIn = true
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.systemGray6).edgesIgnoringSafeArea(.all)

                VStack {
                    Image("Profile")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.5)
                        .clipped()
                        .overlay(alignment: .topLeading) {
                            VStack(alignment: .leading, spacing: 11) {
                                VStack(alignment: .leading, spacing: 1) {
                                    Text("Matplanleggern")
                                        .font(.system(.largeTitle, weight: .medium))
                                        .foregroundColor(Color(.sRGB, red: 0.15, green: 0.15, blue: 0.15))
                                    Text("Velkommen")
                                        .font(.system(.headline, weight: .medium))
                                        .frame(width: 190, alignment: .leading)
                                        .clipped()
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(.black)
                                }
                            }
                            .padding()
                            .padding(.top, 20)
                        }
                        .mask {
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                        }
                        .padding()
                        .padding(.top, geometry.safeAreaInsets.top + 20)
                        .shadow(color: Color(.sRGBLinear, red: 0/255, green: 0/255, blue: 0/255).opacity(0.15), radius: 50, x: 0, y: 18)

                    Button(action: {
                        showEmailLogin.toggle()
                    }) {
                        Text("Log In with Email")
                            .foregroundColor(.white)
                            .padding(.horizontal, 60)
                            .padding(.vertical, 8.5)
                            .background(Color.orange.opacity(0.75))
                            .cornerRadius(6)
                    }
                    .padding(.top, 5)
                    .sheet(isPresented: $showEmailLogin) {
                        EmailLoginView()
                            .environmentObject(authenticationViewModel)
                            .environmentObject(loginState)
                    }

                    Button(action: signInWithGoogle) {
                        HStack {
                            Image(systemName: "g.circle")
                            Text("Sign In with Google")
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 38)
                        .padding(.vertical, 8.5)
                        .background(Color.red.opacity(0.75))
                        .cornerRadius(6)
                    }
                    .padding(.top, 5)

                    if #available(iOS 14.0, *) {
                        SignInWithAppleButton(.signIn, onRequest: { request in
                            request.requestedScopes = [.fullName, .email]
                        }, onCompletion: { result in
                            switch result {
                            case .success(let authResults):
                                authenticationViewModel.handleAppleSignIn(authorization: authResults) { signInResult in
                                    switch signInResult {
                                    case .success:
                                        loginState.isLoggedIn = true
                                    case .failure(let error):
                                        print("Error: \(error.localizedDescription)")
                                    }
                                }
                            case .failure(let error):
                                print("Error: \(error.localizedDescription)")
                            }
                        })
                        .frame(minWidth: 200, maxWidth: 250, minHeight: 40, maxHeight: 40)
                        .cornerRadius(6)
                        .padding(.top, 5)
                    }

                    Button(action:{
                        loginState.isLoggedIn = true
                    }) {
                        Text("Continue as Guest")
                            .foregroundColor(.white)
                            .padding(.horizontal, 55)
                            .padding(.vertical, 8.5)
                            .background(Color.gray.opacity(0.75))
                            .cornerRadius(6)
                    }
                    .padding(.top, 5)

                    NavigationLink(destination: SignUpView()) {
                        Text("Don't have an account? Sign Up")
                            .foregroundColor(.blue)
                            .padding(.bottom, 140)
                    }
                    .padding()
                }
            }
            .background(Color(.systemGray6))
        }
    }

    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            LoginView()
        }
    }
}

