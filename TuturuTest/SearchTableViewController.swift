//
//  SearchTableViewController.swift
//  TuturuTest
//
//  Created by Артем on 07/10/2016.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import UIKit
import CoreData

class SearchTableViewController: CoreDataTableViewController , UISearchResultsUpdating, UISearchBarDelegate {
    
    // MARK: Model
    var filter: String?  { didSet { updateUI() } }
    var moc: NSManagedObjectContext? { didSet { updateUI() } }
    var resultsController: NSFetchedResultsController<CDStation>!
    
    
    var handlerStation: ((Station) -> Void)?
    
    private func updateUI() {
        if let context = moc {
            let request = NSFetchRequest<CDStation>(entityName: "CDStation")
            if (filter?.characters.count ?? 0) > 0 {
            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@",
                                            filter!)
            } else {
                request.predicate = NSPredicate(format: "TRUEPREDICATE")
            }
            
            request.sortDescriptors = [NSSortDescriptor(
                key: "country",
                ascending: true,
                selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                ), NSSortDescriptor(
                    key: "city.name",
                    ascending: true,
                    selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                ),NSSortDescriptor(
                    key: "name",
                    ascending: true,
                    selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )]
            resultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: "country",
                cacheName: nil
            )
            fetchedResultsController =  resultsController as? NSFetchedResultsController<NSFetchRequestResult>? ?? nil
        } else {
            fetchedResultsController = nil
        }
    }
    
    var resultSearchController = UISearchController(searchResultsController: nil)
    
    // MARK: Search Result Updating
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        filter = searchBarText
        updateUI()
    }
    
    func searchBar(searchBar: UISearchBar) {
        filter = searchBar.text
        updateUI()
    }
    
    // MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // config result search controller

        resultSearchController.searchResultsUpdater = self
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        // config search bar
        let searchBar = resultSearchController.searchBar
        searchBar.text = filter
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController.searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if moc == nil {
            UIManagedDocument.useDocument{ (document) in
                self.moc =  document.managedObjectContext
            }
        }
    }

    // MARK: - Table view data source
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath)
        
        var stationName: String?
        var country: String?
        
        if let station = fetchedResultsController?.object(at: indexPath) as? CDStation {
            station.managedObjectContext?.performAndWait {
                stationName = station.name
                country = "\(station.country ?? "") \(station.city?.name ?? "")"
            }
            cell.textLabel?.text = stationName
            cell.detailTextLabel?.text = country
        }
        return cell
    }
 
    // MARK: Table view delegate
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Переезд к информации о станции
        if segue.identifier == "ToStationInfo" {
            if let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell),
                let destinationVC = segue.destination as? StationInfoTableView,
                let station = fetchedResultsController?.object(at: indexPath) as? CDStation {
                    destinationVC.station = Station(cdStation: station)              
            }
        }
        // Переезд к расписанию, если станция выбрана
        if segue.identifier == "UnwindToViewController" {
            if let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell),
                let station = fetchedResultsController?.object(at: indexPath) as? CDStation {
                handlerStation?(Station(cdStation: station)!)
            }
        }
    }


}
