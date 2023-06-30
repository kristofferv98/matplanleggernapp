import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10) // gir knappen rundede hjørner
    }
}

struct PromptView: View {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
            Button("Done") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding(7)
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(10)
            Text("Select a Prompt")
                .font(.headline)
            
            
            Button("Shopping list") {
                let prompt2 = "Make a shopping list for food items as per the user request. "
                viewModel.clearMessages()
                viewModel.api.updateSystemPrompt(selectedPrompt: prompt2)
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(CustomButtonStyle())
            
            Button("Matretter") {
                let prompt3 = "Act like a colunary expert. Make detailed recipes based on the users request."
                viewModel.clearMessages()
                viewModel.api.updateSystemPrompt(selectedPrompt: prompt3)
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(CustomButtonStyle())
        }
    }
}

struct PromptView_Previews: PreviewProvider {
    static var previews: some View {
        let chatGPTAPI = ChatGPTAPI(apiKey: "INSERT_API_KEY")
        let viewModel = ViewModel(api: chatGPTAPI)
        NavigationStack {
            PromptView(viewModel: viewModel)
        }
    }
}
