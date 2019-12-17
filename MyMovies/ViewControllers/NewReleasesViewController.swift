//
//  NewReleasesViewController.swift
//  MyMovies
//
//  Created by Rob De Putter on 12/12/2019.
//  Copyright © 2019 Rob De Putter. All rights reserved.
//

import UIKit

class NewReleasesViewController: UITableViewController {
    
    var newReleases : [NewRelease] = []
    var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 114
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        //activityIndicator: https://dzone.com/articles/displaying-an-activity-indicator-while-loading-tab
        activityIndicatorView.startAnimating()
        NetworkController.shared.fetchNewReleases(){
            results in
            guard let newReleases = results else {return}
            
            self.newReleases = newReleases
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicatorView.stopAnimating()
                if newReleases.count == 0 {
                    self.tableView.setEmptyView(message: "Check your internet connection")
                }
                else{
                    self.tableView.restore()
                }
            }
        }
    }
    override func loadView() {
        super.loadView()
        activityIndicatorView = UIActivityIndicatorView(style: .large)
        tableView.backgroundView = activityIndicatorView
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newReleases.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewRelease", for: indexPath) as! MovieSerieCell
        let newRelease = newReleases[indexPath.row]
        
        if newRelease.image != "N/A"{
            NetworkController.shared.fetchImage(with: URL(string: newRelease.image!)!){
                image in
                guard let image = image else {return}
                
                DispatchQueue.main.async {
                    cell.updateNewRelease(newRelease: newRelease, image: image)
                }
            }
        }else{
            DispatchQueue.main.async {
                cell.updateNewRelease(newRelease: newRelease, image: #imageLiteral(resourceName: "NoPhotoAvailable"))
            }
        }
        return cell
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "NewReleaseSegue"{
            let movieSerieDetailViewController = segue.destination as! MovieSerieDetailViewController
            let index = tableView.indexPathForSelectedRow!.row
            movieSerieDetailViewController.newRelease = newReleases[index]
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
