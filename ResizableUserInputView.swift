//
//  ResizableUserInputView.swift
//  Matplanleggern1
//
//  Created by Kristoffer Vatnehol on 09/05/2023.
//

import SwiftUI

struct ResizableUserInputView: View {
    @Binding var userInput: String

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Image(systemName: "pencil.circle")
                    .imageScale(.medium)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .clipped()
                    .font(.title3)
                    .padding(.bottom)
                TextEditor(text: $userInput)
                    .font(.subheadline)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .lineSpacing(1)
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 150, alignment: .leading)
                    .clipped()
            }
            .padding()
            HStack {
                
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 0, style: .continuous)
                    .fill(Color(.systemGray5))
            }
        }
        .frame(width: 280)
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
