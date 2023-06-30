import SwiftUI
import Foundation

struct WelcomeView: View {
    @Binding var showWelcome: Bool
    
    @State private var opacity: Double = 0
    
    private func animateAndNavigate() {
        withAnimation(.easeIn(duration: 0.5)) {
            opacity = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeOut(duration: 0.5)) {
                opacity = 0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showWelcome = false
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("MATPLANLEGGERN")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("You are logged in")
                .font(.headline)
                .padding(.bottom)
        }
        .opacity(opacity)
        .onAppear(perform: animateAndNavigate)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(showWelcome: .constant(true))
    }
}
