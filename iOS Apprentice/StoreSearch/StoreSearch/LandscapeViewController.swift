//
//  LandscapeViewController.swift
//  StoreSearch
//
//  Created by Maksim Nosov on 11/05/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class LandscapeViewController: UIViewController {
    
    var searchResults = [SearchResult]()
    private var firstTime = true // для проверки, что кнопки с результатами расположились только один раз

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
        
        // Начальное количество страниц для page control
        pageControl.numberOfPages = 0
        
    }
    
    // Создание собственного layout. Вызывается UIKit как часть фазы расположения views на view controller'a как когда он впервые появляется на экране. Идеальное место для изменения frames для views вручную.
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let safeFrame = view.safeAreaLayoutGuide.layoutFrame // safe area для view в его собственной системе координат
        scrollView.frame = safeFrame
        pageControl.frame = CGRect(x: safeFrame.origin.x, y: safeFrame.size.height - pageControl.frame.size.height, width: safeFrame.size.width, height: pageControl.frame.size.height)
        
        if firstTime {
            firstTime = !firstTime
            tileButtons(searchResults)
        }
    }
    
    // MARK: - Private Methods
    private func tileButtons(_ searchResults: [SearchResult]) {
        var columnsPerPage = 6
        var rowsPerPage = 3
        var itemWidth: CGFloat = 94
        var itemHeight: CGFloat = 88
        var marginX: CGFloat = 2
        var marginY: CGFloat = 20
        
        let viewWidth = scrollView.bounds.size.width
        
        switch viewWidth {
        case 568:
            // 4-inch device
            break
            
        case 667:
            // 4.7-inch device
            columnsPerPage = 7
            itemWidth = 95
            itemHeight = 98
            marginX = 1
            marginY = 29
            
        case 736:
            // 5.5-inch device
            columnsPerPage = 8
            rowsPerPage = 4
            itemWidth = 92
            marginX = 0
            
        case 724:
            // iPhone X
            columnsPerPage = 8
            rowsPerPage = 3
            itemWidth = 90
            itemHeight = 98
            marginX = 2
            marginY = 29
            
        default:
            break
        }
        
        // Button size
        let buttonWidth: CGFloat = 82
        let buttonHeight: CGFloat = 82
        let paddingHorz = (itemWidth - buttonWidth) / 2
        let paddingVert = (itemHeight - buttonHeight) / 2
        
        // Add buttons
        var row = 0
        var column = 0
        var x = marginX
        for (index, _) in searchResults.enumerated() {
            let button = UIButton(type: .system)
            button.backgroundColor = UIColor.white
            button.setTitle("\(index)", for: .normal)
            
            button.frame = CGRect(x: x + paddingHorz,
                                  y: marginY + CGFloat(row) * itemHeight + paddingVert,
                                  width: buttonWidth,
                                  height: buttonHeight)
            
            scrollView.addSubview(button)
            
            row += 1
            if row == rowsPerPage {
                row = 0; x += itemWidth; column += 1
                
                if column == columnsPerPage {
                    column = 0; x += marginX * 2
                }
            }
        }
        
        // Set scroll view content size
        let buttonsPerPage = columnsPerPage * rowsPerPage
        let numPages = 1 + (searchResults.count - 1) / buttonsPerPage
        // Установка рабочей области для scroll view. Может быть больше чем bounds. Это позволяет скроллить
        scrollView.contentSize = CGSize(width: CGFloat(numPages) * viewWidth,
                                        height: scrollView.bounds.size.height)
        
        print("Number of pages: \(numPages)")
        
        // Установка количества страниц и начальную страницу
        pageControl.numberOfPages = numPages
        pageControl.currentPage = 0
    }
    
    // MARK: - Actions
    @IBAction func pageChanged(_ sender: UIPageControl) {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: { self.scrollView.contentOffset = CGPoint(x: self.scrollView.bounds.size.width * CGFloat(sender.currentPage), y: 0) },
                       completion: nil)
    }
    
}

extension LandscapeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width
        let page = Int( (scrollView.contentOffset.x + width / 2) / width )
        pageControl.currentPage = page
    }
}
