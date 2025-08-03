import SwiftUI

struct SettingsView: View {
    @AppStorage("autoFetchPuzzle") private var autoFetchPuzzle = true
    @AppStorage("showPangramsFirst") private var showPangramsFirst = true
    @AppStorage("defaultPrefixLength") private var defaultPrefixLength = 2
    
    var body: some View {
        NavigationView {
            List {
                Section("Puzzle Settings") {
                    Toggle("Auto-fetch today's puzzle", isOn: $autoFetchPuzzle)
                    
                    Toggle("Show pangrams first in word list", isOn: $showPangramsFirst)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Default prefix length")
                            .font(.subheadline)
                        
                        HStack {
                            Text("2")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Slider(value: Binding(
                                get: { Double(defaultPrefixLength) },
                                set: { defaultPrefixLength = Int($0) }
                            ), in: 2...6, step: 1)
                            .accentColor(.blue)
                            
                            Text("6")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Text("Current: \(defaultPrefixLength)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 5)
                }
                
                Section("Data Sources") {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Primary Source")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Text("NYT Spelling Bee")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Fallback Source")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Text("SBSolver.com")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.orange)
                    }
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Build")
                        Spacer()
                        Text("1")
                            .foregroundColor(.secondary)
                    }
                    
                    Button("Privacy Policy") {
                        // Open privacy policy
                    }
                    .foregroundColor(.blue)
                    
                    Button("Terms of Service") {
                        // Open terms of service
                    }
                    .foregroundColor(.blue)
                }
                
                Section("Support") {
                    Button("Report a Bug") {
                        // Open bug report form
                    }
                    .foregroundColor(.blue)
                    
                    Button("Feature Request") {
                        // Open feature request form
                    }
                    .foregroundColor(.blue)
                    
                    Button("Rate the App") {
                        // Open App Store rating
                    }
                    .foregroundColor(.blue)
                }
                
                Section("Data") {
                    Button("Clear Cache") {
                        // Clear cached puzzle data
                    }
                    .foregroundColor(.red)
                    
                    Button("Export Puzzle Data") {
                        // Export puzzle data
                    }
                    .foregroundColor(.blue)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    SettingsView()
} 