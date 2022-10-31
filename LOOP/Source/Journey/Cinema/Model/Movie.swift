//
//  Created by Vijith on 21/10/2022.
//

import Foundation

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}

// MARK: - Movie
public class Movie: NSObject, Codable {
    
    let uuid = UUID()
    let rating: Double?
    let id, revenue: Int?
    let releaseDate: String?
    let director: Director?
    let posterURL: String?
    let cast: [Cast]?
    let runtime: Int?
    let title, overview: String?
    let reviews, budget: Int?
    let language: String?
    let genres: [String]?

    enum CodingKeys: String, CodingKey {
        case rating, id, revenue, releaseDate, director
        case posterURL = "posterUrl"
        case cast, runtime, title, overview, reviews, budget, language, genres
    }
}

// MARK: - Cast
public struct Cast: Codable, Hashable {
    let id = UUID()
    let name: String
    let pictureURL: String
    let character: String

    enum CodingKeys: String, CodingKey {
        case name
        case pictureURL = "pictureUrl"
        case character
    }
}

// MARK: - Director
public struct Director: Codable, Hashable {
    let id = UUID()
    let name: String
    let pictureURL: String

    enum CodingKeys: String, CodingKey {
        case name
        case pictureURL = "pictureUrl"
    }
}

public struct KeyFacts: Codable, Hashable {
    var id = UUID()
    let name: String
    let value: String
}
