import SwiftUI

struct ContentView: View {
    @State private var nodes: [VerseNode] = MockData.shared.nodes
    @State private var edges: [VerseEdge] = MockData.shared.edges
    @State private var selectedVerseText: String = "Tap a verse to see its text here."
    @State private var isLoading = false
    @State private var usedReferences: Set<String> = Set(MockData.shared.nodes.map { $0.reference })

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
                    ForEach(edges) { edge in
                        if let sourceNode = nodes.first(where: { $0.id == edge.source }),
                           let targetNode = nodes.first(where: { $0.id == edge.target }) {
                            Path { path in
                                path.move(to: sourceNode.position)
                                path.addLine(to: targetNode.position)
                            }
                            .stroke(Color.gray.opacity(0.5), lineWidth: 2)

                            let midPoint = CGPoint(
                                x: (sourceNode.position.x + targetNode.position.x) / 2,
                                y: (sourceNode.position.y + targetNode.position.y) / 2
                            )
                            Text(edge.type.replacingOccurrences(of: "_", with: " ").capitalized)
                                .font(.system(size: 10))
                                .foregroundColor(.black)
                                .padding(2)
                                .background(Color.yellow.opacity(0.85))
                                .cornerRadius(4)
                                .position(midPoint)
                        }
                    }

                    // Draw Nodes
                    ForEach(nodes) { node in
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
                                .foregroundColor(.black)
                                .padding(4)
                                .background(Color(red: 0.9, green: 0.95, blue: 1.0))
                                .cornerRadius(6)
                                .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
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
                .background(Color(red: 0.95, green: 0.95, blue: 0.97))
                .cornerRadius(12)
                .padding()
                .overlay(alignment: .bottomTrailing) {
                    Button {
                        Task { await fetchRandomVerse(in: geometry.size) }
                    } label: {
                        HStack(spacing: 6) {
                            if isLoading {
                                ProgressView()
                                    .controlSize(.small)
                            } else {
                                Image(systemName: "plus.circle.fill")
                            }
                            Text("Random Verse")
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                    }
                    .disabled(isLoading)
                    .padding(28)
                }
            }
        }
    }

    private func fetchRandomVerse(in size: CGSize) async {
        // Pick a reference we haven't used yet
        let available = randomVersePool.filter { !usedReferences.contains($0) }
        guard let reference = available.randomElement() else {
            selectedVerseText = "All verses from the pool have been added!"
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await BibleAPIClient.shared.fetchVerse(reference)
            let padding: CGFloat = 60
            let graphWidth = max(size.width - padding * 2, 200)
            let graphHeight = max(size.height - padding * 2, 200)
            let position = CGPoint(
                x: padding + CGFloat.random(in: 0...graphWidth),
                y: padding + CGFloat.random(in: 0...graphHeight)
            )
            let trimmedText = response.text.trimmingCharacters(in: .whitespacesAndNewlines)
            let newNode = VerseNode(
                id: UUID(),
                reference: response.reference,
                text: trimmedText,
                position: position
            )

            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                nodes.append(newNode)
                usedReferences.insert(response.reference)
            }
            selectedVerseText = "\(response.reference): \(trimmedText)"
        } catch {
            selectedVerseText = "Error: \(error.localizedDescription)"
        }
    }
}
