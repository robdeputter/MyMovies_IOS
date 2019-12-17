 //
 //  NetworkController.swift
 //  MyMovies
 //
 //  Created by Rob De Putter on 12/12/2019.
 //  Copyright © 2019 Rob De Putter. All rights reserved.
 //
 
 import Foundation
 import UIKit
 
 class NetworkController{
    static let shared : NetworkController = NetworkController()
    
    let baseURLimdb = URL(string: "https://movie-database-imdb-alternative.p.rapidapi.com")!
    let baseURLunogs = URL(string: "https://unogs-unogs-v1.p.rapidapi.com/aaapi.cgi")!
    
    func fetchSearchMovieSeries(with name : String?, with year : String? , with type : String?,
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
    
    func fetchMovieSerieDetail(with imdbId : String, completion : @escaping (_ movieSerieDetail : MovieSerieDetail?) -> Void){
        let query : [String : String] = [
            "i" : imdbId
        ]
        
        let url = baseURLimdb.withQueries(query)!
        let req = url.addUrlHeaders(for: url)
        
        let task = URLSession.shared.dataTask(with: req){
            (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let movieSerieDetail = try? jsonDecoder.decode(MovieSerieDetail.self, from: data){
                completion(movieSerieDetail)
            }
            else{
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchImage(with url : URL, completion : @escaping (UIImage?) -> Void){
        let task = URLSession.shared.dataTask(with: url){
            (data, response, error) in
            if let data = data{
                URLCache.shared.storeCachedResponse(CachedURLResponse(response: response!, data: data), for: URLRequest(url: url))
                
                let img = UIImage(data: data)
                completion(img)
            }
            else{
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchNewReleases(completion : @escaping (_ newReleases : [NewRelease]?) -> Void){
        let queries : [String : String] = [
            "q": "get:new7:BE",
            "p": "1"
        ]
        
        let url = baseURLunogs.withQueries(queries)!
        let req = url.addUrlHeaders(for: url)
        
        let task = URLSession.shared.dataTask(with: req){
            (data,response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let newReleaseResponse = try? jsonDecoder.decode(NewReleaseResponse.self, from: data){
                completion(newReleaseResponse.items)
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
