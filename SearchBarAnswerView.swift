import SwiftUI

struct SearchBarAnswerView: View {
    let aiGeneratedText: String

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Image(systemName: "quote.opening")
                        .imageScale(.medium)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .clipped()
                        .font(.title3)
                        .padding(.bottom)
                    Text(aiGeneratedText)
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineSpacing(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .clipped()
                }
                .padding()
                HStack {
                    VStack(alignment: .leading) {
                        Text("Overskrift")
                            .font(.system(.subheadline, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .clipped()
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background {
                    RoundedRectangle(cornerRadius: 0, style: .continuous)
                        .fill(Color(.systemGray5))
                }
            }
            .frame(width: 380)
            .clipped()
            .background {
                Rectangle()
                    .fill(Color(.systemGray6))
            }
            .mask {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
            }
        }
    }
}
