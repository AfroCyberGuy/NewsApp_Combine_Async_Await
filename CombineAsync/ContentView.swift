//
//  ContentView.swift
//  CombineAsync
//
//  Created by mac on 04/01/2023.
//

import SwiftUI

struct ContentView: View {
  @StateObject var viewModel = NewsViewModel()
  
    var body: some View {

      NavigationStack {
        if viewModel.isSearching {
          ProgressView()
        }
        List(viewModel.result) { article in
          NewsSearchRowView(article: article)
        }
        .searchable(text: $viewModel.searchTerm)
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct NewsSearchRowView: View {
  let article: ArticleDetail
  
  var body: some View {
    VStack{
      Text(article.title)
        .font(.system(size: 14))
    }
  }
}


struct MovieSearchRowView: View {
  let movie: MovieDetail
  
  var body: some View {
    VStack{
      Text(movie.title)
    }
  }
}
