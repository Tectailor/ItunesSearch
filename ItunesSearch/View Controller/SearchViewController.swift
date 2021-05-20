//
//  ViewController.swift
//  ItunesSearch
//
//  Created by My Mac on 13/05/21.
//

import UIKit
import AVKit
import AVFoundation

class SearchViewController: UIViewController {

   
    let queryService = QueryService()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    private let spacing:CGFloat = 9.0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView!.collectionViewLayout = layout

    }


    var searchResults: [Track] = []
    lazy var tapRecognizer: UITapGestureRecognizer = {
      var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
      return recognizer
    }()
    
    @objc func dismissKeyboard() {
      searchBar.resignFirstResponder()
    }
    

    func playDownload(_ track: Track) {
        let playerViewController = AVPlayerViewController()
        present(playerViewController, animated: true, completion: nil)
        let player = AVPlayer(url: track.previewURL)
        playerViewController.player = player
        player.play()
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
      return .topAttached
    }
    
    func reload(_ row: Int){
      collectionView.reloadItems(at: [IndexPath(row: row, section: 0)])
    }
}

extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    dismissKeyboard()
    
    guard let searchText = searchBar.text, !searchText.isEmpty else {
        
      return
    }
    
    //UIApplication.shared.isNetworkActivityIndicatorVisible = true
    queryService.getSearchResults(searchTerm: searchText) { [weak self] results, errorMessage in
    //UIApplication.shared.isNetworkActivityIndicatorVisible = false
      
      if let results = results {
        self?.searchResults = results
        self?.collectionView.reloadData()
        self?.collectionView.setContentOffset(CGPoint.zero, animated: false)
      }
      
      if !errorMessage.isEmpty {
        print("Search error: " + errorMessage)
      }
    }
  }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.collectionView.reloadData()
    }
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    view.addGestureRecognizer(tapRecognizer)
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    view.removeGestureRecognizer(tapRecognizer)
  }
}

//
// MARK: - Collection View Data Source
//
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"itunessongsCell" , for: indexPath) as! SongsCollectionViewCell
        let track = searchResults[indexPath.row]
        cell.layer.borderWidth = 1
        cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        cell.updateDisplay(track: track)
        return cell
    }
}
  

extension SearchViewController: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        let cell = collectionView.cellForItem(at: indexPath)
            cell?.layer.borderColor = UIColor.red.cgColor
            cell?.layer.borderWidth = 1
            cell?.isSelected = true
            let track = searchResults[indexPath.row]
            playDownload(track)
            collectionView.deselectItem(at: indexPath, animated: true)
  
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = nil
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20,left: 5,bottom: 10,right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let numberOfItemsPerRow:CGFloat = 3
            let spacingBetweenCells:CGFloat = 9
            
            let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
            
            if let collection = self.collectionView{
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                return CGSize(width: width, height: width)
            }else{
                return CGSize(width: 0, height: 0)
            }
        }
}
