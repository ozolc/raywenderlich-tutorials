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
    return formatter
}()

import CoreLocation

func string(from placemark: CLPlacemark) -> String {
    
    var line1 = ""
    line1.add(text: placemark.subThoroughfare)
    line1.add(text: placemark.thoroughfare, separatedBy: " ")

    var line2 = ""
    line2.add(text: placemark.locality)
    line2.add(text: placemark.administrativeArea, separatedBy: " ")
    line2.add(text: placemark.postalCode, separatedBy: " ")
    
    line1.add(text: line2, separatedBy: "\n")
    return line1
}

func format(date: Date) -> String {
    return dateFormatter.string(from: date)
}
