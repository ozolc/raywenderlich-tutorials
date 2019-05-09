//
//  MyTabBarController.swift
//  MyLocations
//
//  Created by Maksim Nosov on 09/05/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {
    // Задать светлый фон для UIStatusBar - часы, сигнал, заряд батареи сверху экрана устройства
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Переопределить фон для UIStatusBar для child View Controllers
    override var childForStatusBarStyle: UIViewController? {
        return nil
    }
}
