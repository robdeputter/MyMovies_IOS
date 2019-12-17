//
//  MovieSerie.swift
//  MyMovies
//
//  Created by Rob De Putter on 09/12/2019.
//  Copyright © 2019 Rob De Putter. All rights reserved.
//

import Foundation

class MovieSerie : Decodable{
    var imdbID : String
    var title : String
    var year : String
    var type : String
    var poster : String
    
    enum CodingKeys : String, CodingKey{
        case title = "Title"
        case imdbID
        case year = "Year"
        case type = "Type"
        case poster = "Poster"
    }
    
    required init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        self.imdbID = try valueContainer.decode(String.self, forKey: CodingKeys.imdbID)
        self.title = try valueContainer.decode(String.self, forKey: CodingKeys.title)
        self.year = try valueContainer.decode(String.self, forKey: CodingKeys.year)
        self.type = try valueContainer.decode(String.self, forKey: CodingKeys.type)
        self.poster = try valueContainer.decode(String.self, forKey: CodingKeys.poster)
    }
}
