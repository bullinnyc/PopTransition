//
//  ThirdView.swift
//  PopTransition
//
//  Created by Dmitry Kononchuk on 19.02.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

struct ThirdView: View {
    // MARK: - Property Wrappers
    
    @State private var isPresented = false
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.mint
                .opacity(0.5)
                .ignoresSafeArea()
            
            Button("Show modal view") {
                isPresented.toggle()
            }
        }
        .onPopTransition { transitionState in
            switch transitionState {
            case .start(let type):
                print("Start transition with: \(type)")
            case .finish(let type):
                print("Finish transition with: \(type)")
            case .interactiveSwipeChange:
                print("Finger lifted up or moved back to left edge.")
            case .interactiveSwipeCancel:
                print("Interactive swipe transition cancel.")
            }
        }
        .sheet(isPresented: $isPresented) {
            ZStack {
                Color.pink
                    .opacity(0.5)
                    .ignoresSafeArea()
                
                Button("Dismiss") {
                    isPresented.toggle()
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ThirdView()
}
