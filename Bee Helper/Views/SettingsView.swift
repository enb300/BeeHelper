import SwiftUI

struct SettingsView: View {
    @AppStorage("autoFetchPuzzle") private var autoFetchPuzzle = true
    @AppStorage("showHints") private var showHints = false
    @AppStorage("dataSource") private var dataSource = "SBSolver"
    
    private let dataSources = ["SBSolver", "NYT", "Manual Only"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "gear")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                        
                        Text("Settings")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text("Customize your Bee Helper experience")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal)
                    
                    // Puzzle Settings
                    SettingsSection(title: "Puzzle Settings") {
                        SettingsRow(
                            icon: "arrow.clockwise",
                            title: "Auto-fetch Today's Puzzle",
                            subtitle: "Automatically load the latest puzzle when app opens",
                            isToggle: true,
                            toggleValue: $autoFetchPuzzle
                        )
                        
                        SettingsRow(
                            icon: "lightbulb",
                            title: "Show Hints",
                            subtitle: "Display helpful hints and suggestions",
                            isToggle: true,
                            toggleValue: $showHints
                        )
                        
                        SettingsRow(
                            icon: "network",
                            title: "Data Source",
                            subtitle: "Choose where to fetch puzzle data from",
                            isPicker: true,
                            pickerValue: $dataSource,
                            pickerOptions: dataSources
                        )
                    }
                    
                    // App Information
                    SettingsSection(title: "App Information") {
                        SettingsRow(
                            icon: "info.circle",
                            title: "Version",
                            subtitle: "1.0.0",
                            isInfo: true
                        )
                        
                        SettingsRow(
                            icon: "doc.text",
                            title: "Privacy Policy",
                            subtitle: "How we handle your data",
                            isLink: true
                        )
                        
                        SettingsRow(
                            icon: "questionmark.circle",
                            title: "Help & Support",
                            subtitle: "Get help with the app",
                            isLink: true
                        )
                    }
                    
                    // Data Sources Info
                    SettingsSection(title: "Data Sources") {
                        DataSourceInfoCard(
                            name: "SBSolver.com",
                            description: "Community-maintained Spelling Bee archive with reliable data",
                            url: "https://www.sbsolver.com",
                            isPrimary: dataSource == "SBSolver"
                        )
                        
                        DataSourceInfoCard(
                            name: "NYT Spelling Bee",
                            description: "Official New York Times puzzle page",
                            url: "https://www.nytimes.com/puzzles/spelling-bee",
                            isPrimary: dataSource == "NYT"
                        )
                        
                        DataSourceInfoCard(
                            name: "Manual Entry",
                            description: "Enter puzzle letters manually for offline use",
                            url: nil,
                            isPrimary: dataSource == "Manual Only"
                        )
                    }
                    
                    // About
                    VStack(spacing: 16) {
                        Text("About Bee Helper")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text("Bee Helper is designed to enhance your NYT Spelling Bee experience. It provides statistics, word analysis, and helpful tools to improve your puzzle-solving skills.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(20)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
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
        VStack(spacing: 16) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 0) {
                content
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .padding(.horizontal)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let isToggle: Bool
    let isPicker: Bool
    let isInfo: Bool
    let isLink: Bool
    let toggleValue: Binding<Bool>?
    let pickerValue: Binding<String>?
    let pickerOptions: [String]?
    
    init(
        icon: String,
        title: String,
        subtitle: String,
        isToggle: Bool = false,
        isPicker: Bool = false,
        isInfo: Bool = false,
        isLink: Bool = false,
        toggleValue: Binding<Bool>? = nil,
        pickerValue: Binding<String>? = nil,
        pickerOptions: [String]? = nil
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.isToggle = isToggle
        self.isPicker = isPicker
        self.isInfo = isInfo
        self.isLink = isLink
        self.toggleValue = toggleValue
        self.pickerValue = pickerValue
        self.pickerOptions = pickerOptions
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isToggle, let toggleValue = toggleValue {
                Toggle("", isOn: toggleValue)
                    .labelsHidden()
            } else if isPicker, let pickerValue = pickerValue, let pickerOptions = pickerOptions {
                Picker("", selection: pickerValue) {
                    ForEach(pickerOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.menu)
                .labelsHidden()
            } else if isInfo || isLink {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

struct DataSourceInfoCard: View {
    let name: String
    let description: String
    let url: String?
    let isPrimary: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if isPrimary {
                    Text("Primary")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
            
            if let url = url {
                Link(destination: URL(string: url) ?? URL(string: "https://example.com")!) {
                    Text("Visit Website")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    SettingsView()
} 