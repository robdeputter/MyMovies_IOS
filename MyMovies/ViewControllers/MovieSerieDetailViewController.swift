//
//  MovieSerieDetailViewController.swift
//  MyMovies
//
//  Created by Rob De Putter on 12/12/2019.
//  Copyright © 2019 Rob De Putter. All rights reserved.
//

import UIKit
import RealmSwift

class MovieSerieDetailViewController: UIViewController {
    var movieSerieDetail : MovieSerieDetail!
    var movieSerie : MovieSerie!
    
    //image
    @IBOutlet var poster: UIImageView!
    
    //buttons
    @IBOutlet var watchlistButton: UIButton!
    @IBOutlet var favoritesButton: UIButton!
    
    //labels
    @IBOutlet var titleDetails: UILabel!
    @IBOutlet var plotDetails: UILabel!
    @IBOutlet var actorsDetails: UILabel!
    @IBOutlet var imdbRatingDetails: UILabel!
    @IBOutlet var releasedDetails: UILabel!
    @IBOutlet var genreDetails: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NetworkController.shared.fetchMovieSerieDetail(with: movieSerie.imdbID){
            result in
            guard let movieSerieDetail = result else {return}
            
            var url = URL(string: movieSerieDetail.posterString)
            NetworkController.shared.fetchImage(with: movieSerieDetail.poster!){
            image in
                guard let image = image else {return}
                
                
                DispatchQueue.main.async {
                    self.updateUI(movieSerieDetail: movieSerieDetail , image: image)
                }
            }
        
            
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        
        
        // Do any additional setup after loading the view.
    }
    
    private func updateUI(movieSerieDetail : MovieSerieDetail, image : UIImage){
        titleDetails.text = movieSerieDetail.title
        plotDetails.text = movieSerieDetail.plot
        actorsDetails.text = movieSerieDetail.actors
        imdbRatingDetails.text = "\(movieSerieDetail.imdbRating)/10 (based on \(movieSerieDetail.imdbVotes) votes)"
        releasedDetails.text = "Released: \(movieSerieDetail.released)"
        genreDetails.text = "Genre: \(movieSerieDetail.genre)"
        poster.image = image
        
        
    }
    
    @IBAction func watchlistButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func favoritesButtonPressed(_ sender: UIButton) {
        favoritesButton.setImage(#imageLiteral(resourceName: "baseline_star_white_18dp"), for: .normal)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
