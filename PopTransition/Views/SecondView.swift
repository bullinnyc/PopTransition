//
//  SecondView.swift
//  PopTransition
//
//  Created by Dmitry Kononchuk on 19.02.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

struct SecondView: View {
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.indigo
                .opacity(0.5)
                .ignoresSafeArea()
            
            NavigationLink("Show third view") {
                ThirdView()
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
    }
}

// MARK: - Preview

#Preview {
    SecondView()
}
