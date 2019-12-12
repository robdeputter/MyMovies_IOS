//
//  MovieSerieResponse.swift
//  MyMovies
//
//  Created by Rob De Putter on 12/12/2019.
//  Copyright © 2019 Rob De Putter. All rights reserved.
//

import Foundation
class MovieSerieResponse : Decodable{
    var search : [MovieSerie]
    var totalResults : String?
    var response : String
    
    enum CodingKeys : String , CodingKey{
        case search = "Search"
        case totalResults
        case response = "Response"
    }
    
    required init(from decoder : Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        self.search = try valueContainer.decode([MovieSerie].self, forKey: CodingKeys.search)
        let totalResults = try valueContainer.decodeIfPresent(String.self, forKey: CodingKeys.totalResults)
        self.response = try valueContainer.decode(String.self, forKey: CodingKeys.response)
        
        if let totalResults = totalResults{
            self.totalResults = totalResults
        }
    }
}
