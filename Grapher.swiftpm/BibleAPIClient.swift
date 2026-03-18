import Foundation

/// Response from bible-api.com
struct BibleAPIResponse: Codable {
    let reference: String
    let text: String
    let translationName: String
    let verses: [BibleAPIVerse]

    enum CodingKeys: String, CodingKey {
        case reference, text, verses
        case translationName = "translation_name"
    }
}

struct BibleAPIVerse: Codable {
    let bookName: String
    let chapter: Int
    let verse: Int
    let text: String

    enum CodingKeys: String, CodingKey {
        case chapter, verse, text
        case bookName = "book_name"
    }
}

/// Lightweight client for bible-api.com (free, no API key required).
/// Uses the World English Bible (WEB) translation by default.
actor BibleAPIClient {
    static let shared = BibleAPIClient()

    private let baseURL = "https://bible-api.com"
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    /// Fetch a single verse or range, e.g. "John 3:16" or "Genesis 1:1-3".
    func fetchVerse(_ reference: String) async throws -> BibleAPIResponse {
        let query = reference.replacingOccurrences(of: " ", with: "+").lowercased()
        guard let url = URL(string: "\(baseURL)/\(query)") else {
            throw BibleAPIError.invalidReference(reference)
        }

        let (data, response) = try await session.data(from: url)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw BibleAPIError.requestFailed(reference)
        }

        return try JSONDecoder().decode(BibleAPIResponse.self, from: data)
    }

    /// Fetch multiple references in parallel.
    func fetchVerses(_ references: [String]) async throws -> [BibleAPIResponse] {
        try await withThrowingTaskGroup(of: BibleAPIResponse.self) { group in
            for ref in references {
                group.addTask { try await self.fetchVerse(ref) }
            }
            var results: [BibleAPIResponse] = []
            for try await result in group {
                results.append(result)
            }
            return results
        }
    }
}

/// Pool of well-known verse references for random fetching.
let randomVersePool: [String] = [
    "John 3:16", "Romans 8:28", "Philippians 4:13", "Jeremiah 29:11",
    "Proverbs 3:5", "Isaiah 41:10", "Romans 12:2", "Galatians 5:22",
    "Hebrews 11:1", "2 Timothy 1:7", "Joshua 1:9", "Psalm 46:1",
    "Matthew 11:28", "1 Corinthians 13:4", "Ephesians 2:8", "Psalm 119:105",
    "Romans 5:8", "John 14:6", "Psalm 37:4", "Isaiah 40:31",
    "Matthew 6:33", "Proverbs 18:10", "Psalm 27:1", "2 Corinthians 5:17",
    "1 Peter 5:7", "Colossians 3:23", "Lamentations 3:22", "Nahum 1:7",
    "Deuteronomy 31:6", "Psalm 139:14", "Romans 15:13", "James 1:2",
    "Micah 6:8", "Habakkuk 2:4", "Zephaniah 3:17", "Malachi 3:10",
    "1 John 4:19", "Revelation 21:4", "Ecclesiastes 3:1", "Job 19:25"
]

enum BibleAPIError: LocalizedError {
    case invalidReference(String)
    case requestFailed(String)

    var errorDescription: String? {
        switch self {
        case .invalidReference(let ref): return "Invalid reference: \(ref)"
        case .requestFailed(let ref): return "Failed to fetch: \(ref)"
        }
    }
}
