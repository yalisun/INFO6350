//
//  ViewController.swift
//  MovieListApp
//
//  Created by Yali Sun on 12/15/20.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var loadMoreButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
           
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Loading..."
        searchController.searchBar.sizeToFit()
        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.isUserInteractionEnabled = false
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
        
        viewControllerInstance = self
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        self.setupGridView()
        
        self.loadMoreButton.layer.masksToBounds = true
        self.loadMoreButton.layer.cornerRadius = self.loadMoreButton.frame.width/15.0
        
        getMovieData(page: pageNum)
        
    }
       
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupGridView()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func setupGridView() {
        let flow = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(cellMarginSize)
        flow.minimumLineSpacing = CGFloat(cellMarginSize)
    }

    @IBAction func loadMoreButtonTap(_ sender: UIButton) {
        
        searchController.searchBar.isUserInteractionEnabled = false
        searchController.searchBar.placeholder = "Loading..."

        pageNum = pageNum + 1
        getMovieData(page: pageNum)
        
        let item = self.collectionView(self.collectionView, numberOfItemsInSection: 0) - 1
        let lastItemIndex = NSIndexPath(item: item, section: 0)
        self.collectionView.scrollToItem(at: lastItemIndex as IndexPath, at: .top, animated: true)
        
    }

}




extension ViewController: UICollectionViewDataSource,UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell

        DispatchQueue.main.async {
            if searchActive{
                cell.setData(
                    image: moviePosterArray[getPosterWithId(id: filteredMovieArray[indexPath.row].id!)!].poster!,
                    text:  filteredMovieArray[indexPath.row].title!)
            }
            else{
                cell.setData(
                    image: moviePosterArray[indexPath.row].poster!,
                    text:  movieArray[indexPath.row].title!)
            }
          }
          return cell

      }
      
      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

          if searchActive {
              return filteredMovieArray.count
          }
          else{
              return moviePosterArray.count
          }

      }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if searchActive{
            selectedMovie = filteredMovieArray[indexPath.row]
            selectedMoviePoster.poster = moviePosterArray[getPosterWithId(id: filteredMovieArray[indexPath.row].id!)!].poster!
        }
        else{
            selectedMovie = movieArray[indexPath.row]
            selectedMoviePoster.poster = moviePosterArray[indexPath.row].poster!
        }

        if let resultController = storyboard!.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController {
            let navController = UINavigationController(rootViewController: resultController)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated:true, completion: nil)
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.calculateWith()
        return CGSize(width: width, height: width)
        
    }

    func calculateWith() -> CGFloat {
        
        let estimatedWidth = CGFloat(estimateWidth)
        let cellCount = floor(CGFloat(self.view.frame.size.width / estimatedWidth))

        let margin = CGFloat(cellMarginSize * 2)
        let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount

        return width
    }
}

extension ViewController: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
//
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        searchActive = false
        self.dismiss(animated: true, completion: nil)

    }

    func updateSearchResults(for searchController: UISearchController)
    {
        if searchController.searchBar.text!.count >= 3 {
            searchActive = true
            let searchString = searchController.searchBar.text
            filteredMovieArray = movieArray.filter({ (item) -> Bool in
                let countryText: NSString = item.title! as NSString
                return (countryText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
            })
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }

        }else if searchController.searchBar.text!.count == 0 {
            searchActive = false
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }

    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

        searchActive = true
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }

    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        searchActive = false
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }

    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {

        if !searchActive {
            searchActive = true
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }

        searchController.searchBar.resignFirstResponder()
    }

}
