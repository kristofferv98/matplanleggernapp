import SwiftUI
import AuthenticationServices

struct CustomAppleSignInButton: View {
    var action: (@escaping (Result<Bool, Error>) -> Void) -> Void

    var body: some View {
        Button(action: {
            action { _ in }
        }) {
            HStack {
                Image(systemName: "applelogo")
                    .resizable()
                    .padding([.top, .leading], 10.0)
                    .scaledToFit()
                    .frame(width: 18, height: 30)
                Text("Sign In with Apple")
                    .font(.system(size: 14))
            }
            .foregroundColor(.white)
            .frame(minWidth: 10, maxWidth: 175, minHeight: 30, maxHeight: 30)
            .padding(.horizontal, 40)
            .padding(.vertical, 5)
            .background(Color.black)
            .cornerRadius(6)
        }
    }
}

struct CustomAppleSignInButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomAppleSignInButton(action: { _ in })
    }
}
