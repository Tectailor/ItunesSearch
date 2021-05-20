//
//  SongsCollectionViewCell.swift
//  ItunesSearch
//
//  Created by My Mac on 14/05/21.
//

import UIKit

class SongsCollectionViewCell: UICollectionViewCell {
    static let identifier = "itunessongsCell"
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumName: UILabel!
  
    @IBOutlet weak var urlImage: UIImageView!
    
    func updateDisplay(track:Track){
        artistName.text = track.name
        albumName.text = track.artist
        let imageData:NSData = NSData(contentsOf: track.imageURL as URL)!
        let image = UIImage(data: imageData as Data)
        urlImage.image = image
    }
}
