//
//  FirstView.swift
//  PopTransition
//
//  Created by Dmitry Kononchuk on 19.02.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

struct FirstView: View {
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            NavigationLink("Show second view") {
                SecondView()
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

// MARK: - Preview

#Preview {
    FirstView()
}
