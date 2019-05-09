//
//  LocationCell.swift
//  MyLocations
//
//  Created by Maksim Nosov on 07/05/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK:- Helper Method
    func configure(for location: Location) {
        
        if location.locationDescription.isEmpty {
            descriptionLabel.text = "(No Description)"
        } else {
            descriptionLabel.text = location.locationDescription
        }
        
        if let placemark = location.placemark {
            addressLabel.text = string(from: placemark)
        } else {
            addressLabel.text = String(format: "Lat: %.8f, long: %.8f", location.latitude, location.longitude)
        }
        photoImageView.image = thumbnail(for: location)
    }
    
    func thumbnail(for location: Location) -> UIImage {
        if location.hasPhoto, let image = location.photoImage {
            return image.resized(withBounds: CGSize(width: 52, height: 52))
        }
        return UIImage()
    }

}
