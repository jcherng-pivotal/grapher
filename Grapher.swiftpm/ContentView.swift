import SwiftUI

struct ContentView: View {
    let mockData = MockData.shared
    @State private var selectedVerseText: String = "Tap a verse to see its text here."
    
    var body: some View {
        VStack {
            Text("Bible Verse Topology")
                .font(.title)
                .bold()
                .padding(.top)
            
            Text(selectedVerseText)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
                .frame(minHeight: 80)
            
            GeometryReader { geometry in
                ZStack {
                    // Draw Edges
                    ForEach(mockData.edges) { edge in
                        if let sourceNode = mockData.nodes.first(where: { $0.id == edge.source }),
                           let targetNode = mockData.nodes.first(where: { $0.id == edge.target }) {
                            Path { path in
                                path.move(to: sourceNode.position)
                                path.addLine(to: targetNode.position)
                            }
                            .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                            
                            // Edge Type Label (Centered on line)
                            let midPoint = CGPoint(
                                x: (sourceNode.position.x + targetNode.position.x) / 2,
                                y: (sourceNode.position.y + targetNode.position.y) / 2
                            )
                            Text(edge.type.replacingOccurrences(of: "_", with: " ").capitalized)
                                .font(.system(size: 10))
                                .padding(2)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(4)
                                .position(midPoint)
                        }
                    }
                    
                    // Draw Nodes
                    ForEach(mockData.nodes) { node in
                        VStack(spacing: 4) {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Circle().stroke(Color.white, lineWidth: 2)
                                )
                                .shadow(radius: 2)
                            
                            Text(node.reference)
                                .font(.caption)
                                .bold()
                                .padding(4)
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(6)
                                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                        }
                        .position(node.position)
                        .onTapGesture {
                            withAnimation {
                                selectedVerseText = "\(node.reference): \(node.text)"
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(white: 0.98))
                .cornerRadius(12)
                .padding()
            }
        }
    }
}
