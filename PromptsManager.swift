import Foundation

class PromptManager: ObservableObject {
    @Published var systemPrompts: [String: (role: String, prompt: String)] = [
        "Prompt 1": ("Role 1", "System Prompt 1"),
        "Prompt 2": ("Role 2", "System Prompt 2"),
        "Prompt 3": ("Role 3", "System Prompt 3"),
        "Prompt 4": ("Role 4", "System Prompt 4")
    ]
    
    @Published var currentPrompt: String = ""
    @Published var currentRole: String = ""
    
    func updatePrompt(prompt: String) {
        guard let promptData = systemPrompts[prompt] else {
            print("Invalid prompt selected")
            return
        }
        
        currentPrompt = promptData.prompt
        currentRole = promptData.role
    }
}
