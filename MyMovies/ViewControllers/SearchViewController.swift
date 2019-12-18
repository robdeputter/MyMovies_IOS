//
//  SearchViewController.swift
//  MyMovies
//
//  Created by Rob De Putter on 12/12/2019.
//  Copyright © 2019 Rob De Putter. All rights reserved.
//

import UIKit
import Reachability

//SOURCE: https://www.raywenderlich.com/4363809-uisearchcontroller-tutorial-getting-started
//reachability: https://www.youtube.com/watch?v=wDZmz9IsB-8
/**
 This View will show an overview series and movies for a specific title (possible filters = year, type)
 */
class SearchViewController: UITableViewController, UISearchResultsUpdating {
    
    var movieSeries : [MovieSerie] = []
    let reachability = try! Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchbarInNavbar()
        self.tableView.rowHeight = 114
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func setSearchbarInNavbar(){
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        
        self.definesPresentationContext = true
        
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    //DELEGATE PATTERN
    func updateSearchResults(for searchController: UISearchController) {
        if let inputText = searchController.searchBar.text{
            
            guard !inputText.isEmpty else{
                self.movieSeries.removeAll()
                self.tableView.reloadData()
                return
            }
            
            NetworkController.shared.fetchSearchMovieSeries(with: inputText, with: "", with: ""){
                (results) in
                guard let movieSeries = results else {
                    return
                }
                
                self.movieSeries = movieSeries
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Search" {
            let movieSerieDetailViewController = segue.destination as! MovieSerieDetailViewController
            let index = tableView.indexPathForSelectedRow!.row
            movieSerieDetailViewController.movieSerie = movieSeries[index]
        }
        
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        //if there are no movies or series to show ==> "No movies or series"
        //SOURCE: https://medium.com/@mtssonmez/handle-empty-tableview-in-swift-4-ios-11-23635d108409
        self.tableView.setEmptyView(message: "No results")
        reachability.whenReachable = {
            reachability in
            if self.movieSeries.count == 0{
                DispatchQueue.main.async {
                    self.tableView.setEmptyView(message: "No results")
                }
            }
            else{
                self.tableView.restore()
            }
        }
        reachability.whenUnreachable = {
            _ in
            DispatchQueue.main.async {
                self.tableView.setEmptyView(message: "No internet connection")
            }
            
        }
        return movieSeries.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchMovieSerieCell", for: indexPath) as! MovieSerieCell
        let movieSerie = movieSeries[indexPath.row]
        
        if(movieSerie.poster != "N/A"){
            NetworkController.shared.fetchImage(with: URL(string: movieSerie.poster)!){
                image in
                guard let image = image else {return}
                
                DispatchQueue.main.async {
                    cell.update(movieSerie: movieSerie, image: image)
                }
            }
        }else{
            DispatchQueue.main.async {
                cell.update(movieSerie: movieSerie, image: #imageLiteral(resourceName: "NoPhotoAvailable"))
            }
        }
        return cell
    }
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    
}

