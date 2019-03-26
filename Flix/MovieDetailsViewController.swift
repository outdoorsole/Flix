//
//  MovieDetailsViewController.swift
//  Flix
//
//  Created by Maribel Montejano on 3/26/19.
//  Copyright © 2019 Maribel Montejano. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    // MARK: - Properties
    var movie: [String: Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(movie["title"])
    }
    
}
