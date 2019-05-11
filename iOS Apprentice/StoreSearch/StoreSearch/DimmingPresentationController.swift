//
//  DimmingPresentationController.swift
//  StoreSearch
//
//  Created by Maksim Nosov on 11/05/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class DimmingPresentationController: UIPresentationController {
    lazy var dimmingView = GradientView(frame: CGRect.zero)
    
    // Не удалять View которая презентовала. Видно на заднем фоне.
    override var shouldRemovePresentersView: Bool {
        return false
    }
    
    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView!.bounds // Сделать размеры view с градиентом как у view с которой запустили презентацию pop-up окна
        containerView?.insertSubview(dimmingView, at: 0) // Поместить view с градиентом поздаи встех view в стеке после SearchViewController и перед DetailViewController
    }
}
