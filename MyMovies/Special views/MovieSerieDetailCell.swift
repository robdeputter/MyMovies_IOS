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
    }
}
