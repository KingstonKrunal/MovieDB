//
//  UrlData.swift
//  MovieDB
//
//  Created by Krunal Shah on 2022-07-17.
//

import Foundation

class DataStore {
    static let shared = DataStore()
    
    private let urlSession = URLSession.shared
    
    final var apiKey = "476ca195fabf7207acc1f52ab10f3415"
    
    func getSearchData(text: String) {
        //https://api.themoviedb.org/3/search/movie?api_key=476ca195fabf7207acc1f52ab10f3415&language=en-US&query=Race&page=1&include_adult=false
        
        let urlText = "https://api.themoviedb.org/3/search/movie?api_key=476ca195fabf7207acc1f52ab10f3415&language=en-US&query=\(text)"
        let url = URL(string: urlText)
        
        //Create URL Request
        var request = URLRequest(url: url!)
        
        //specify Get HTTP method
        request.httpMethod = "GET"
        
        urlSession.dataTask(with: request) { (data, response, error) in
                        
        }.resume()
    }
    
    /*
    func getMovieList() {
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
//                            self.movieNames.append(movie)
                        }
                        if let id = movie.id {
//                            self.movieIds.append(id)
                        }
                    }
                }
                
//                self.dataSource.reloadData(withItems: self.movieNames)
                
            }
            
//            self.movieCollection.reloadData()
            
            dataTask.resume()
        }
    }
     */
    
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

    struct MovieList: Decodable {
        let title: String?
        let id: Int?
    }

    struct MovieWrapper: Decodable {
        let results: [MovieList]
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
}
