import SwiftUI

@main
struct SwiftOpenAI_StreamingResponseApp: App {
    
    @StateObject var vm = ViewModel(api: ChatGPTAPI(apiKey: "INSERT_API_KEY"))
    @State var isShowingPrompt = false
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(vm: vm)
                    .toolbar {
                        ToolbarItem {
                            Button("Clear") {
                                vm.clearMessages()
                            }
                            .disabled(vm.isInteractingWithChatGPT)
                        }
                        
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Prompt") {
                                self.isShowingPrompt = true
                            }
                            .disabled(vm.isInteractingWithChatGPT)
                        }
                    }
            }
            .fullScreenCover(isPresented: $isShowingPrompt) {
                PromptView(viewModel: vm)
            }
        }
    }
}

