//
//  UIImageView+DownloadImage.swift
//  StoreSearch
//
//  Created by Maksim Nosov on 11/05/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImage(url: URL) -> URLSessionDownloadTask {
        let session = URLSession.shared
        
        // download task создает загруженный файл во временное расположение на диске
        // Внутри completionHandler получаем url - указатель на загруженный файл
        let downloadTask = session.downloadTask(with: url) { [weak self] url, response, error in
            if error == nil, let url = url,
            // Загружает в Data объект
                let data = try? Data(contentsOf: url),
                // Создать Image из Data объекта
                let image = UIImage(data: data) {
                
                DispatchQueue.main.async {
                    if let weakSelf = self {
                        weakSelf.image = image
                    }
                }
                
            }
        }
        downloadTask.resume()
        return downloadTask
    }
}
