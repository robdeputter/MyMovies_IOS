//
//  NewRelease.swift
//  MyMovies
//
//  Created by Rob De Putter on 09/12/2019.
//  Copyright © 2019 Rob De Putter. All rights reserved.
//

import Foundation

class NewRelease : Decodable{
    var imdbID : String = ""
    var title : String = ""
    var released : String?
    var type: String?
    var image : String?
    
    enum CodingKeys : String, CodingKey{
        case imdbID = "imdbid"
        case title
        case image
        case type
        case released
    }
    
    required init(from decoder : Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        self.imdbID = try valueContainer.decode(String.self, forKey: CodingKeys.imdbID)
        self.title = try valueContainer.decode(String.self, forKey: CodingKeys.title)
        
        
        let type = try valueContainer.decodeIfPresent(String.self, forKey: CodingKeys.type)
        let released = try valueContainer.decodeIfPresent(String.self, forKey: CodingKeys.released)
        let image = try valueContainer.decodeIfPresent(String.self, forKey: CodingKeys.image)
        
        
        if let type = type{
            self.type = type
        }
        if let released = released{
            self.released = released
        }
        if let image = image{
            self.image = image
        }
    }
}
