//
//  MovieCell.swift
//  MovieApp
//
//  Created by Yali Sun on 12/15/20.
//

import UIKit

class MovieCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(image: UIImage, text: String){
        imageView.image = image
        textLabel.text = text
    }

}

