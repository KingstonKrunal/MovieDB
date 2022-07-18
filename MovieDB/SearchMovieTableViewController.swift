//
//  MovieTableViewController.swift
//  MovieDB
//
//  Created by Krunal Shah on 2022-07-10.
//

import UIKit

class Movie {
    let name: String
    
    internal init(name: String) {
        self.name = name
    }
}

class SearchMovieTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var movieListTable: UITableView!
    
    var dataStore = DataStore.shared
    var movieList = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        
        searchBar.placeholder = "Search for Movie"
        
        navigationItem.titleView = searchBar
        
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the ng line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return movieList.count
        return 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchMovieCell", for: indexPath) as! SearchMovieTableViewCell
        
//        let movie = movieList[indexPath.row]
//        cell.fillCell(name: movie.name)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    struct Movie: Decodable {
        let title: String?
        let id: Int?
    }

    struct MovieWrapper: Decodable {
        let results: [Movie]
    }

    func parseJson(data: Data) -> MovieWrapper? {
        let decoder = JSONDecoder()
        var wrapper: MovieWrapper?

        do {
            wrapper = try decoder.decode(MovieWrapper.self, from: data)
        } catch {
            print(error)
        }

        return wrapper
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        
        // API call
        // Inside call back, parse data, add to movieList, reload data
        
        let urlText = "https://api.themoviedb.org/3/search/movie?api_key=476ca195fabf7207acc1f52ab10f3415&language=en-US&query=\(searchText)"
        let url = URL(string: urlText)
        
        let urlSession = URLSession(configuration: .default)

        let dataTask = urlSession.dataTask(with: url!) { data, response, error in
//            print("in Closure")

            guard error == nil else {
                print(error!)
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            if let movieWrapper = self.parseJson(data: data) {
                let movies = movieWrapper.results

                for movie in movies {
                    if let movie = movie.title {
                        print()
                        print("\(movie)")
//                        self.movieList.append(Movie(
//                            title: movie, id: movie.id
//                        ))
                    }
                }
            }
        }
        
        self.movieListTable.reloadData()
        
        dataTask.resume()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text = ""
    }
}

