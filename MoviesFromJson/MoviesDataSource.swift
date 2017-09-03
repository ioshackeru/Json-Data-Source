//
//  MoviesDataSource.swift
//  MoviesFromJson
//
//  Created by Tomer Buzaglo on 21/08/2017.
//  Copyright © 2017 iTomerBu. All rights reserved.
//

import UIKit


typealias JsonObject = [String : Any]

class MoviesDataSource {
    
    static func getMovies(handler: @escaping ([Movie])->Void){
        
        let urlAddress = "https://rss.itunes.apple.com/api/v1/il/movies/top-movies/25/explicit.json"
        
        let url = URL(string: urlAddress)! //the url must be valid, I Checked.
        
        let session = URLSession(configuration: .default) //tasks are run by the session
        //the default session is a priority session. saves chache
        
        //code that runs in the background:
        let task = session.dataTask(with: url) { (data:Data?, response, error) in
            
            guard let data = data else {
                return
            }
            
            let movies = parseJson(data: data)
            
            DispatchQueue.main.async {
                //code that runs on the UI Thread:
                handler(movies)
            }
        }
        task.resume()
    }
    
    static func parseJson(data:Data)->[Movie]{
        //binary data 13245 bytes
        //convert to binary to objects since our binary represents json:
        
        let dict = try! JSONSerialization.jsonObject(with: data, options: []) as! JsonObject
        
        let feed = dict["feed"] as! JsonObject
        let results = feed["results"] as! [JsonObject]
        
        var movies = [Movie]()
        
        for movieObject in results{
            let image = movieObject["artworkUrl100"] as! String
            let title = movieObject["name"] as! String
            
            let genresObjectArray = movieObject["genres"] as! [JsonObject]
            
            var genres = [String]()
            
            for genre in genresObjectArray{
                let genreName = genre["name"] as! String
                genres.append(genreName)
            }
            
            let movie = Movie(title: title, poster: image, genres: genres)
            movies.append(movie)
        }
        return movies
    }
}



//TODO:
//class Movie:
//title, geners[], poster
class Movie : CustomStringConvertible, Equatable{
    //properties:
    let title: String
    let genres: [String]
    let poster: String
    
    
    init(title:String, poster:String, genres:[String]) {
        self.title = title
        self.poster = poster
        self.genres = genres
    }
    
    var description: String{
        return "\(title)\n\(poster)\n\(genres)\n----------------\n"
    }
    public static func ==(lhs: Movie, rhs: Movie) -> Bool{
        return lhs.title == rhs.title && lhs.poster == rhs.poster && lhs.genres == rhs.genres
    }
}





































