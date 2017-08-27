//
//  MovieDetailsViewController.swift
//  MoviesFromJson
//
//  Created by Tomer Buzaglo on 24/08/2017.
//  Copyright © 2017 iTomerBu. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var posterImage: UIImageView!

    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    var data: Movie!{
        didSet{
            updateUI()
        }
    }
    
    func updateUI(){
        titleLabel?.text = data?.title
        genreLabel?.text = data?.genres.first
        
        let url = URL(string: data?.poster ?? "")
        
        posterImage?.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "place"))
    }
}
