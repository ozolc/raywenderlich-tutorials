//
//  DimmingPresentationController.swift
//  StoreSearch
//
//  Created by Maksim Nosov on 11/05/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class DimmingPresentationController: UIPresentationController {
    
    // Не удалять View которая презентовала. Видно на заднем фоне.
    override var shouldRemovePresentersView: Bool {
        return false
    }
}
