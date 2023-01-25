//
//  NewsResponse.swift
//  CombineAsync
//
//  Created by mac on 16/01/2023.
//

import Foundation

struct NewsResponse: Codable {
  let status: String?
  let totalResults: Int?
  let articles: [Article]?
}


struct Article: Codable {
  let source: Source?
  let author: String?
  let title: String?
  let description: String?
  let url: String
  let urlToImage: String?
  let publishedAt: String
  let content: String?
  
  enum CodingKeys: CodingKey {
    case source
    case author
    case title
    case description
    case url
    case urlToImage
    case publishedAt
    case content
  }
}


struct Source: Codable {
  let id: String?
  let name: String
}
