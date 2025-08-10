import SwiftUI

struct SettingsView: View {
    @AppStorage("showHints") private var showHints = false
    @EnvironmentObject var puzzleService: PuzzleService

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // App Mode
                    SettingsSection(title: "App Mode") {
                        HStack {
                            Image(systemName: "wifi.slash")
                                .foregroundColor(.orange)
                                .font(.title2)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Offline Mode")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text("Manual input only - no internet required")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Text("Active")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.orange)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(6)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                    
                    // App Settings
                    SettingsSection(title: "App Settings") {
                        SettingsRow(
                            title: "Show Hints",
                            subtitle: "Display helpful hints and tips",
                            isOn: $showHints
                        )
                    }
                    
                    // Dictionary Information
                    SettingsSection(title: "Dictionary Information") {
                        SettingsRow(
                            title: "Dictionary Size",
                            subtitle: "10,577 words loaded",
                            showToggle: false
                        )
                        
                        SettingsRow(
                            title: "Source",
                            subtitle: "Comprehensive word list",
                            showToggle: false
                        )
                        
                        SettingsRow(
                            title: "Status",
                            subtitle: "Ready for manual input",
                            showToggle: false
                        )
                    }
                    
                    // Coming Soon Features
                    SettingsSection(title: "Coming Soon") {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "clock.badge.questionmark")
                                    .foregroundColor(.blue)
                                Text("Auto-fetch Today's Puzzle")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            
                            HStack {
                                Image(systemName: "archivebox")
                                    .foregroundColor(.blue)
                                Text("Puzzle Archive")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            
                            HStack {
                                Image(systemName: "chart.bar")
                                    .foregroundColor(.blue)
                                Text("Statistics & Analytics")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                    
                    // App Information
                    SettingsSection(title: "App Information") {
                        SettingsRow(
                            title: "Version",
                            subtitle: "1.0.0",
                            showToggle: false
                        )
                        
                        SettingsRow(
                            title: "Developer",
                            subtitle: "Bee Helper Team",
                            showToggle: false
                        )
                        
                        SettingsRow(
                            title: "Support",
                            subtitle: "Contact us for help",
                            showToggle: false
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(spacing: 0) {
                content
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
}

struct SettingsRow: View {
    let title: String
    let subtitle: String
    @State private var isOn: Bool = false
    let showToggle: Bool
    private let binding: Binding<Bool>?
    
    init(title: String, subtitle: String, isOn: Binding<Bool>? = nil, showToggle: Bool = true) {
        self.title = title
        self.subtitle = subtitle
        self.showToggle = showToggle
        self.binding = isOn
    }
    
    private var effectiveBinding: Binding<Bool> {
        if let binding = binding {
            return binding
        } else {
            return $isOn
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if showToggle {
                Toggle("", isOn: effectiveBinding)
                    .labelsHidden()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    SettingsView()
        .environmentObject(PuzzleService())
}
