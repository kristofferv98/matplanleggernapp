import SwiftUI
import AVKit

struct ContentView: View {
    
    // Tip: Consider adding a user setting to switch between light and dark modes manually.
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var vm: ViewModel
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        chatListView
            // Tip: You can replace "Matplanleggern" with your application's name or title.
            .navigationTitle("AI Assistant")
    }
    
    var chatListView: some View {
        ScrollViewReader { proxy in
            // Tip: You can increase the spacing value to make the messages more separated.
            VStack(spacing: 0) {
                ScrollView {
                    // Tip: Increasing the spacing value here will make messages inside a group more separated.
                    LazyVStack(spacing: 0) {
                        ForEach(vm.messages) { message in
                            MessageRowView(message: message) { message in
                                Task { @MainActor in
                                    await vm.retry(message: message)
                                }
                            }
                        }
                    }
                    .onTapGesture {
                        isTextFieldFocused = false
                    }
                }
                #if os(iOS) || os(macOS)
                // Tip: You can style the divider by applying .background() or .foregroundColor().
                Divider()
                bottomView(image: "profile", proxy: proxy)
                Spacer()
                #endif
            }
            .onChange(of: vm.messages.last?.responseText) { _ in  scrollToBottom(proxy: proxy)
            }
        }
        // Tip: You can change the color value for the dark mode to better match your app's color theme.
        .background(colorScheme == .light ? .white : Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 0.5))
    }
    
    func bottomView(image: String, proxy: ScrollViewProxy) -> some View {
        // Tip: You can adjust the alignment and spacing value to better position the elements in the HStack.
        HStack(alignment: .top, spacing: 8) {
            if image.hasPrefix("http"), let url = URL(string: image) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        // Tip: You can adjust the size of the image to your liking.
                        .frame(width: 30, height: 30)
                } placeholder: {
                    // Tip: You can replace the default progress view with a custom spinner.
                    ProgressView()
                }

            } else {
                Image(image)
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            
            // TextField for user to input message
            // (CUSTOMIZABLE): The placeholder text, "Send message", can be changed.
            TextField("Send message", text: $vm.inputMessage, axis: .vertical)
                #if os(iOS) || os(macOS)
                // (CUSTOMIZABLE): You can choose other TextFieldStyle that suits your app's UI theme.
                .textFieldStyle(.roundedBorder)
                #endif
                // Focus state of the TextField is controlled by isTextFieldFocused.
                .focused($isTextFieldFocused)
                // TextField is disabled when the ViewModel is interacting with ChatGPT.
                .disabled(vm.isInteractingWithChatGPT)
            
            // If the ViewModel is currently interacting with ChatGPT, a stop button or a loading view is displayed.
            if vm.isInteractingWithChatGPT {
                #if os(iOS)
                // The stop button allows user to cancel the streaming response from ChatGPT.
                // (CUSTOMIZABLE): The stop button's design can be customized to fit your app's UI theme.
                Button {
                    vm.cancelStreamingResponse()
                } label: {
                    Image(systemName: "stop.circle.fill")
                        .font(.system(size: 30))
                        .symbolRenderingMode(.multicolor)
                        .foregroundColor(.red)
                }
                #else
                // A custom loading view is displayed when the app is not running on iOS.
                // (CUSTOMIZABLE): You can replace DotLoadingView with a custom loading view that suits your app's UI theme.
                DotLoadingView().frame(width: 60, height: 30)
                #endif
            } else {
                // If the ViewModel is not interacting with ChatGPT, a send button is displayed.
                Button {
                    Task { @MainActor in
                        isTextFieldFocused = false
                        scrollToBottom(proxy: proxy)
                        // vm.sendTapped() method is invoked to send the user's message.
                        await vm.sendTapped()
                    }
                } label: {
                    // The send button is represented by a paperplane icon.
                    // (CUSTOMIZABLE): You can replace the paperplane icon with another icon that suits your app's UI theme.
                    Image(systemName: "paperplane.circle.fill")
                        .rotationEffect(.degrees(45))
                        .font(.system(size: 30))
                }
                #if os(macOS)
                // Additional customizations for the send button when the app is running on macOS.
                .buttonStyle(.borderless)
                .keyboardShortcut(.defaultAction)
                .foregroundColor(.accentColor)
                #endif
                // The send button is disabled when the user's input is empty.
                .disabled(vm.inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        // (CUSTOMIZABLE): The padding of the HStack can be adjusted to fit your app's UI design.
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }
    
    // This function scrolls the ScrollView to the bottom when a new message is added.
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = vm.messages.last?.id else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }
}

// A PreviewProvider for ContentView.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            
        }
    }
}
