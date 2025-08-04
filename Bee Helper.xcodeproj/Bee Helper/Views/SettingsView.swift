import SwiftUI

struct SettingsView: View {
    @AppStorage("autoFetchPuzzle") private var autoFetchPuzzle = true
    @AppStorage("showHints") private var showHints = false
    @AppStorage("dataSource") private var dataSource = "SBSolver"
    private let dataSources = ["SBSolver", "NYT", "Manual Only"]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // App Settings
                    SettingsSection(title: "App Settings") {
                        SettingsRow(
                            title: "Auto-fetch Puzzle",
                            subtitle: "Automatically load today's puzzle on app launch",
                            isOn: $autoFetchPuzzle
                        )
                        
                        SettingsRow(
                            title: "Show Hints",
                            subtitle: "Display helpful hints and tips",
                            isOn: $showHints
                        )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Data Source")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text("Choose where to fetch puzzle data from")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Picker("Data Source", selection: $dataSource) {
                                ForEach(dataSources, id: \.self) { source in
                                    Text(source).tag(source)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        .padding(.vertical, 8)
                    }
                    
                    // Data Source Information
                    DataSourceInfoCard()
                    
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
    @State var isOn: Bool = false
    let showToggle: Bool
    
    init(title: String, subtitle: String, isOn: Binding<Bool>? = nil, showToggle: Bool = true) {
        self.title = title
        self.subtitle = subtitle
        self.showToggle = showToggle
        if let isOn = isOn {
            self._isOn = isOn
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
                Toggle("", isOn: $isOn)
                    .labelsHidden()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

struct DataSourceInfoCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                Text("Data Sources")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                DataSourceItem(
                    name: "SBSolver",
                    description: "Community-driven puzzle data",
                    status: "Primary"
                )
                
                DataSourceItem(
                    name: "NYT",
                    description: "New York Times official data",
                    status: "Fallback"
                )
                
                DataSourceItem(
                    name: "Manual Only",
                    description: "User-entered letters only",
                    status: "Custom"
                )
            }
        }
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct DataSourceItem: View {
    let name: String
    let description: String
    let status: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(status)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(6)
        }
    }
} 