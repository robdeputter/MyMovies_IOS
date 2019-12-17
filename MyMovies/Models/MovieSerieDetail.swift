//
//  MovieSerieDetail.swift
//  MyMovies
//
//  Created by Rob De Putter on 09/12/2019.
//  Copyright © 2019 Rob De Putter. All rights reserved.
//

import Foundation
import RealmSwift
//SOURCE: https://realm.io/docs/swift/latest

class MovieSerieDetail : Object, Decodable{
    @objc dynamic var imdbID : String = ""
    @objc dynamic var title : String = ""
    @objc dynamic var year : String = ""
    @objc dynamic var type : String = ""
    @objc dynamic var posterString : String = ""
    @objc dynamic var released : String = ""
    @objc dynamic var runTime : String? = ""
    @objc dynamic var genre : String = ""
    @objc dynamic var actors : String = ""
    @objc dynamic var imdbRating : String = ""
    @objc dynamic var imdbVotes : String = ""
    @objc dynamic var plot : String?
    var favoriteRating : RealmOptional<Int> = RealmOptional<Int>()
    @objc dynamic var inWatchList : Bool = false
    
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
    override class func primaryKey() -> String? {
        return "imdbID"
    }
    
    required init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        self.imdbID = try valueContainer.decode(String.self, forKey: CodingKeys.imdbID)
        self.title = try valueContainer.decode(String.self, forKey: CodingKeys.title)
        self.year = try valueContainer.decode(String.self, forKey: CodingKeys.year)
        self.type = try valueContainer.decode(String.self, forKey: CodingKeys.type)
        self.posterString = try valueContainer.decode(String.self, forKey: CodingKeys.poster)
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
