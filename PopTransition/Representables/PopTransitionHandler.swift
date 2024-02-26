//
//  PopTransitionHandler.swift
//  PopTransition
//
//  Created by Dmitry Kononchuk on 19.02.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

enum TransitionType {
    case swipe
    case button
}

enum TransitionState {
    case start(type: TransitionType)
    case finish(type: TransitionType)
    case interactiveSwipeChange
    case interactiveSwipeCancel
}

struct PopTransitionHandler: UIViewControllerRepresentable {
    // MARK: - Public Properties
    
    let onPopTransition: (_ state: TransitionState) -> Void
    
    // MARK: - Public Methods
    
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<PopTransitionHandler>
    ) -> UIViewController {
        context.coordinator
    }
    
    func updateUIViewController(
        _ uiViewController: UIViewController,
        context: UIViewControllerRepresentableContext<PopTransitionHandler>
    ) {}
    
    func makeCoordinator() -> PopTransitionCoordinator {
        PopTransitionCoordinator(onPopTransition: onPopTransition)
    }
}

// MARK: - Ext. PopTransitionCoordinator

extension PopTransitionHandler {
    final class PopTransitionCoordinator: UIViewController {
        // MARK: - Private Properties
        
        private let onPopTransition: (_ state: TransitionState) -> Void
        private var navigationStackCounter = 0
        
        // MARK: - Initializers
        
        init(onPopTransition: @escaping (_ state: TransitionState) -> Void) {
            self.onPopTransition = onPopTransition
            
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Override Methods
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            guard let navigationController = navigationController else {
                return
            }
            
            navigationStackCounter = navigationController.viewControllers.count
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            guard isPopTransition() else { return }
            
            transitionCoordinator?.animate(
                alongsideTransition: { [weak self] context in
                    if context.isInteractive {
                        // Start interactive swipe transition.
                        self?.onPopTransition(.start(type: .swipe))
                    } else {
                        // Start back button transition.
                        self?.onPopTransition(.start(type: .button))
                    }
                },
                completion: { [weak self] context in
                    guard !context.isCancelled else {
                        // Cancel interactive swipe transition.
                        self?.onPopTransition(.interactiveSwipeCancel)
                        return
                    }
                    
                    if context.initiallyInteractive {
                        // Finish interactive swipe transition.
                        self?.onPopTransition(.finish(type: .swipe))
                    } else {
                        // Finish back button transition.
                        self?.onPopTransition(.finish(type: .button))
                    }
                }
            )
            
            transitionCoordinator?
                .notifyWhenInteractionChanges { [weak self] _ in
                    // Interactive swipe transition.
                    // Finger lifted up or moved back to left edge.
                    self?.onPopTransition(.interactiveSwipeChange)
                }
        }
        
        // MARK: - Private Methods
        
        private func isPopTransition() -> Bool {
            guard let navigationController = navigationController else {
                return false
            }
            
            let navigationStackCount = navigationController
                .viewControllers
                .count
            
            return navigationStackCount < navigationStackCounter
        }
    }
}

// MARK: - Ext. View

extension View {
    func onPopTransition(
        _ perform: @escaping (_ state: TransitionState) -> Void
    ) -> some View {
        background(PopTransitionHandler(onPopTransition: perform))
    }
}
