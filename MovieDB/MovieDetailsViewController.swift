//
//  MovieDetailsViewController.swift
//  MovieDB
//
//  Created by Krunal Shah on 2022-06-12.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var overviewData: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var director: UILabel!
    
    var id: Int?
    
    final var apiKey = "476ca195fabf7207acc1f52ab10f3415"
    var request = ""
    
    var movieId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("ID: \(id)" ?? "printed the ID")
        // Do any additional setup after loading the view.
        
        if let url = getUrl(request: String(id!)) {
            let urlSession = URLSession(configuration: .default)

            let dataTask = urlSession.dataTask(with: url) {
                data, response, error in
                print("in Closure")

                guard error == nil else {
                    print(error!)
                    return
                }

                guard let data = data else {
                    print("No data received")
                    return
                }
                
                print(data)

                if let movie = parseJson(data: data) {
                    print(movie)
                    
                    DispatchQueue.main.async {
                        self.movieName.text = movie.title
                        self.overviewData.text = movie.overview
                        self.director.text = movie.original_language
                        self.rating.text = String("\(movie.vote_average)")
                        self.movieId = movie.id
                    }
                }
            }
            
            dataTask.resume()
        }
        
        func getUrl(request: String) -> URL? {
            let baseUrl = "https://api.themoviedb.org/3/movie/\(request)"
            let apiKeyAttachment = "?api_key=\(apiKey)"
            let language = "&language=en-US"

            if request == "top_rated" {
                let page = "&page=1"
                let endpoint = "\(baseUrl)\(apiKeyAttachment)\(language)\(page)"

                print(endpoint)

                return URL(string: endpoint)
            } else {
                let endpoint = "\(baseUrl)\(apiKeyAttachment)\(language)"

                print(endpoint)

                return URL(string: endpoint)
            }
        }

        struct Movie: Decodable {
            let title: String?
            var overview = ""
            var original_language = ""
            var vote_average = 1.0
            let id: Int
        }

        func parseJson(data: Data) -> Movie? {
            let decoder = JSONDecoder()
            var wrapper: Movie?

            do {
                wrapper = try decoder.decode(Movie.self, from: data)
            } catch {
                print("Error in parseJson: \(error)")
            }

            return wrapper
        }
    }
    
    @IBAction func addToFavourite(_ sender: UIButton) {
        print("Movie id: \(movieId)")
    }
}
