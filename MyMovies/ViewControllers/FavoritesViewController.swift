//
//  FavoritesViewController.swift
//  MyMovies
//
//  Created by Rob De Putter on 12/12/2019.
//  Copyright © 2019 Rob De Putter. All rights reserved.
//

import UIKit
import RealmSwift

class FavoritesViewController: UITableViewController {
    
    var favorites : Results<MovieSerieDetail>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.rowHeight = 114
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favorites = DatabaseController.shared.favorites
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FavoriteSegue"{
            let movieSerieDetailViewController = segue.destination as! MovieSerieDetailViewController
            let index = tableView.indexPathForSelectedRow!.row
            movieSerieDetailViewController.movieSerieDetail = favorites[index]
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if favorites.count == 0{
            self.tableView.setEmptyView(message: "No favorites")
        }
        else{
            self.tableView.restore()
        }
        
        return favorites.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as! MovieSerieDetailCell
        let favorite = favorites[indexPath.row]
        
        
        NetworkController.shared.fetchImage(with: URL(string: favorite.posterString)!){
            result in
            guard let image = result else {return}
            
            DispatchQueue.main.async {
                cell.update(movieSerieDetail: favorite, image: image)
            }
        }
        
        return cell
    }
    
    // Override to support editing the table view.
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let favorite = favorites[indexPath.row]
            
            DatabaseController.shared.removeFavorite(movieSerieDetail: favorite){
                result in
                
                if result == nil{
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
            
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
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
    
    
}
