//
//  Attachment.swift
//  UnCloudNotes
//
//  Created by Maksim Nosov on 27/04/2019.
//  Copyright © 2019 Ray Wenderlich. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Attachment: NSManagedObject {
  @NSManaged var dateCreated: Date
  @NSManaged var note: Note?
}
