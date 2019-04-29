//
//  EmployeePicture.swift
//  EmployeeDirectory
//
//  Created by Maksim Nosov on 29/04/2019.
//  Copyright © 2019 Razeware. All rights reserved.
//

import Foundation
import CoreData

public class EmployeePicture: NSManagedObject {

}

extension EmployeePicture {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<EmployeePicture> {
    return NSFetchRequest<EmployeePicture>(entityName: "EmployeePicture")
  }
  
  @NSManaged public var picture: Data?
  @NSManaged public var employee: Employee?
}
