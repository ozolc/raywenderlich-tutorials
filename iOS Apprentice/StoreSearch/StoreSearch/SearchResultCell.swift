//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Maksim Nosov on 10/05/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    
    var downloadTask: URLSessionDownloadTask? // URL сессия, сохраняет загруженный файл

    // awakeFromNib() вызывается после загрузки объекта ячейки в память, но перед тем как ячейка будет добавлена на tableView
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
        selectedBackgroundView = selectedView
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Отменить загрузку в download task изображения если ячейка готовится к переиспользованию. Не загружает изображения, которые уже не нужны на экране
        downloadTask?.cancel()
        downloadTask = nil
    }

    // MARK: - Public Methods
    func configure(for result: SearchResult) {
        nameLabel.text = result.name
        
        if result.artist.isEmpty {
            artistNameLabel.text = "Unknown"
        } else {
            artistNameLabel.text = String(format: "%@ (%@(", result.artist, result.type)
        }
        
        artworkImageView.image = UIImage(named: "Placeholder")
        if let smallURL = URL(string: result.imageSmall) {
            downloadTask = artworkImageView.loadImage(url: smallURL)
        }
    }

}
