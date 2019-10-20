//
//  MovieDetailsViewController.swift
//  codepath-flix-app
//
//  Created by Sergio P. on 10/19/19.
//  Copyright © 2019 Sergio P. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController {
    var movie: [String: Any]!

    @IBOutlet weak var backdropPreview: UIImageView!
    @IBOutlet weak var posterPreview: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var userRating: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTitle.text = (movie["title"] as! String)
        overview.text = (movie["overview"] as! String)
        releaseDate.text = (movie["release_date"] as! String)
        let movieRating = movie["vote_average"] as! Double
        userRating.text = String(movieRating) + "/10"
        self.setPosterImage()
        self.setBackdropImage()
    }
    
    // MARK: - Set Images
    private func setPosterImage() {
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        posterPreview.af_setImage(withURL: posterUrl!)
    }
    
    private func setBackdropImage() {
        let baseUrl = "https://image.tmdb.org/t/p/w1280"
        let posterPath = movie["backdrop_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        backdropPreview.af_setImage(withURL: posterUrl!)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
