import SwiftUI
import AVKit

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var vm: ViewModel
    @FocusState var isTextFieldFocused: Bool
    @State var isShowingSecondaryView = false  // State to control whether the secondary view is showing
    
    var body: some View {
        NavigationView {
            chatListView
                .navigationBarTitleDisplayMode(.automatic)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Spacer()
                            Text("Matplanleggern")
                                .font(.headline)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            Spacer()
                        }
                    }
                }
                .navigationBarItems(
                    leading: Button(action: {
                        // Action for 'back' button
                    }) {
                        Image(systemName: "arrow.left")
                    },
                    trailing: HStack {
                        Button(action: {
                            isShowingSecondaryView = true
                        }) {
                            Image(systemName: "rectangle.3.offgrid.fill")
                        }
                        Button(action: {
                            // Action for 'settings' button
                        }) {
                            Image(systemName: "gear")
                        }
                    }
                )
                .sheet(isPresented: $isShowingSecondaryView) {  // The .sheet modifier presents the secondary view as a modal sheet
                    SecondaryView(vm: vm, isShowing: $isShowingSecondaryView)
                }
        }
    }
    var chatListView: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                ScrollView {
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
                Divider()
                bottomView(image: "profile", proxy: proxy)
                #endif
            }
            .onChange(of: vm.messages.last?.responseText) { _ in  scrollToBottom(proxy: proxy)
            }
        }
        .background(colorScheme == .light ? .white : Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 0.5))
    }

    func bottomView(image: String, proxy: ScrollViewProxy) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            VStack(alignment: .leading, spacing: 8) {
                if vm.isInteractingWithChatGPT {
                    DotLoadingView().frame(width: 60, height: 30, alignment: .center) // Align the dots to the center
                }

                HStack(alignment: .center, spacing: -10) { // Adjust spacing to push the button a bit to the right
                    TextField("Send message", text: $vm.inputMessage, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .disabled(vm.isInteractingWithChatGPT)
                        .padding(.leading, 0) // Adjust padding to make symmetric
                }
                .padding(.top, 8)
            
            }

            Button {
                Task { @MainActor in
                    await vm.sendTapped()
                }
            } label: {
                HStack {
                    Text("Send")
                        .foregroundColor(.white)
                    Image(systemName: "paperplane")
                        .imageScale(.small)
                        .symbolRenderingMode(.monochrome)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.white)
                .font(.system(.headline, weight: .semibold))
                .padding(.vertical, 4) // Adjust the padding to reduce the height of the button
                .clipped()
                .background(Color(.displayP3, red: 157/255, green: 188/255, blue: 138/255))
                .mask { RoundedRectangle(cornerRadius: 40, style: .continuous) }
                .padding()
                .shadow(color: .primary.opacity(0.1), radius: 8, x: 0, y: 4)
            }
            .disabled(vm.inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .buttonStyle(.borderless)
            .keyboardShortcut(.defaultAction)
            .foregroundColor(.accentColor)
        }
        .padding(.horizontal, 8)
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = vm.messages.last?.id else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }
}

struct SecondaryView: View {
    @ObservedObject var vm: ViewModel
    @Binding var isShowing: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if vm.isInteractingWithChatGPT {
                DotLoadingView().frame(width: 60, height: 30, alignment: .center) // Align the dots to the center
            }

            ForEach(vm.systemPrompts, id: \.self) { prompt in
                Button(action: {
                    vm.updateSystemPrompt(selectedPrompt: prompt)
                    print("System prompt updated to: \(vm.selectedPrompt)")
                }) {
                    Text(prompt)
                        .foregroundColor(vm.selectedPrompt == prompt ? .white : .primary)
                        .padding()
                        .background(vm.selectedPrompt == prompt ? .blue : .clear)
                        .cornerRadius(10)
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContentView(vm: ViewModel(api: ChatGPTAPI(apiKey:"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")))
        }
    }
}

