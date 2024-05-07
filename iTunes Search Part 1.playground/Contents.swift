import UIKit

var greeting = "Hello, playground"

//var urlComponents = URLComponents(string: "https://itunes.apple.com/search?term=jcole&limit=1")!

let query = [
    "term": "J.Cole love yourz",
    "media": "music",
]

var url = URL(string: "https://itunes.apple.com/search")!
var urlComponents = URLComponents(string: "https://itunes.apple.com/search")
urlComponents?.queryItems = query.map { key, value in
    return URLQueryItem.init(name: key, value: value)
}

Task {
    guard let url = urlComponents?.url else { return }
    print(url)
    let (data, response) = try await URLSession.shared.data(from: url)
    
    if let httpResponse = response as? HTTPURLResponse,
       httpResponse.statusCode == 200,
       let string = String(data: data, encoding: .utf8) {
        print(string)
    }
}
