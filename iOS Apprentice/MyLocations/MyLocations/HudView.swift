//
//  HudView.swift
//  MyLocations
//
//  Created by Maksim Nosov on 07/05/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class HudView: UIView {
    var text = ""
    
    // Метод класса - covenience constructor
    class func hud(inView view: UIView, animated: Bool) -> HudView {
        let hudView = HudView(frame: view.bounds)
        hudView.isOpaque = false // Установили прозрачность
        
        view.addSubview(hudView) // Добавить в иерархию к родителю view
        view.isUserInteractionEnabled = false // Неактивно к взаимодействию родительское вью.
        
        hudView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        return hudView
    }
}
