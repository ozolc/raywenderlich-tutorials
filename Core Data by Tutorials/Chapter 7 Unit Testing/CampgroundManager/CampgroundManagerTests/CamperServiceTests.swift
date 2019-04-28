//
//  CamperServiceTests.swift
//  CampgroundManagerTests
//
//  Created by Maksim Nosov on 28/04/2019.
//  Copyright © 2019 Razeware. All rights reserved.
//

import XCTest
import CampgroundManager
import CoreData

class CamperServiceTests: XCTestCase {

  // MARK: - Properties
  var camperService: CamperService!
  var coreDataStack: CoreDataStack!
  
    override func setUp() {
        super.setUp()
      
      coreDataStack = TestCoreDataStack()
      camperService = CamperService(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack!)
    }

    override func tearDown() {
        super.tearDown()
      
      camperService = nil
      coreDataStack = nil
    }
  
  func testAddCamper() {
    let camper = camperService.addCamper("Bacon Lover", phoneNumber: "910-543-9000")
    XCTAssertNotNil(camperService, "Camper should not be nil")
    XCTAssertTrue(camper? .fullName == "Bacon Lover")
    XCTAssertTrue(camper?.phoneNumber == "910-543-9000")
  }
  
  func testRootContextIsSavedAfterAddingCamper() {
    let derivedContext = coreDataStack.newDerivedContext()
    camperService = CamperService(managedObjectContext: derivedContext, coreDataStack: coreDataStack)
    
    expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.mainContext) { notification in
      return true
    }
    
    derivedContext.perform {
      let camper = self.camperService.addCamper("Bacon Lover", phoneNumber: "910-543-9000")
      XCTAssertNotNil(camper)
    }
    
    waitForExpectations(timeout: 2.0) { error in
      XCTAssertNil(error, "Save did not occur")
    }
  }

}
