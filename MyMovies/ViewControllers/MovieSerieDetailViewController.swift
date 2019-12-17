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
    
    var rating : Int?
    
    //SOURCE pop-up: https://www.youtube.com/watch?v=CXvOS6hYADc
    //Pop-up view
    @IBOutlet var ratingView: UIView!
    
    //ratingstars
    @IBOutlet var ratingStar1: UIButton!
    @IBOutlet var ratingStar2: UIButton!
    @IBOutlet var ratingStar3: UIButton!
    @IBOutlet var ratingStar4: UIButton!
    @IBOutlet var ratingStar5: UIButton!
    
    //rating pop-up buttons
    @IBOutlet var cancelRating: UIButton!
    @IBOutlet var saveRating: UIButton!
    
    //image
    @IBOutlet var poster: UIImageView!
    
    //viewEffect for rating
    @IBOutlet var blurView: UIVisualEffectView!
    var effect : UIVisualEffect!
    
    
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
        effect = blurView.effect
        blurView.isHidden = true
        blurView.effect = nil
        
        ratingView.layer.cornerRadius = 5

        if movieSerieDetail == nil{
            watchlistButton.isEnabled = false
            favoritesButton.isEnabled = false
            NetworkController.shared.fetchMovieSerieDetail(with: movieSerie.imdbID){
                result in
                guard let movieSerieDetail = result else {return}
                
                
                self.movieSerieDetail = movieSerieDetail
                if(movieSerieDetail.posterString != "N/A"){
                    NetworkController.shared.fetchImage(with: URL(string: movieSerieDetail.posterString)!){
                        image in
                        guard let image = image else {return}
                        
                        
                        DispatchQueue.main.async {
                            self.updateUI(movieSerieDetail: movieSerieDetail , image: image)
                            self.setUpButtons()
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self.updateUI(movieSerieDetail: movieSerieDetail , image: #imageLiteral(resourceName: "NoPhotoAvailable"))
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
                self.favoritesButton.isEnabled = true
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
                self.watchlistButton.isEnabled = true
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
                self.animateIn()
            }
        }
    }
    
    //visual effects for pop-up view
    func animateIn(){
        self.view.addSubview(ratingView)
        blurView.isHidden = false
        ratingView.center = self.view.center
        
        ratingView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        ratingView.alpha = 0
        
        UIView.animate(withDuration: 0.4){
            self.blurView.effect = self.effect
            self.ratingView.alpha = 1
            self.ratingView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.ratingView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.ratingView.alpha = 0
            
            self.blurView.effect = nil
            self.blurView.isHidden = true
        }){
            success in
            self.ratingView.removeFromSuperview()
        }
        
        ratingStar1.setImage(UIImage(systemName: "star"), for: .normal)
        ratingStar2.setImage(UIImage(systemName: "star"), for: .normal)
        ratingStar3.setImage(UIImage(systemName: "star"), for: .normal)
        ratingStar4.setImage(UIImage(systemName: "star"), for: .normal)
        ratingStar5.setImage(UIImage(systemName: "star"), for: .normal)
    }
    
    @IBAction func cancelRating(_ sender: Any) {
        animateOut()
    }
    
    @IBAction func saveRating(_ sender: Any) {
        if(rating != nil){
            DatabaseController.shared.addFavorite(movieSerieDetail: self.movieSerieDetail,rating: rating!){
                response in
                if(response != nil){
                    //show error
                }
                else{
                    DispatchQueue.main.async {
                        self.favoritesButton.setImage(#imageLiteral(resourceName: "baseline_star_white_18dp"), for: .normal)
                    }
                    self.animateOut()
                    self.rating = nil
                }
            }
        }
        
    }
    
    
    @IBAction func ratingButtonPressed(_ sender: UIButton) {
        
        if sender.isEqual(ratingStar1){
            rating = 1
            ratingStar1.setImage(UIImage(systemName: "star.fill"), for: .normal)
            ratingStar2.setImage(UIImage(systemName: "star"), for: .normal)
            ratingStar3.setImage(UIImage(systemName: "star"), for: .normal)
            ratingStar4.setImage(UIImage(systemName: "star"), for: .normal)
            ratingStar5.setImage(UIImage(systemName: "star"), for: .normal)
        }
        else if sender.isEqual(ratingStar2){
            rating = 2
            ratingStar1.setImage(UIImage(systemName: "star.fill"), for: .normal)
            ratingStar2.setImage(UIImage(systemName: "star.fill"), for: .normal)
            ratingStar3.setImage(UIImage(systemName: "star"), for: .normal)
            ratingStar4.setImage(UIImage(systemName: "star"), for: .normal)
            ratingStar5.setImage(UIImage(systemName: "star"), for: .normal)
        }
        else if sender.isEqual(ratingStar3){
            rating = 3
            ratingStar1.setImage(UIImage(systemName: "star.fill"), for: .normal)
            ratingStar2.setImage(UIImage(systemName: "star.fill"), for: .normal)
            ratingStar3.setImage(UIImage(systemName: "star.fill"), for: .normal)
            ratingStar4.setImage(UIImage(systemName: "star"), for: .normal)
            ratingStar5.setImage(UIImage(systemName: "star"), for: .normal)
        }
        else if sender.isEqual(ratingStar4){
            rating = 4
            ratingStar1.setImage(UIImage(systemName: "star.fill"), for: .normal)
            ratingStar2.setImage(UIImage(systemName: "star.fill"), for: .normal)
            ratingStar3.setImage(UIImage(systemName: "star.fill"), for: .normal)
            ratingStar4.setImage(UIImage(systemName: "star.fill"), for: .normal)
            ratingStar5.setImage(UIImage(systemName: "star"), for: .normal)
        }
            
        else if sender.isEqual(ratingStar5){
            rating = 5
            ratingStar1.setImage(UIImage(systemName: "star.fill"), for: .normal)
            ratingStar2.setImage(UIImage(systemName: "star.fill"), for: .normal)
            ratingStar3.setImage(UIImage(systemName: "star.fill"), for: .normal)
            ratingStar4.setImage(UIImage(systemName: "star.fill"), for: .normal)
            ratingStar5.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        
    }
    
    
    
}
