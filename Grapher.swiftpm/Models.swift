import Foundation
import CoreGraphics

struct VerseNode: Identifiable {
    let id: UUID
    let reference: String
    let text: String
    
    // Predetermined coordinated for the mockup
    var position: CGPoint
}

struct VerseEdge: Identifiable {
    let id = UUID()
    let source: UUID
    let target: UUID
    let type: String
}

class MockData {
    static let shared = MockData()
    
    let nodes: [VerseNode]
    let edges: [VerseEdge]
    
    init() {
        let n1 = VerseNode(id: UUID(), reference: "John 1:1", text: "In the beginning was the Word, and the Word was with God, and the Word was God.", position: CGPoint(x: 200, y: 150))
        let n2 = VerseNode(id: UUID(), reference: "Genesis 1:1", text: "In the beginning God created the heavens and the earth.", position: CGPoint(x: 100, y: 300))
        let n3 = VerseNode(id: UUID(), reference: "John 1:14", text: "And the Word became flesh and dwelt among us...", position: CGPoint(x: 300, y: 250))
        let n4 = VerseNode(id: UUID(), reference: "Isaiah 7:14", text: "Therefore the Lord himself will give you a sign...", position: CGPoint(x: 150, y: 450))
        let n5 = VerseNode(id: UUID(), reference: "Matthew 1:23", text: "Behold, the virgin shall conceive and bear a son...", position: CGPoint(x: 300, y: 450))
        let n6 = VerseNode(id: UUID(), reference: "Psalm 23:1", text: "The Lord is my shepherd; I shall not want.", position: CGPoint(x: 50, y: 100))
        
        self.nodes = [n1, n2, n3, n4, n5, n6]
        
        self.edges = [
            VerseEdge(source: n2.id, target: n1.id, type: "parallel_creation"),
            VerseEdge(source: n1.id, target: n3.id, type: "incarnation"),
            VerseEdge(source: n4.id, target: n5.id, type: "prophecy_fulfillment"),
            VerseEdge(source: n3.id, target: n5.id, type: "cross_reference")
            // n6 is unconnected for variety
        ]
    }
}
