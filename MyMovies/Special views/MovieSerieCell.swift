//
//  MovieSerieCell.swift
//  MyMovies
//
//  Created by Rob De Putter on 14/12/2019.
//  Copyright © 2019 Rob De Putter. All rights reserved.
//

import UIKit

class MovieSerieCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var poster: UIImageView!
    @IBOutlet var type: UILabel!
    @IBOutlet var year: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //poster is loaded in die ViewController --> give it as a paramter
    func update(movieSerie : MovieSerie, image : UIImage){
        title.numberOfLines = 0
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.text = movieSerie.title
        year.text = movieSerie.year
        type.text = movieSerie.type
        poster.image = image
    }
}
