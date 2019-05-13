//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Maksim Nosov on 11/05/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    
    var downloadTask: URLSessionDownloadTask?
    
    var isPopUp = false // Поведение окна. на iPhone - pop-up, на iPad - нет.
    
    // force unwrapping потому что не известно значение до выполнения segue. Он nil в самом начале
    // Передается из SearchViewController через performSegue
    var searchResult: SearchResult! {
        // Значение получает, только если запущен на iPad.
        didSet {
            if isViewLoaded {
                updateUI()
            }
        }
    }
    
    enum AnimationStyle {
        case slide
        case fade
    }
    
    var dismissStyle = AnimationStyle.fade
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        
        view.tintColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 1)
        popupView.layer.cornerRadius = 10
        
        if isPopUp {
            // если iPhone
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
            gestureRecognizer.cancelsTouchesInView = false // gestureRecognizer слушает ВЕЗДЕ в view controller
            gestureRecognizer.delegate = self
            view.addGestureRecognizer(gestureRecognizer)
            
            view.backgroundColor = UIColor.clear
        } else {
            // если iPad
            view.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
            popupView.isHidden = true
            
            // Установить заголовок
            if let displayName = Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"] as? String {
                title = displayName
            }
        }
        
        if searchResult != nil {
            updateUI()
        }
    }
    
    deinit {
        print("deinit \(self)")
        // Отменить загрузку изображение с товаром, если pop-up view закроется
        downloadTask?.cancel()
    }
    
    // MARK: - Actions
    @IBAction func close() {
        dismissStyle = .slide // Установить анимацию slide
        dismiss(animated: true, completion: nil)
    }
    
    // Открыть страницу продукта в iTunes Store
    @IBAction func openInStore() {
        if let url = URL(string: searchResult.storeURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // Вызывается для загрузки view controller из storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    // MARK: - Helper Methods
    func updateUI() {
        nameLabel.text = searchResult.name
        
        if searchResult.artist.isEmpty {
            artistNameLabel.text = "Unknown"
        } else {
            artistNameLabel.text = searchResult.artist
        }
        
        kindLabel.text = searchResult.kind
        genreLabel.text = searchResult.genre
        
        // Отобразить цену товара
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = searchResult.currency
        
        let priceText: String
        if searchResult.price == 0 {
            priceText = "Free"
        } else if let text = formatter.string(from: searchResult.price as NSNumber) {
            priceText = text
        } else {
            priceText = ""
        }
        
        priceButton.setTitle(priceText, for: .normal)
        
        // Загрузка изображения товара
        if let largeURL = URL(string: searchResult.imageLarge) {
            downloadTask = artworkImageView.loadImage(url: largeURL)
        }
        popupView.isHidden = false
    }
    
}

extension DetailViewController: UIViewControllerTransitioningDelegate {
    
    // Использовать DimmingPresentationController вместо стандантного Presentation Controller для выполнения transition
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    // Сообщаем app использовать новый контроллер для анимации когда презентуем Detail pop-up
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BounceAnimationController()
    }
    
    // Сообщаем app использовать новый контроллер для анимации когда убираем Detail pop-up
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch dismissStyle {
        case .slide:
            return SlideOutAnimationController()
        case .fade:
            return FadeOutAnimationController()
        }
    }
}

extension DetailViewController: UIGestureRecognizerDelegate {
    // Когда нажали вне pop-up view
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // self.view - view родитель pop-up view
        return (touch.view === self.view)
    }
}
