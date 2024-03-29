//
//  MovieViewController.swift
//  codepath-flix-app
//
//  Created by Sergio P. on 10/20/19.
//  Copyright © 2019 Sergio P. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    var movies = [[String:Any]]()
    var genre: [String: Any]!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        navigationTitle.title? = (genre["name"] as! String)
        self.getMoviesWithGenre()
    }
    
    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        let movie = movies[indexPath.row]
        cell.movieTitle.text = (movie["title"] as! String)
        cell.releaseDate.text = (movie["release_date"] as! String)
        let movieRating = movie["vote_average"] as! Double
        cell.userRating.text = String(movieRating) + "/10"

        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        cell.moviePoster.af_setImage(withURL: posterUrl!)
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = table.indexPath(for: cell)!
        let activeMovie = self.movies[indexPath.row]

        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = activeMovie
        table.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Private Network Calls
    private func getMoviesWithGenre() {
        let genreId = String(genre["id"] as! Int)
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&with_genres=\(genreId)")!
        let request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalCacheData,
                                 timeoutInterval: 10)
        let session = URLSession(configuration: .default,
                                 delegate: nil,
                                 delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
            let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            self.movies = dataDictionary["results"] as! [[String:Any]]
            self.table.reloadData()
           }
        }
        task.resume()
    }
    
}
