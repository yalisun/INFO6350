//
//  MovieDetailsViewController.swift
//  MovieListApp
//
//  Created by Yali Sun on 12/15/20.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeToClose = UISwipeGestureRecognizer()
        swipeToClose.addTarget(self, action: #selector(goBack) )
        swipeToClose.direction = .right
        self.view!.addGestureRecognizer(swipeToClose)

        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
        
        navigationItem.title = selectedMovie.title
        
        overviewLabel.text = selectedMovie.overview
        overviewLabel.numberOfLines = 0
        overviewLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        voteAverageLabel.text = "Vote Average:" + String(format:"%.2f", selectedMovie.vote_average!)
        
        popularityLabel.text = "Popularity:" + String(format:"%.2f", selectedMovie.popularity!)

        imageView.image = selectedMoviePoster.poster
        
    }
    
    @objc func goBack(){
        dismiss(animated: true, completion: nil)
    }
}
