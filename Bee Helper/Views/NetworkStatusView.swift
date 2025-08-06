import SwiftUI

struct NetworkStatusView: View {
    @EnvironmentObject var puzzleService: PuzzleService
    @State private var isConnected = false
    @State private var lastCheck = Date()
    
    var body: some View {
        HStack {
            Image(systemName: isConnected ? "wifi" : "wifi.slash")
                .foregroundColor(isConnected ? .green : .red)
            
            Text(isConnected ? "Connected" : "Disconnected")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text("Last check: \(getTimeAgo())")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.horizontal, 20)
        .onAppear {
            checkConnection()
        }
    }
    
    private func checkConnection() {
        Task {
            do {
                let url = URL(string: "http://localhost:5001/api/spelling-bee/test")!
                let (_, response) = try await URLSession.shared.data(from: url)
                
                if let httpResponse = response as? HTTPURLResponse {
                    isConnected = httpResponse.statusCode == 200
                } else {
                    isConnected = false
                }
                
                lastCheck = Date()
            } catch {
                isConnected = false
                lastCheck = Date()
            }
        }
    }
    
    private func getTimeAgo() -> String {
        let interval = Date().timeIntervalSince(lastCheck)
        if interval < 60 {
            return "Just now"
        } else if interval < 3600 {
            let minutes = Int(interval / 60)
            return "\(minutes)m ago"
        } else {
            let hours = Int(interval / 3600)
            return "\(hours)h ago"
        }
    }
} 