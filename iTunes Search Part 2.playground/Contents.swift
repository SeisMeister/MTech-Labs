import UIKit
import Foundation

var greeting = "Hello, playground"

//Initial understanding after reading iTunes documentation
//let url = URL(string: "https://itunes.apple.com/search?term=jcole&limit=10")!

extension Data {
    func prettyPrintedJSONString() {
        guard
            let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
            let prettyJSONString = String(data: jsonData, encoding: .utf8) else {
            print("Failed to read JSON Object.")
            return
        }
        
        print(prettyJSONString)
    }
}

let url = URL(string: "https://itunes.apple.com/search")!

struct StoreItem: Codable {
    let trackName: String
    let artistName: String
    var kind: String
    var description: String
    var artworkURL: URL
    
    enum CodingKeys: String, CodingKey {
        case trackName
        case artistName
        case kind
        case description
        case artworkURL = "artworkUrl100"
    }
    
    enum AdditionalKeys: CodingKey {
        case longDescription
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        trackName = try values.decode(String.self, forKey: CodingKeys.trackName)
        artistName = try values.decode(String.self, forKey: CodingKeys.artistName)
        kind = try values.decode(String.self, forKey: CodingKeys.kind)
        artworkURL = try values.decode(URL.self, forKey: CodingKeys.artworkURL)
        
        if let description = try? values.decode(String.self, forKey: CodingKeys.description) {
            self.description = description
        } else {
            let additionalValues = try decoder.container(keyedBy: AdditionalKeys.self)
            description = (try? additionalValues.decode(String.self, forKey: AdditionalKeys.longDescription)) ?? ""
        }

    }
    
}

struct SearchResponse: Codable {
    let results: [StoreItem]
}

enum itemsError: Error, LocalizedError {
    case itemNotFound
}

func fetchItems(matching query: [String: String]) async throws -> [StoreItem] {
    var urlComponents = URLComponents(string: "https://itunes.apple.com/search")!
//    urlComponents.queryItems = [ "Apple" : "jcole", "song" : "crooked_smile" ].map { URLQueryItem(name: $0.key, value: $0.value) }
    
    urlComponents.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
    
    let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
   
    print(response)
    print(String(data: data, encoding: .utf8))

    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
        throw itemsError.itemNotFound
    }
    
    data.prettyPrintedJSONString()
    
    let decoder = JSONDecoder()
    let searchResponse = try decoder.decode(SearchResponse.self, from: data)
    
    return searchResponse.results
}

let query = [
    "term": "J.Cole love yourz",
    "media": "music",
]

Task {
    do {
        let storeItems = try await fetchItems(matching: query)
        storeItems.forEach { item in
            print("""
            trackName: \(item.trackName)
            artistName: \(item.artistName)
            Kind: \(item.kind)
            Description: \(item.description)
            Arwork URL: \(item.artworkURL)

            """)
        }
    } catch {
        print(error)
    }
}

