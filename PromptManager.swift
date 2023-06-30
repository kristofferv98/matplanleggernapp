import SwiftUI

struct PromptManager: View {
    @Binding var selectedPrompt: String // Add this line

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Filters")
                            .font(.system(.largeTitle, weight: .medium))
                            .foregroundColor(.black.opacity(0.76))
                        imageCard(imageName: "Image 5", prompt: "Recipe")
                        imageCard(imageName: "Image 1", prompt: "Tools and tips")
                        imageCard(imageName: "Image 3", prompt: "Meal planer")
                        imageCard(imageName: "Image 2", prompt: "Leftovers and budget")
                        imageCard(imageName: "Image", prompt: "NOT FOOD")
                    }
                    .padding(.top, 72)
                    .padding()
                    .padding(.bottom)
                }
                .background {
                    RoundedRectangle(cornerRadius: 40, style: .continuous)
                        .fill(Color(.displayP3, red: 130/255, green: 94/255, blue: 98/255).opacity(0.21))
                        .ignoresSafeArea()
                }
            }
            .padding(.top, 72)
            .padding()
            .padding(.bottom)
        }
        .background {
            RoundedRectangle(cornerRadius: 0, style: .continuous)
                .fill(Color(.displayP3, red: 130/255, green: 94/255, blue: 98/255).opacity(0.21))
                .ignoresSafeArea()
        }
    }
    @ViewBuilder
        func imageCard(imageName: String, prompt: String) -> some View {
        Image(imageName)
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 300, height: 270)
            .clipped()
            .overlay(alignment: .bottomLeading) {
                HStack {
                    Text(prompt)
                    Spacer()
                    Button(action: {
                               self.selectedPrompt = prompt
                           }) {
                        Image(systemName: "plus")
                    }
                }
                .padding()
                .foregroundColor(.white)
                .font(.system(.title3, weight: .semibold))
            }
            .mask {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
            }
            .padding(3)
            .background(alignment: .bottom) {
                LinearGradient(gradient: Gradient(colors: [Color(.systemGray6), Color(.systemFill)]), startPoint: .trailing, endPoint: .leading)
                    .mask {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                    }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .clipped()
    }
    struct PromptManager_Previews: PreviewProvider {
        @State static var prompt: String = ""
        
        static var previews: some View {
            PromptManager(selectedPrompt: $prompt)
        }
    }
}
