import SwiftUI

struct ArchiveView: View {
    @EnvironmentObject var puzzleService: PuzzleService
    @State private var showingManualInput = false

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Puzzle Archive")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Your saved and custom puzzles")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Quick Actions
                    VStack(spacing: 16) {
                        Text("Quick Actions")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button(action: {
                            showingManualInput = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.blue)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Create New Puzzle")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Text("Enter your own letters")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            // Yesterday's puzzle functionality removed for offline-first approach
                        }) {
                            HStack {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(.gray)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Yesterday's Puzzle")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                    Text("Coming soon")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text("Offline")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                        .disabled(true)
                    }
                    .padding(.horizontal, 20)
                    
                    // Saved Puzzles Section
                    VStack(spacing: 16) {
                        Text("Saved Puzzles")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "tray.fill")
                                    .foregroundColor(.blue)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("No saved puzzles yet")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Text("Create puzzles to see them here")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Coming Soon Features
                    VStack(spacing: 16) {
                        Text("Coming Soon")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 8) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.blue)
                                Text("Daily puzzle history")
                                Spacer()
                                Text("Soon")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                            
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.blue)
                                Text("Favorite puzzles")
                                Spacer()
                                Text("Soon")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                            
                            HStack {
                                Image(systemName: "chart.bar.fill")
                                    .foregroundColor(.blue)
                                Text("Puzzle statistics")
                                Spacer()
                                Text("Soon")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                        .font(.subheadline)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 50)
                }
            }
            .navigationTitle("Archive")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingManualInput) {
                ManualInputView()
                    .environmentObject(puzzleService)
            }
        }
    }
}

#Preview {
    ArchiveView()
        .environmentObject(PuzzleService())
}
