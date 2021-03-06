//
//  MoviesViewController.swift
//  Flix
//
//  Created by Maribel Montejano on 3/26/19.
//  Copyright © 2019 Maribel Montejano. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: = Properties
    var movies = [[String: Any]]()  // Initialize an array of dictionaries to store the movies that will come back from the request
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        // The height of each row in the table view
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        
        // CREATE A NETWORK REQUEST
        // URL: a value that identifies the location of a resource, such as an item on a remote server or the path to a local file
        // Uniform Resource Locator (URL): web address
        // gives the location of the resource on a computer network, and a mechanism for retrieving it
        // gives the protocol, the hostname, and the file name
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        
        // URLRequest: A URL load request that is independent of protocol or URL scheme (creates and initializes a URL request with the given URL, cache policy, and timeout interval)
        // .reloadIgnoringLocalCacheData: the URL load should be loaded only from the originating source
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        // URL Session: An object that coordinates a group of related network data transfer tasks
        // OperationQueue: a queue that regulates the execution of operations
        // OperationQueue.main: returns the OperationQueue associated with the main thread
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        // Creates a task that retrieves the contents of a URL based on the specific URL request object, and calls a handler upon completion
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                // JSONSerialization: An object that converts between JSON and the equivalent Foundation objects
                // .jsonObject: returns a foundation object from the given JSON data
                // Cast as a dictionary
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                print(dataDictionary)
                
                // Access the results key inside of the dictionary (contains the list of movies)
                self.movies = dataDictionary["results"] as! [[String: Any]]
                
                // Reload data after the completion handler gets the list of movies and assigns it to the MoviesViewController movies property
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    // MARK: - Table view data source required methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // the number of movie objects in the array
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Change from having individual cells to re-using (recycling) cells
        // Helps with saving memory
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        // Access the current movie
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        // The value of the row element at that indexPath
        cell.titleLabel?.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseURL = "https://image.tmdb.org/t/p/"
        let size = "w185"
        let posterPath = movie["poster_path"] as! String
        // URL validates that it's correctly formed (in comparison to String)
        let posterURL = URL(string: baseURL + size + posterPath)
        
        // Downloads and sets the image
        cell.posterView.af_setImage(withURL: posterURL!)
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        print("Loading up the details screen")
        
        // Find the selected movie (sender is the selected cell)
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        // Pass the selected movie to the details view controller
        // This will be the destination
        let detailsViewController = segue.destination as! MovieDetailsViewController
        // Set the property
        detailsViewController.movie = movie
        
        // Deselect the row so it is no longer highlighted after being tapped
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
