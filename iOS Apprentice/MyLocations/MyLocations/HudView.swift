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
        
        hudView.show(animated: true)
        return hudView
    }
    
    // draw() метод вызывается UIKit самостоятельно, для перерисовки view. Если надо перерисовать view - вызвать setNeedsDisplay()
    override func draw(_ rect: CGRect) {
        let boxWidth: CGFloat = 96
        let boxHeight: CGFloat = 96
        
        let boxRect = CGRect(x: round((bounds.size.width - boxWidth) / 2),
                             y: round((bounds.size.height - boxWidth) / 2),
                             width: boxWidth,
                             height: boxHeight)
        
        let roundRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
        UIColor(white: 0.3, alpha: 0.8).setFill()
        roundRect.fill()
        
        // Отрисовка checkmark
        if let image = UIImage(named: "Checkmark") {
            let imagePoint = CGPoint(x: center.x - round(image.size.width / 2),
                                     y: center.y - round(image.size.height / 2) - boxHeight / 8)
        
            image.draw(at: imagePoint)
        }
        
        // Отрисовка теста
        let attribs  = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white ]
        
        let textSize = text.size(withAttributes: attribs)
        
        let textPoint = CGPoint(x: center.x - round(textSize.width / 2),
                                y: center.y - round(textSize.height / 2) + boxHeight / 4)
        
        text.draw(at: textPoint, withAttributes: attribs)
    }
    
    // MARK:- Public methods
    func show(animated: Bool) {
        if animated {
            // Задаем начальные значения.
            alpha = 0 // Полностью прозрачный View
            transform = CGAffineTransform(scaleX: 1.3, y: 1.3) // увеличенные размеры на 30%
            
            // Изменить значения с начальных на заданные в замыкании в течении 0.3 секунды
//            UIView.animate(withDuration: 0.3) {
//                self.alpha = 1
//                self.transform = CGAffineTransform.identity // identity - первоначальное значение (отмена Scale)
//            }

            UIView.animate(withDuration: 0.3, delay: 0,
                usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5,
                options: [], animations: {
                self.alpha = 1
                self.transform = CGAffineTransform.identity
                }, completion: nil)
            
        }
    }
}
