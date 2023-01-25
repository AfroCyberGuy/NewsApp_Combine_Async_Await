import Foundation
import Combine

class ViewModel: ObservableObject {
  
  // MARK: - Input
  @Published var searchTerm: String = ""
  
  
  // MARK: - Output
  @Published private(set) var result: [MovieDetail] = []
  @Published var isSearching = false
  
  
  // MARK: - Cancellables
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
            let result = await self.searchBooks(matching: value)
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
  
  
  
func searchBooks(matching searchTerm: String) async -> [MovieDetail] {
    
    let queryItems = [URLQueryItem(name: "q", value: searchTerm)]
    guard var request = createRequest(queryItems) else {
     
      return []
    }
    
    
    request.addValue("fd2a373acdmshcd5e16151f79375p1aa6fdjsn99bc9d9afefb", forHTTPHeaderField: "X-RapidAPI-Key")
    request.addValue("imdb8.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    print(request)
    do {
      let (data, response) = try await URLSession.shared.data(for: request)
      guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { throw URLError(.badServerResponse) }
      
      guard (200 ... 299) ~= statusCode else { throw URLError(.cannotParseResponse) }
      
      let searchResult = try JSONDecoder().decode(MovieResponse.self, from: data)
      
      guard let movieList = searchResult.data else { return [] }
      
      print(movieList)
      return movieList.compactMap {
        MovieDetail(title: $0.movieTitle ?? "", year: $0.year ?? "", rank: $0.rank ?? 0, imageUrl: $0.infor?.imageURL ?? "")
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
    components.host = "imdb8.p.rapidapi.com"
    components.path = "/auto-complete"
    
    return components
  }
}
