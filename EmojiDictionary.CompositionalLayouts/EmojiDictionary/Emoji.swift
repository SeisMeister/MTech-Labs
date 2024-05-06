import Foundation

struct Emoji: Codable, Identifiable, Equatable {
    var symbol: String
    var name: String
    var description: String
    var usage: String
    
    var id: String {
        symbol
    }

    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    var sectionTitle: String {
        String(name.uppercased().first ?? "?")
    }
}
