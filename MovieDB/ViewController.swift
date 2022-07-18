//
//  ViewController.swift
//  MovieDB
//
//  Created by Krunal Shah on 2022-05-22.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var movieCollection: UICollectionView!
    
    final var apiKey = "476ca195fabf7207acc1f52ab10f3415"
    var request = ""
    var movieNames: [String] = []
    var movieIds: [Int] = []
    var dataSource = CustomDataSource.getInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        movieCollection.delegate = self
        movieCollection.dataSource = dataSource

        if let url = getUrl(request: "top_rated") {
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

                if let movieWrapper = self.parseJson(data: data) {
                    let movies = movieWrapper.results

                    for movie in movies {
                        if let movie = movie.title {
                            print()
                            print("\(movie)")
                            self.movieNames.append(movie)
                        }
                        if let id = movie.id {
                            self.movieIds.append(id)
                        }
                    }
                }
                
                self.dataSource.reloadData(withItems: self.movieNames)
                
            }
            
            self.movieCollection.reloadData()
            
            dataTask.resume()
        }
    }

    //        https://api.themoviedb.org/3/movie/top_rated?api_key=476ca195fabf7207acc1f52ab10f3415&language=en-US&page=1
    func getUrl(request: String) -> URL? {
        let baseUrl = "https://api.themoviedb.org/3/movie/\(request)"
        let apiKeyAttachment = "?api_key=\(apiKey)"
        let language = "&language=en-US"

        if request == "top_rated" {
            let page = "&page=1"
//            let page = ""
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
    
    var selectedId: Int = 0
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // to next page
        selectedId = movieIds[indexPath.row]
        performSegue(withIdentifier: "toMovieDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMovieDetails" {
            guard let vc = segue.destination as? MovieDetailsViewController else { return }
            vc.id = selectedId
        }
    }
}



class CustomDataSource: NSObject, UICollectionViewDataSource {

    static var dataSource: CustomDataSource? = nil
    
    typealias ConfigureCellClosure = (_ item: String, _ cell: MovieCollectionViewCell) -> Void
    private var items: [String]
    private let identifier: String
    private var configureCellClosure: ConfigureCellClosure

    static func getInstance() -> CustomDataSource {
        if dataSource == nil {
            dataSource = CustomDataSource(withData: [], andId:  MovieCollectionViewCell.identifier) { (name, cell) in
                cell.movieLabel.text = name
            }
        }
        return dataSource!
    }
    
    func reloadData(withItems items: [String]) {
        self.items = items
        print("reload called")
    }
    
    private init(withData items: [String], andId identifier: String, withConfigBlock config:@escaping ConfigureCellClosure) {

        self.identifier = identifier
        self.items      = items
        self.configureCellClosure = config
    }

    func item(at indexpath: IndexPath) -> String {
        return items[indexpath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath) as! MovieCollectionViewCell
        configureCellClosure(items[indexPath.row], cell)
        return cell
    }
}
