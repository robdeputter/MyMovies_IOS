//
//  NewReleaseResponse.swift
//  MyMovies
//
//  Created by Rob De Putter on 12/12/2019.
//  Copyright © 2019 Rob De Putter. All rights reserved.
//

import Foundation
class NewReleaseResponse : Decodable{
    var count : String
    var items : [NewRelease]
    
    enum CodingKeys : String , CodingKey{
        case count = "COUNT"
        case items = "ITEMS"
    }
    
    required init(from decoder : Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        self.count = try valueContainer.decode(String.self, forKey: CodingKeys.count)
        self.items = try valueContainer.decode([NewRelease].self, forKey: CodingKeys.items)
    }
}
