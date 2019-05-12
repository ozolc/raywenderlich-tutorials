//
//  LandscapeViewController.swift
//  StoreSearch
//
//  Created by Maksim Nosov on 11/05/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class LandscapeViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Удалить constraints с main view
        view.removeConstraints(view.constraints)
        // Удалить constraints с page control
        pageControl.removeConstraints(pageControl.constraints)
        pageControl.translatesAutoresizingMaskIntoConstraints = true
        // Удалить constraints с scroll view
        scrollView.removeConstraints(pageControl.constraints)
        scrollView.translatesAutoresizingMaskIntoConstraints = true
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
        
        // Установка рабочей области для scroll view. Может быть больше чем bounds. Это позволяет скроллить
        scrollView.contentSize = CGSize(width: 1000, height: 1000)
    }
    
    // Создание собственного layout. Вызывается UIKit как часть фазы расположения views на view controller'a как когда он впервые появляется на экране. Идеальное место для изменения frames для views вручную.
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let safeFrame = view.safeAreaLayoutGuide.layoutFrame // safe area для view в его собственной системе координат
        scrollView.frame = safeFrame
        pageControl.frame = CGRect(x: safeFrame.origin.x, y: safeFrame.size.height - pageControl.frame.size.height, width: safeFrame.size.width, height: pageControl.frame.size.height)
    }
}
