//
//  MovieResponse.swift
//  CombineAsync
//
//  Created by mac on 12/01/2023.
//

import Foundation

struct MovieResponse: Codable {
  
  let data: [MovieData]?
  let query: String?
  
  enum CodingKeys: String, CodingKey {
    case data = "d"
    case query = "q"
  }
}


struct MovieData: Codable {
  
  let infor: MovieInformation?
  let id: String?
  let movieTitle: String?
  let rank: Int?
  let starring: String?
  let feature: String?
  let qid: String?
  let year: String?
  
  enum CodingKeys: String, CodingKey {
    case infor = "i"
    case id
    case movieTitle = "l"
    case rank
    case starring = "s"
    case feature = "q"
    case qid
    case year = "y"
  }
}



struct MovieInformation: Codable {
  
  let height: Int?
  let imageURL: String?
  let width: Int?
  
  enum CodingKeys: String, CodingKey {
    case height
    case imageURL = "imageUrl"
    case width
  }
}
