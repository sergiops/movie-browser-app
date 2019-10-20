//
//  GenreViewController.swift
//  codepath-flix-app
//
//  Created by Sergio P. on 10/13/19.
//  Copyright © 2019 Sergio P. All rights reserved.
//

import UIKit
import AlamofireImage

class GenreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    var genres = [[String:Any]]()
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        self.getGenres()
    }
    
    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenreCell") as! GenreCell
        let activeGenre = genres[indexPath.row]
        cell.textLabel?.text = (activeGenre["name"] as! String)
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = table.indexPath(for: cell)!
        let activeGenre = self.genres[indexPath.row]
        
        let movieTableView = segue.destination as! MovieViewController
        movieTableView.genre = activeGenre
        table.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Private Network Calls
    private func getGenres() {
        let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US")!
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
            self.genres = dataDictionary["genres"] as! [[String:Any]]
            self.table.reloadData()
           }
        }
        task.resume()
    }
    
}
