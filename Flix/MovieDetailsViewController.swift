//
//  MovieDetailsViewController.swift
//  Flix
//
//  Created by Maribel Montejano on 3/26/19.
//  Copyright © 2019 Maribel Montejano. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    // MARK: - Properties
    
    var movie: [String: Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(movie["title"])
        
        titleLabel.text = movie["title"] as? String
        // Resizes and moves the receiver view so it just encloses its subviews
        titleLabel.sizeToFit()
        
        synopsisLabel.text = movie["overview"] as? String
        synopsisLabel.sizeToFit()
        
        releaseDateLabel.text = movie["release_date"] as? String
        synopsisLabel.sizeToFit()
        
        let baseURL = "https://image.tmdb.org/t/p/"
        let posterSize = "w185"
        let posterPath = movie["poster_path"] as! String
        // URL validates that it's correctly formed (in comparison to using String)
        let posterURL = URL(string: baseURL + posterSize + posterPath)
        
        // downloads and sets the image
        posterView.af_setImage(withURL: posterURL!)
        
        let backdropSize = "w780"
        let backdropPath = movie["backdrop_path"] as! String
        // URL validates that it's correctly formed (in comparison to using String)
        let backdropURL = URL(string: baseURL + backdropSize + backdropPath)
        
        // downloads and sets the image
        backdropView.af_setImage(withURL: backdropURL!)
    }
    
}
