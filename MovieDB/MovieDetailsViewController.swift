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
    @IBOutlet weak var releaseData: UILabel!
    @IBOutlet weak var adult: UILabel!
    @IBOutlet weak var originalLanguage: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    var id: Int?
    
    final var apiKey = "476ca195fabf7207acc1f52ab10f3415"
    var request = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(id ?? "printed the ID")
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

                if let movie = parseJson(data: data) {
                    
                    if let movie = movie.title {
                        self.movieName.text = movie
                    }
                    if let ov = movie.overview ?? nil {
                            self.overviewData.text = ov
                        }
                    if let rD = movie.release_date {
                        self.releaseData.text = rD
                    }
                    if let adult: Bool = movie.adult ?? nil {
                        self.adult.text = String("\(adult)")
                    }
                    if let oL: String = movie.original_language ?? nil {
                        self.originalLanguage.text = oL
                    }
                    if let rating: Int = movie.rating ?? nil {
                        self.rating.text = String("\(rating)")
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
        var release_date: Optional<String> = ""
        var adult = false
        var original_language = ""
        var rating = 0
    }

    func parseJson(data: Data) -> Movie? {
        let decoder = JSONDecoder()
        var wrapper: Movie?

        do {
            wrapper = try decoder.decode(Movie.self, from: data)
        } catch {
            print(error)
        }

        return wrapper
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
}
