 //
 //  NetworkController.swift
 //  MyMovies
 //
 //  Created by Rob De Putter on 12/12/2019.
 //  Copyright © 2019 Rob De Putter. All rights reserved.
 //
 
 import Foundation
 
 class NetworkController{
    static let instance : NetworkController = NetworkController()
    
    let baseURLimdb = URL(string: "https://movie-database-imdb-alternative.p.rapidapi.com")!
    
    func fetchSearchMovieSerie(with name : String?, with year : String? , with type : String?,
                               completion : @escaping (_ movieSeries : [MovieSerie]?) -> Void){
        
        let queries : [String : String] = [
            "s" : name ?? "",
            "y" : year ?? "",
            "type" : type ?? ""
        ]
        
        let url = baseURLimdb.withQueries(queries)!
        let req = url.addUrlHeaders(for: url)
        
        let task = URLSession.shared.dataTask(with: req){
            (data,response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let movieSerieResponse = try? jsonDecoder.decode(MovieSerieResponse.self, from: data){
                completion(movieSerieResponse.search)
            }
            else{
                completion(nil)
            }
        }
        task.resume()
        
        
    }
    
    
    
 }
 extension URL{
    func addUrlHeaders(for url : URL) -> URLRequest{
        var req = URLRequest(url: url)
        
        req.setValue("a5f6b222camsh8d8cf36d4842c16p1e1b3cjsnba17b5622d41", forHTTPHeaderField: "x-rapidapi-key")
        return req
    }
    
    func withQueries(_ queries : [String : String]) -> URL?{
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map { URLQueryItem(name: $0.0, value: $0.1)}
        
        return components?.url
    }
    
    
 }
