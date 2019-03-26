//
//  MovieGridViewController.swift
//  Flix
//
//  Created by Maribel Montejano on 3/26/19.
//  Copyright © 2019 Maribel Montejano. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - Outlets
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: - Properties
    var movies = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Use layout class to customize grid layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        // Controls the space in between the rows
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4

        // frame: the frame rectangle, which describes the view's location and size in its superview's coordinate system
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 3
        layout.itemSize = CGSize(width: width, height: width * 3/2)
        
        // CREATE A NETWORK REQUEST (for similar movies)
        // URL: a value that identifies the location of a resource, such as an item on a remote server or the path to a local file
        // Uniform Resource Locator (URL): web address
        // gives the location of the resource on a computer network, and a mechanism for retrieving it
        // gives the protocol, the hostname, and the file name
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=\(apiKey)")!
        
        // URLRequest: A URL load request that is independent of protocol or URL scheme (creates and initializes a URL request with the following)
        // .reloadIgnoringLocalCacheData: the URL load should be loaded only from the originating source
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        // URL Session: An object that coordinates a group of related network data transfer tasks
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        // Creates a task that retrieves the contents of a URL based on the specific URL request object, and calls a handler upon completion
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                // JSONSerialization: An object that converts between JSON and the equivalent Foundation objects
                // .jsonObject: returns a foundation object from the given JSON data
                // Cast as an array of dictionaries
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // Access a key inside of the dictionary and store in movies property
                // The results cast as an array of dictionaries
                self.movies = dataDictionary["results"] as! [[String: Any]]
                
                // Reload data after retrieving the list of movies
                self.collectionView.reloadData()
                
                print(self.movies)
            }
        }
        task.resume()
    }
    
    // MARK: - Collection view data source required methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = movies[indexPath.item]
        let baseURL = "https://image.tmdb.org/t/p/"
        let size = "w185"
        let posterPath = movie["poster_path"] as! String
        // URL validates that it's correctly formed (in comparison to String)
        let posterURL = URL(string: baseURL + size + posterPath)
        
        // Downloads and sets the image
        cell.posterView.af_setImage(withURL: posterURL!)
        
        return cell
    }
    
}
