//
//  RequestHelper.swift
//  MovieApp
//
//  Created by Yali Sun on 12/15/20.
//

import Foundation
import UIKit

public func getMovieData(page:Int){
    
    let urlString =  movieDataUrl + String(page)
    let urlStringg = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    let url = URL(string: urlStringg!)
    
    URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
        guard let data = data, error == nil else {
            print("URLSession Error : \(String(describing: error))")
            return
        }
        do
        {
            let movie = try JSONDecoder().decode(Movie.self, from: data)
            let movies : [Movie] = [movie]
            resultsCount +=  movies[0].results!.count
            for items in movies{
                for i in 0...items.results!.count - 1{
                    
                    movieArray.append(items.results![i])
                    setImage(path:(items.results?[i].poster_path)!, id: items.results![i].id!)
                    
                }
            }
        }
        catch let error{
            print("Json Parse Error : \(error)")
        }
    }).resume()
}

func setImage(path: String, id : Int) {
    
     let imageURL = URL(string: imageUrl + path)
    
     let group = DispatchGroup()
     group.enter()
    
     DispatchQueue.global().async {
        
        guard let imageData = try? Data(contentsOf: imageURL!) else {
            print("Image Data Error")
            return
        }
        let image = UIImage(data: imageData)
        
        DispatchQueue.main.async {
            moviePosterArray.append(MoviePoster(id: id, poster: image))
            viewControllerInstance.collectionView.reloadData()
            if moviePosterArray.count == resultsCount{
                searchController.searchBar.isUserInteractionEnabled = true
                searchController.searchBar.placeholder = "Search..."
            }
            group.leave()
            
         }
         group.wait()
        
     }
     group.wait()
 }

func getPosterWithId(id: Int) -> Int? {
    return movieArray.firstIndex { $0.id == id }
}

