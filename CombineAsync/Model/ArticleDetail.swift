import Foundation


struct ArticleDetail: Codable, Identifiable {
  var id: UUID = UUID()
  let source: Source
  let author: String
  let title: String
  let description: String
  let url: String
  let urlToImage: String
  let publishedAt: String
  let content: String
  
  init(source: Source, author: String, title: String, description: String, url: String, urlToImage: String, publishedAt: String, content: String) {
    self.source = source
    self.author = author
    self.title = title
    self.description = description
    self.url = url
    self.urlToImage = urlToImage
    self.publishedAt = publishedAt
    self.content = content
  }
}
