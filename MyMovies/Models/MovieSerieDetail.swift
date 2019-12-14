//
//  MovieSerieDetail.swift
//  MyMovies
//
//  Created by Rob De Putter on 09/12/2019.
//  Copyright © 2019 Rob De Putter. All rights reserved.
//

import Foundation


class MovieSerieDetail : Decodable{
    var imdbID : String
    var title : String
    var year : String
    var type : String
    var poster : URL
    var released : String
    var runTime : String?
    var genre : String
    var actors : String
    var imdbRating : String
    var imdbVotes : String
    var plot : String?
    
    enum CodingKeys : String , CodingKey{
        case imdbID
        case title = "Title"
        case year = "Year"
        case type = "Type"
        case poster = "Poster"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case actors = "Actors"
        case imdbRating
        case imdbVotes
        case plot = "Plot"
    }
    
    required init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        self.imdbID = try valueContainer.decode(String.self, forKey: CodingKeys.imdbID)
        self.title = try valueContainer.decode(String.self, forKey: CodingKeys.title)
        self.year = try valueContainer.decode(String.self, forKey: CodingKeys.year)
        self.type = try valueContainer.decode(String.self, forKey: CodingKeys.type)
        self.poster = try valueContainer.decode(URL.self, forKey: CodingKeys.poster)
        self.released = try valueContainer.decode(String.self, forKey: CodingKeys.released)
        
        self.genre = try valueContainer.decode(String.self, forKey: CodingKeys.genre)
        self.actors = try valueContainer.decode(String.self, forKey: CodingKeys.actors)
        self.imdbRating = try valueContainer.decode(String.self, forKey: CodingKeys.imdbRating)
        self.imdbVotes = try valueContainer.decode(String.self, forKey: CodingKeys.imdbVotes)
        
        let runTime = try valueContainer.decodeIfPresent(String.self, forKey: CodingKeys.runtime)
        if let runTime = runTime{
            self.runTime = runTime
        }
        
        let plot = try valueContainer.decodeIfPresent(String.self, forKey: CodingKeys.plot)
        if let plot = plot{
            self.plot = plot
        }
        
        
    }
}
