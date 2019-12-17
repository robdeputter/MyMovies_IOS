//
//  HomeScreenViewController.swift
//  MyMovies
//
//  Created by Rob De Putter on 17/12/2019.
//  Copyright © 2019 Rob De Putter. All rights reserved.
//

import UIKit
import RealmSwift
class HomeScreenViewController: UIViewController {
    
    var favorites : Results<MovieSerieDetail>!
    var watchlistEntities : Results<MovieSerieDetail>!
    
    var topRatedFavorite : MovieSerieDetail?
    var watchListEntity : MovieSerieDetail?
    
    //favorite movie
    @IBOutlet weak var favoriteStackView: UIStackView!
    @IBOutlet weak var favoritePoster: UIImageView!
    @IBOutlet weak var favoriteTitle: UILabel!
    @IBOutlet weak var favoriteYear: UILabel!
    @IBOutlet weak var favoriteType: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    //watchlist movie
    @IBOutlet weak var watchlistStackView: UIStackView!
    @IBOutlet weak var watchlistPoster: UIImageView!
    @IBOutlet weak var watchlistTitle: UILabel!
    @IBOutlet weak var watchlistYear: UILabel!
    @IBOutlet weak var watchlistType: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favorites = DatabaseController.shared.favorites
        watchlistEntities = DatabaseController.shared.watchlistEntities
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        topRatedFavorite = favorites.first
        watchListEntity = watchlistEntities.first
        updateUI()
    }
    
    func updateUI(){
        if topRatedFavorite != nil{
            if(topRatedFavorite!.posterString != "N/A"){
                NetworkController.shared.fetchImage(with: URL(string: topRatedFavorite!.posterString)!){
                    image in
                    guard let image = image else {return}
                    
                    DispatchQueue.main.async {
                        self.updateRatingBar(rating: (self.topRatedFavorite?.favoriteRating.value!)!)
                        self.favoritePoster.image = image
                        self.favoriteTitle.text = self.topRatedFavorite?.title
                        self.favoriteType.text = self.topRatedFavorite?.type
                        self.favoriteYear.text = self.topRatedFavorite?.year
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.updateRatingBar(rating: (self.topRatedFavorite?.favoriteRating.value!)!)
                    self.favoritePoster.image = #imageLiteral(resourceName: "NoPhotoAvailable")
                    self.favoriteTitle.text = self.topRatedFavorite?.title
                    self.favoriteType.text = self.topRatedFavorite?.type
                    self.favoriteYear.text = self.topRatedFavorite?.year
                }
            }
            favoriteStackView.isHidden = false
        }
        else{
            favoriteStackView.isHidden = true
        }
        if watchListEntity != nil{
            if(watchListEntity!.posterString != "N/A"){
                NetworkController.shared.fetchImage(with: URL(string: watchListEntity!.posterString)!){
                    image in
                    guard let image = image else {return}
                    
                    DispatchQueue.main.async {
                        self.watchlistPoster.image = image
                        self.watchlistTitle.text = self.watchListEntity?.title
                        self.watchlistType.text = self.watchListEntity?.type
                        self.watchlistYear.text = self.watchListEntity?.year
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.watchlistPoster.image = #imageLiteral(resourceName: "NoPhotoAvailable")
                    self.watchlistTitle.text = self.watchListEntity?.title
                    self.watchlistType.text = self.watchListEntity?.type
                    self.watchlistYear.text = self.watchListEntity?.year
                }
            }
            watchlistStackView.isHidden = false
        }
        else{
            watchlistStackView.isHidden = true
        }
    }
    
    func updateRatingBar(rating : Int){
        switch rating {
        case 1:
            
            star1.image = UIImage(systemName: "star.fill")
            star2.image = UIImage(systemName: "star")
            star3.image = UIImage(systemName: "star")
            star4.image = UIImage(systemName: "star")
            star5.image = UIImage(systemName: "star")
        case 2:
            star1.image = UIImage(systemName: "star.fill")
            star2.image = UIImage(systemName: "star.fill")
            star3.image = UIImage(systemName: "star")
            star4.image = UIImage(systemName: "star")
            star5.image = UIImage(systemName: "star")
        case 3:
            star1.image = UIImage(systemName: "star.fill")
            star2.image = UIImage(systemName: "star.fill")
            star3.image = UIImage(systemName: "star.fill")
            star4.image = UIImage(systemName: "star")
            star5.image = UIImage(systemName: "star")
        case 4:
            star1.image = UIImage(systemName: "star.fill")
            star2.image = UIImage(systemName: "star.fill")
            star3.image = UIImage(systemName: "star.fill")
            star4.image = UIImage(systemName: "star.fill")
            star5.image = UIImage(systemName: "star")
        case 5:
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
        }
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
