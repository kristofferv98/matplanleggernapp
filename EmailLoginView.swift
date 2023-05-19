
import SwiftUI

struct EmailLoginView: View {
    @EnvironmentObject var loginState: LoginState
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

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .focused($focus, equals: .email)
                .submitLabel(.next)
                .onSubmit {
                    self.focus = .password
                }

            SecureField("Password", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($focus, equals: .password)
                .submitLabel(.go)
                .onSubmit {
                    signInWithEmailPassword()
                }

            Button(action: signInWithEmailPassword) {
                Text("Log In")
                    .foregroundColor(.white)
                    .padding(.horizontal, 45)
                    .padding(.vertical, 8.5)
                    .background(Color.blue.opacity(0.9))
                    .cornerRadius(6)
            }
            .padding(.top, 5)
            }
        }
    }


struct EmailLoginView_Previews: PreviewProvider {
    static var previews: some View {
        EmailLoginView()
    }
}
