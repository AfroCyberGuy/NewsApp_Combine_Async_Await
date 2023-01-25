//
//  MovieDetail.swift
//  CombineAsync
//
//  Created by mac on 15/01/2023.
//

import Foundation

struct MovieDetail: Identifiable {
  
  let id = UUID()
  let title: String
  let year: String
  let rank: Int
  let imageUrl: String
  
  init(title: String, year: String, rank: Int, imageUrl: String) {
    self.title = title
    self.year = year
    self.rank = rank
    self.imageUrl = imageUrl
  }
}
