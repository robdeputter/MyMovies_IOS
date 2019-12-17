//
//  MovieSerieDetailCell.swift
//  MyMovies
//
//  Created by Rob De Putter on 16/12/2019.
//  Copyright © 2019 Rob De Putter. All rights reserved.
//

import UIKit

class MovieSerieDetailCell: UITableViewCell {
    
    
    @IBOutlet var poster: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var year: UILabel!
    @IBOutlet var type: UILabel!
    
    //Stars for favorits
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //poster is loaded in die ViewController --> give it as a paramter
    func update(movieSerieDetail : MovieSerieDetail, image : UIImage){
        title.numberOfLines = 0
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.text = movieSerieDetail.title
        year.text = movieSerieDetail.year
        type.text = movieSerieDetail.type
        poster.image = image
        
        if(movieSerieDetail.favoriteRating.value != nil){
            switch movieSerieDetail.favoriteRating.value! {
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
        else{
            star1.image = UIImage(systemName: "star")
            star2.image = UIImage(systemName: "star")
            star3.image = UIImage(systemName: "star")
            star4.image = UIImage(systemName: "star")
            star5.image = UIImage(systemName: "star")
        }
    }
}
