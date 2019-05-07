//
//  LocationsViewController.swift
//  MyLocations
//
//  Created by Maksim Nosov on 07/05/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class LocationsViewController: UITableViewController {

    var managedObjectContext: NSManagedObjectContext! // контекст для работы с объектами Core Data
    var locations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest<Location>() // Описание для получения из Persistent store массива объектов Location в Core Data
        
        let entity = Location.entity() // Инициализация Entity ассоциированную с классом Location
        fetchRequest.entity = entity // Entity используемая fetch request
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true) // Описание сортировки по полю "date" по возрастанию
        fetchRequest.sortDescriptors = [sortDescriptor] // Массив сортировок для fetch request
        
        do {
            locations = try managedObjectContext.fetch(fetchRequest)
        } catch {
            fatalCoreDataError(error)
        }
    }
    
    // MARK: - Table View Delegates
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        
        let location = locations[indexPath.row] // индекс массива объектов <Locations> из Core Data
        cell.configure(for: location)
        
        
        return cell
    }

}

