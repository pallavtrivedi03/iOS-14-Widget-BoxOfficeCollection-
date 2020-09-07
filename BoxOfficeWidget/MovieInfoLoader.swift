//
//  MovieInfoLoader.swift
//  BoxOffice
//
//  Created by Pallav Trivedi on 01/09/20.
//

import Foundation

struct MovieInfo: Codable {
    let name: String?
    let releaseDate: String?
    let daysSinceRelease: Int?
    let collection: String?
    let posterUrl: String?
    
    enum CodingKeys: String, CodingKey {
        
        case name = "name"
        case releaseDate = "releaseDate"
        case daysSinceRelease = "daysSinceRelease"
        case collection = "collection"
        case posterUrl = "posterUrl"
    }
    
    init(name: String, releaseDate: String, daysSinceRelease: Int, collection: String, posterUrl: String) {
        self.name = name
        self.releaseDate = releaseDate
        self.daysSinceRelease = daysSinceRelease
        self.collection = collection
        self.posterUrl = posterUrl
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate)
        daysSinceRelease = try values.decodeIfPresent(Int.self, forKey: .daysSinceRelease)
        collection = try values.decodeIfPresent(String.self, forKey: .collection)
        posterUrl = try values.decodeIfPresent(String.self, forKey: .posterUrl)
    }
}

struct MovieInfoLoader {
    static func fetch(completion: @escaping (Result<[MovieInfo], Error>) -> Void) {
        if let url = URL(string: "https://run.mocky.io/v3/5a1f9fbc-2f5d-4b54-a21c-116e8bc293cb") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
                if let responseData = data, let movieInfo = getMovieInfo(fromData: responseData) {
                    completion(.success(movieInfo))
                } else {
                    completion(.failure(error!))
                }
            }
            task.resume()
        }
    }
    
    static func getMovieInfo(fromData data: Foundation.Data) -> [MovieInfo]? {
        let jsonDecoder = JSONDecoder()
        do {
            let responseModel = try jsonDecoder.decode([MovieInfo].self, from: data)
            return responseModel
        } catch {
            return nil
        }
    }
}
