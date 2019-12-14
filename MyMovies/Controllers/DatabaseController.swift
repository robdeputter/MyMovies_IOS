//
//  DatabaseController.swift
//  MyMovies
//
//  Created by Rob De Putter on 14/12/2019.
//  Copyright © 2019 Rob De Putter. All rights reserved.
//

import Foundation
import RealmSwift

//SOURCE: https://realm.io/docs/swift/latest
/**
 DatabaseController is the main controller for data manipulation of the favorites and watchlist
 --> All set in 1 controller = clear
 */
class DatabaseController{
    
    static let shared = DatabaseController()
    var favorites : Results<MovieSerieDetail> = try! Realm().objects(MovieSerieDetail.self).filter("inWatchList == false")
    var watchlistEntities : Results<MovieSerieDetail> = try! Realm().objects(MovieSerieDetail.self).filter("inWatchList == true")
    
    func addFavorite(movieSerieDetail : MovieSerieDetail, rating : Int, completion: @escaping(Error?) -> Void){
        do{
            let realm = try! Realm()
            try realm.write{
                if((realm.object(ofType: MovieSerieDetail.self, forPrimaryKey: movieSerieDetail.imdbID)) != nil){
                    let movieSerieDetailFromDB = realm.object(ofType: MovieSerieDetail.self, forPrimaryKey: movieSerieDetail.imdbID)
                    movieSerieDetailFromDB?.favoriteRating.value = rating
                    realm.add(movieSerieDetailFromDB!, update: .modified)
                }
                else{
                    movieSerieDetail.favoriteRating.value = rating
                    //source: https://academy.realm.io/posts/realm-primary-keys-tutorial/
                    realm.add(movieSerieDetail)
                }
            }
            completion(nil)
        }catch let error as NSError{
            completion(error)
        }
    }
    
    
    func addWatchListEntity(movieSerieDetail : MovieSerieDetail, completion: @escaping(Error?) -> Void){
        do{
            let realm = try! Realm()
            try realm.write{
                if((realm.object(ofType: MovieSerieDetail.self, forPrimaryKey: movieSerieDetail.imdbID)) != nil){
                    let movieSerieDetailFromDB = realm.object(ofType: MovieSerieDetail.self, forPrimaryKey: movieSerieDetail.imdbID)
                    movieSerieDetailFromDB?.inWatchList = true
                    realm.add(movieSerieDetailFromDB!, update: .modified)
                }
                else{
                    movieSerieDetail.inWatchList = true
                    //source: https://academy.realm.io/posts/realm-primary-keys-tutorial/
                    realm.add(movieSerieDetail)
                }
            }
            completion(nil)
        }catch let error as NSError{
            completion(error)
        }
        
    }
    
    func inWatchlist(movieSerieDetail : MovieSerieDetail, completion: @escaping(Bool) -> Void){
        do{
            let realm = try! Realm()
            
            guard let movieSerieDb = realm.object(ofType: MovieSerieDetail.self, forPrimaryKey: movieSerieDetail.imdbID) else
            {
                completion(false)
                return
            }
            
            //if inWatchlist => false ==> false
            completion(movieSerieDb.inWatchList)
        }
    }
    
    func inFavorites(movieSerieDetail : MovieSerieDetail, completion: @escaping(Bool) -> Void){
        do{
            let realm = try! Realm()
            
            guard let movieSerieDb = realm.object(ofType: MovieSerieDetail.self, forPrimaryKey: movieSerieDetail.imdbID) else
            {
                completion(false)
                return
            }
            completion(movieSerieDb.favoriteRating.value == nil)
        }
    }
}
