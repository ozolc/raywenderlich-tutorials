//
//  Helpers.swift
//  MyLocations
//
//  Created by Maksim Nosov on 06/05/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    print("created")
    return formatter
}()

import CoreLocation

func string(from placemark: CLPlacemark) -> String {
    var text = ""
    
    if let s = placemark.subThoroughfare {
        text += s + " "
    }
    if let s = placemark.thoroughfare {
        text += s + ", "
    }
    if let s = placemark.locality {
        text += s + ", "
    }
    if let s = placemark.administrativeArea {
        text += s + " "
    }
    if let s = placemark.postalCode {
        text += s + ", "
    }
    if let s = placemark.country {
        text += s
    }
    return text
}

func format(date: Date) -> String {
    return dateFormatter.string(from: date)
}
