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
    var newRelease : NewRelease!
    
    var rating : Int?
    //share
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    //SOURCE pop-up: https://www.youtube.com/watch?v=CXvOS6hYADc
    //Pop-up view
    @IBOutlet var ratingView: UIView!
    
    //ratingstars pop up
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
    
    //Ratingstars details
    @IBOutlet weak var ratingDetailView: UIStackView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        effect = blurView.effect
        blurView.isHidden = true
        blurView.effect = nil
        
        ratingView.layer.cornerRadius = 5
        watchlistButton.isEnabled = false
        favoritesButton.isEnabled = false
        self.showSpinner(onView: self.view)
        if movieSerieDetail == nil{
            guard let newRelease = self.newRelease else {
                fetchMovieSerie()
                return
            }
            fetchNewRelease(newRelease: newRelease)
        }else{
            fetchMovieSerieDetail()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if(self.movieSerieDetail != nil){
            self.setUpButtons(imdbID: self.movieSerieDetail.imdbID)
            DatabaseController.shared.getFavoritesRatingMovie(imdbId: self.movieSerieDetail.imdbID){
                result in
                self.updateRatingBar(rating: result)
            }
        }
        else if self.movieSerie != nil{
            self.setUpButtons(imdbID: self.movieSerie.imdbID)
            DatabaseController.shared.getFavoritesRatingMovie(imdbId: movieSerie.imdbID){
                result in
                self.updateRatingBar(rating: result)
            }
        }
        else if self.newRelease != nil{
            self.setUpButtons(imdbID: self.newRelease.imdbID)
            DatabaseController.shared.getFavoritesRatingMovie(imdbId: newRelease.imdbID){
                result in
                self.updateRatingBar(rating: result)
            }
        }
    }
    
    func setUpButtons(imdbID : String){
        DatabaseController.shared.inFavorites(imdbID: imdbID){
            result in
            DispatchQueue.main.async {
                if(result){
                    self.favoritesButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                }
                else{
                    self.favoritesButton.setImage(UIImage(systemName: "star"), for: .normal)
                }
                self.favoritesButton.isEnabled = true
            }
            
        }
        
        DatabaseController.shared.inWatchlist(imdbID: imdbID){
            result in
            DispatchQueue.main.async {
                if(result){
                    self.watchlistButton.setImage(UIImage(systemName: "text.badge.checkmark"), for: .normal)
                }
                else{
                    self.watchlistButton.setImage(UIImage(systemName: "text.badge.plus"), for: .normal)
                }
                self.watchlistButton.isEnabled = true
            }
        }
    }
    
    //Will always run on the mainthread to update the view
    //Warnings are
    func updateRatingBar(rating : Int?){
        switch rating {
        case 1:
            ratingDetailView.isHidden = false
            star1.image = UIImage(systemName: "star.fill")
            star2.image = UIImage(systemName: "star")
            star3.image = UIImage(systemName: "star")
            star4.image = UIImage(systemName: "star")
            star5.image = UIImage(systemName: "star")
        case 2:
            ratingDetailView.isHidden = false
            star1.image = UIImage(systemName: "star.fill")
            star2.image = UIImage(systemName: "star.fill")
            star3.image = UIImage(systemName: "star")
            star4.image = UIImage(systemName: "star")
            star5.image = UIImage(systemName: "star")
        case 3:
            ratingDetailView.isHidden = false
            star1.image = UIImage(systemName: "star.fill")
            star2.image = UIImage(systemName: "star.fill")
            star3.image = UIImage(systemName: "star.fill")
            star4.image = UIImage(systemName: "star")
            star5.image = UIImage(systemName: "star")
        case 4:
            ratingDetailView.isHidden = false
            star1.image = UIImage(systemName: "star.fill")
            star2.image = UIImage(systemName: "star.fill")
            star3.image = UIImage(systemName: "star.fill")
            star4.image = UIImage(systemName: "star.fill")
            star5.image = UIImage(systemName: "star")
        case 5:
            ratingDetailView.isHidden = false
            star1.image = UIImage(systemName: "star.fill")
            star2.image = UIImage(systemName: "star.fill")
            star3.image = UIImage(systemName: "star.fill")
            star4.image = UIImage(systemName: "star.fill")
            star5.image = UIImage(systemName: "star.fill")
        default:
            star1.image = UIImage(systemName: "star")
            star2.image = UIImage(systemName: "star")
            star3.image = UIImage(systemName: "star")
            star4.image = UIImage(systemName: "star")
            star5.image = UIImage(systemName: "star")
            ratingDetailView.isHidden = true
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
        DatabaseController.shared.inWatchlist(imdbID: self.movieSerieDetail.imdbID){
            result in
            if(result){
                
                DatabaseController.shared.removeWatchListEntity(movieSerieDetail: self.movieSerieDetail){
                    result in
                    if(result != nil){
                        //show error
                    }
                    else{
                        DispatchQueue.main.async {
                            self.watchlistButton.setImage(UIImage(systemName: "text.badge.plus"), for: .normal)
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
                            self.watchlistButton.setImage(UIImage(systemName: "text.badge.checkmark"), for: .normal)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func favoritesButtonPressed(_ sender: UIButton) {
        DatabaseController.shared.inFavorites(imdbID: self.movieSerieDetail.imdbID){
            result in
            if(result){
                DatabaseController.shared.removeFavorite(movieSerieDetail: self.movieSerieDetail){
                    result in
                    if(result != nil){
                        //show error
                    }
                    else{
                        DispatchQueue.main.async {
                            self.favoritesButton.setImage(UIImage(systemName: "star"), for: .normal)
                            self.ratingDetailView.isHidden = true
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
                        self.favoritesButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                        self.ratingDetailView.isHidden = false
                    self.updateRatingBar(rating: self.rating)
                        
                    
                    self.animateOut()
                    //reset the rating --> if the user removes the favorite and adds him back, the ratingbar has to be filled with empty stars
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
    
    func fetchNewRelease(newRelease : NewRelease){
        NetworkController.shared.fetchMovieSerieDetail(with: newRelease.imdbID){
            result in
            guard let movieSerieDetail = result else {return}
            
            self.movieSerieDetail = movieSerieDetail
            if(movieSerieDetail.posterString != "N/A"){
                NetworkController.shared.fetchImage(with: URL(string: movieSerieDetail.posterString)!){
                    image in
                    guard let image = image else {return}
                    
                    DatabaseController.shared.getFavoritesRatingMovie(imdbId: movieSerieDetail.imdbID) { (rating) in
                            self.updateRatingBar(rating: rating)
                    }
                    DispatchQueue.main.async {
                        self.updateUI(movieSerieDetail: movieSerieDetail , image: image)
                        self.setUpButtons(imdbID: movieSerieDetail.imdbID)
                        self.removeSpinner()
                    }
                }
            }else{
                DatabaseController.shared.getFavoritesRatingMovie(imdbId: movieSerieDetail.imdbID) { (rating) in
                        self.updateRatingBar(rating: rating)
                }
                DispatchQueue.main.async {
                    self.updateUI(movieSerieDetail: movieSerieDetail , image: #imageLiteral(resourceName: "NoPhotoAvailable"))
                    self.setUpButtons(imdbID: movieSerieDetail.imdbID)
                    self.removeSpinner()
                }
            }
        }
    }
    
    func fetchMovieSerie(){
        NetworkController.shared.fetchMovieSerieDetail(with: movieSerie.imdbID){
            result in
            guard let movieSerieDetail = result else {return}
            self.movieSerieDetail = movieSerieDetail
            if(movieSerieDetail.posterString != "N/A"){
                NetworkController.shared.fetchImage(with: URL(string: movieSerieDetail.posterString)!){
                    image in
                    guard let image = image else {return}
                    
                    DatabaseController.shared.getFavoritesRatingMovie(imdbId: movieSerieDetail.imdbID) { (rating) in
                            self.updateRatingBar(rating: rating)
                    }
                    DispatchQueue.main.async {
                        self.updateUI(movieSerieDetail: movieSerieDetail , image: image)
                        self.setUpButtons(imdbID: movieSerieDetail.imdbID)
                        self.removeSpinner()
                    }
                }
            }else{
                DatabaseController.shared.getFavoritesRatingMovie(imdbId: movieSerieDetail.imdbID) { (rating) in
                        self.updateRatingBar(rating: rating)
                }
                DispatchQueue.main.async {
                    self.updateUI(movieSerieDetail: movieSerieDetail , image: #imageLiteral(resourceName: "NoPhotoAvailable"))
                    self.setUpButtons(imdbID: movieSerieDetail.imdbID)
                    self.removeSpinner()
                }
            }
        }
    }
    
    func fetchMovieSerieDetail(){
        DispatchQueue.main.async {
            NetworkController.shared.fetchImage(with: URL(string: self.movieSerieDetail.posterString)!){
                image in
                guard let image = image else {return}
                
                
                DispatchQueue.main.async {
                    self.updateUI(movieSerieDetail: self.movieSerieDetail , image: image)
                    self.setUpButtons(imdbID: self.movieSerieDetail.imdbID)
                    self.updateRatingBar(rating: self.movieSerieDetail.favoriteRating.value)
                    self.removeSpinner()
                }
            }
        }
    }
    
    //book
    @IBAction func shareButtonPressed(_ sender: Any) {
        let image =  self.poster.image
        
        let text = "You should watch this \(self.movieSerieDetail.type): \(self.movieSerieDetail.title) \n\n" + (self.movieSerieDetail.plot ?? "")
        
        let shareItems = [image!, text] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareItems,applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController,animated: true,completion: nil)
    }

}
