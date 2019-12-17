//
//  WatchlistViewController.swift
//  MyMovies
//
//  Created by Rob De Putter on 17/12/2019.
//  Copyright © 2019 Rob De Putter. All rights reserved.
//

import UIKit
import RealmSwift

class WatchlistViewController: UITableViewController {

    var watchlistEntities : Results<MovieSerieDetail>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 114
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        watchlistEntities = DatabaseController.shared.watchlistEntities
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if watchlistEntities.count == 0{
            self.tableView.setEmptyView(message: "Watchlist is empty")
        }
        else{
            self.tableView.restore()
        }
        return watchlistEntities.count
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WatchlistSegue"{
            let movieSerieDetailViewController = segue.destination as! MovieSerieDetailViewController
            let index = tableView.indexPathForSelectedRow!.row
            movieSerieDetailViewController.movieSerieDetail = watchlistEntities[index]
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WatchlistCell", for: indexPath) as! MovieSerieDetailCell

        let watchlistEntity = watchlistEntities[indexPath.row]
        
        if(watchlistEntity.posterString == "N/A"){
            DispatchQueue.main.async {
                cell.update(movieSerieDetail: watchlistEntity, image: #imageLiteral(resourceName: "NoPhotoAvailable"))
            }
        }
        else{
            NetworkController.shared.fetchImage(with: URL(string: watchlistEntity.posterString)!){
                result in
                guard let image = result else {return}
                
                DispatchQueue.main.async {
                    cell.update(movieSerieDetail: watchlistEntity, image: image)
                }
                
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
           return .delete
       }
       
       override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               // Delete the row from the data source
               let watchlistEntity = watchlistEntities[indexPath.row]
               
            DatabaseController.shared.removeWatchListEntity(movieSerieDetail: watchlistEntity){
                   result in
                   
                   if result == nil{
                       tableView.deleteRows(at: [indexPath], with: .fade)
                   }
               }
           }
       }

    

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
