//
//  ModalView.swift
//  Matplanleggern2
//
//  Created by Kristoffer Vatnehol on 02/06/2023.
//

import SwiftUI

struct ModalView: View {
    @Binding var showModal: Bool

    var body: some View {
        VStack {
            Spacer(minLength: 100) // Or however much space you want to leave at the top
                    
            // Your modal content here
            Text("Hello, this is modal!")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .edgesIgnoringSafeArea(.all)
        }
        .transition(.move(edge: .top))
        .animation(.easeInOut)
        .onTapGesture {
            withAnimation {
                showModal = false
            }
        }
    }
}

