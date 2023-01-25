import Foundation
import Combine

class NewsViewModel: ObservableObject {
  
  @Published var searchTerm: String = ""
  @Published private(set) var result: [ArticleDetail] = []
  @Published var isSearching = false
  
  private var cancellables = Set<AnyCancellable>()
  
  
  init() {
    $searchTerm
      .debounce(for: 0.8, scheduler: DispatchQueue.main)
      .removeDuplicates()
      .handleEvents(receiveOutput: { output in
        self.isSearching = true
      })
      .flatMap { value in
        Future { promise in
          Task {
            let result = await self.searchArticles(matching: value)
            promise(.success(result))
          }
        }
      }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
      .handleEvents(receiveOutput: { output in
        self.isSearching = false
      })
      .assign(to: &$result)
  }
  
  
  
  func searchArticles(matching searchTerm: String) async -> [ArticleDetail] {
    
    let queryItems = [
      URLQueryItem(name: "q", value: searchTerm),
      URLQueryItem(name: "from", value: "2022-12-30"),
      URLQueryItem(name: "sortBy", value: "popularity"),
      URLQueryItem(name: "apiKey", value: "90379bf949ce4f4eb2b8dcf76d969d89")
    ]
    
    guard var request = createRequest(queryItems) else {
      return []
    }
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    print(request)
    do {
      let (data, response) = try await URLSession.shared.data(for: request)
      guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { throw URLError(.badServerResponse) }
      
      guard (200 ... 299) ~= statusCode else { throw URLError(.cannotParseResponse) }
      
      var articles: [Article] = []
      do {
        let searchResult = try   JSONDecoder().decode(NewsResponse.self, from: data)
       
        articles = searchResult.articles ?? []
  
      } catch (let error){
        print(error)
      }
      
      return articles.compactMap {
        ArticleDetail(
          source: $0.source!,
          author: $0.author ?? "",
          title: $0.title ?? "",
          description: $0.description ?? "",
          url: $0.url,
          urlToImage: $0.urlToImage ?? "",
          publishedAt: $0.publishedAt,
          content: $0.content ?? ""
        )
      } 
    }
    catch {
      return []
    }
  }
  
  private func createRequest(_ queryItems: [URLQueryItem]) -> URLRequest? {
    var components = commonComponents
    components.queryItems = queryItems
    
    guard let url = components.url else { return nil }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    return request
  }
  
  private var commonComponents: URLComponents {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "newsapi.org"
    components.path = "/v2/everything"
    
    return components
  }
}

enum RequestError: Error {
  
  case decode
  case invalidURL
  case noResponse
  case unauthorized
  case unexpectedStatusCode
  case unknown
  
  var customMessage: String {
    switch self {
      case .decode:
        return "Decode error"
      case .unauthorized:
        return "Session expired"
      default:
        return "Unknown error"
    }
  }
}
