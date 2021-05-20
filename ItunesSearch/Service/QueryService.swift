//
//  QueryService.swift
//  ItunesSearch
//
//  Created by My Mac on 14/05/21.
//

import Foundation
class QueryService {
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
    var tracks: [Track] = []
    
    typealias  JSONDictionary = [String:Any]
    typealias QueryResult = ([Track]?, String) -> Void
    
    func getSearchResults(searchTerm:String, completion: @escaping QueryResult){
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string: "https://itunes.apple.com/search") {
            urlComponents.query = "media=music&entity=song&term=\(searchTerm)"
            //urlComponents.query = "?term=\(searchTerm)"

            guard let url = urlComponents.url else {
              return
            }
            dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
              defer {
                self?.dataTask = nil
              }
                if let error = error {
                  self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if
                  let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 {
                    self?.updateSearchResults(data)
                    
                    // 6
                    DispatchQueue.main.async {
                      completion(self?.tracks, self?.errorMessage ?? "")
                    }
                  }
                }
                
                // 7
                dataTask?.resume()
              }
    
        }
    
    private func updateSearchResults(_ data: Data) {
      var response: JSONDictionary?
      tracks.removeAll()
      
      do {
        response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
      } catch let parseError as NSError {
        errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
        return
      }
      
      guard let array = response!["results"] as? [Any] else {
        errorMessage += "Dictionary does not contain results key\n"
        return
      }
      
      var index = 0
      
      for trackDictionary in array {
        if let trackDictionary = trackDictionary as? JSONDictionary,
          let previewURLString = trackDictionary["previewUrl"] as? String,
          let previewURL = URL(string: previewURLString),
          let imageURLString = trackDictionary["artworkUrl30"] as? String,
          let imageURL = URL(string:imageURLString),
          let name = trackDictionary["trackName"] as? String,
          let artist = trackDictionary["artistName"] as? String {
            tracks.append(Track(name: name, artist: artist, previewURL: previewURL, index: index,imageURL: imageURL))
            index += 1
        } else {
          errorMessage += "Problem parsing trackDictionary\n"
        }
      }
    }
  

    
}
