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
        
        if movieSerieDetail == nil{
            
            NetworkController.shared.fetchMovieSerieDetail(with: movieSerie.imdbID){
                result in
                guard let movieSerieDetail = result else {return}
                
                
                self.movieSerieDetail = movieSerieDetail
                NetworkController.shared.fetchImage(with: movieSerieDetail.poster!){
                image in
                    guard let image = image else {return}
                    
                    
                    DispatchQueue.main.async {
                        self.updateUI(movieSerieDetail: movieSerieDetail , image: image)
                        self.setUpButtons()
                    }
                }
                
                
            
                
            }
        }else{
            DispatchQueue.main.async {
                NetworkController.shared.fetchImage(with: URL(string: self.movieSerieDetail.posterString)!){
                image in
                    guard let image = image else {return}
                    
                    
                    DispatchQueue.main.async {
                        self.updateUI(movieSerieDetail: self.movieSerieDetail , image: image)
                        self.setUpButtons()
                    }
                }
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(self.movieSerieDetail != nil){
            self.setUpButtons()
        }
    }
    
    func setUpButtons(){
        DatabaseController.shared.inFavorites(movieSerieDetail: self.movieSerieDetail){
            result in
            DispatchQueue.main.async {
                if(result){
                    self.favoritesButton.setImage(#imageLiteral(resourceName: "baseline_star_white_18dp"), for: .normal)
                }
                else{
                    self.favoritesButton.setImage(#imageLiteral(resourceName: "baseline_star_border_white_18dp"), for: .normal)
                }
            }
            
        }
        
        DatabaseController.shared.inWatchlist(movieSerieDetail: self.movieSerieDetail){
            result in
            DispatchQueue.main.async {
                if(result){
                    self.watchlistButton.setImage(#imageLiteral(resourceName: "baseline_playlist_add_check_white_18dp"), for: .normal)
                }
                else{
                    self.watchlistButton.setImage(#imageLiteral(resourceName: "baseline_playlist_add_white_18dp"), for: .normal)
                }
            }
            
        }
            
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
        DatabaseController.shared.inWatchlist(movieSerieDetail: self.movieSerieDetail){
            result in
            if(result){
                
                DatabaseController.shared.removeWatchListEntity(movieSerieDetail: self.movieSerieDetail){
                    result in
                    if(result != nil){
                        //show error
                    }
                    else{
                        DispatchQueue.main.async {
                            self.watchlistButton.setImage(#imageLiteral(resourceName: "baseline_playlist_add_white_18dp"), for: .normal)
                        }
                        
                    }

                }
            }else{
                DatabaseController.shared.addWatchListEntity(movieSerieDetail: self.movieSerieDetail){
                    response in
                    if(response != nil){
                        //show error
                    }
                    else{
                        DispatchQueue.main.async {
                            self.watchlistButton.setImage(#imageLiteral(resourceName: "baseline_playlist_add_check_white_18dp"), for: .normal)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func favoritesButtonPressed(_ sender: UIButton) {
        DatabaseController.shared.inFavorites(movieSerieDetail: self.movieSerieDetail){
            result in
            if(result){
                DatabaseController.shared.removeFavorite(movieSerieDetail: self.movieSerieDetail){
                    result in
                    if(result != nil){
                        //show error
                    }
                    else{
                        DispatchQueue.main.async {
                            self.favoritesButton.setImage(#imageLiteral(resourceName: "baseline_star_border_white_18dp"), for: .normal)
                        }
                        
                    }

                }
            }else{
                DatabaseController.shared.addFavorite(movieSerieDetail: self.movieSerieDetail,rating: 3){
                    response in
                    if(response != nil){
                        //show error
                    }
                    else{
                        DispatchQueue.main.async {
                            self.favoritesButton.setImage(#imageLiteral(resourceName: "baseline_star_white_18dp"), for: .normal)
                        }
                    }
                }
            }
        }
    }
}
