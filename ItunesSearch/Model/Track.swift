//
//  Track.swift
//  ItunesSearch
//
//  Created by My Mac on 14/05/21.
//

import Foundation
class Track {
    let artist: String
    let index: Int
    let name: String
    let previewURL: URL
    let imageURL: URL
    
    
    init(name: String,artist: String,previewURL: URL,index: Int,imageURL: URL){
        self.name = name
        self.artist = artist
        self.previewURL = previewURL
        self.index = index
        self.imageURL = imageURL
    }
    
}
