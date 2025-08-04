# 🐝 Bee Helper - NYT Spelling Bee Assistant

A beautiful iOS app designed to enhance your NYT Spelling Bee puzzle-solving experience with comprehensive statistics, word analysis, and community data integration.

## ✨ Features

### 🎯 Core Functionality
- **Daily Puzzle Import**: Automatically fetch today's puzzle from community sources
- **Manual Letter Entry**: Enter puzzle letters manually when automatic fetching fails
- **Comprehensive Statistics**: Total words, pangrams, compound words, and detailed analytics
- **Word Analysis**: Dynamic prefix tables with adjustable length (2-6 letters)
- **Archive Support**: Browse past puzzles by date with quick selection options
- **Answer Reveal**: View complete word lists categorized by type

### 🎨 Design Excellence
- **Apple Design Guidelines**: Follows iOS Human Interface Guidelines
- **Modern UI**: Clean, minimal interface with thoughtful typography
- **Accessibility**: Proper contrast ratios and semantic colors
- **Responsive Layout**: Adapts to different screen sizes and orientations
- **Visual Hierarchy**: Clear information architecture with proper spacing

### 📊 Data Sources
- **Primary**: SBSolver.com community archive (most reliable)
- **Fallback**: NYT Spelling Bee official page
- **Manual**: Offline entry for complete control
- **Settings**: User-configurable data source preferences

## 🏗️ Architecture

### File Structure
```
Bee Helper/
├── Models/
│   └── PuzzleData.swift          # Core data model
├── Services/
│   └── PuzzleService.swift       # Data fetching and management
├── Views/
│   ├── ContentView.swift         # Main tab navigation
│   ├── TodayView.swift           # Today's puzzle interface
│   ├── ArchiveView.swift         # Historical puzzle browser
│   ├── SettingsView.swift        # App configuration
│   ├── ManualInputView.swift     # Manual letter entry
│   ├── AllWordsView.swift        # Complete word lists
│   ├── WordCountTableView.swift  # Letter-based statistics
│   └── PrefixTableView.swift     # Dynamic prefix analysis
└── Info.plist                   # App configuration
```

### Key Components

#### PuzzleData Model
- **Letters & Center Letter**: String-based for better compatibility
- **Word Lists**: Pangrams, compound words, and complete word set
- **Statistics**: Computed properties for real-time analytics
- **Prefix Analysis**: Dynamic word counting by prefix length

#### PuzzleService
- **Async/Await**: Modern concurrency for network requests
- **Error Handling**: Graceful fallbacks and user feedback
- **Data Sources**: Multiple fetch strategies with priority ordering
- **State Management**: ObservableObject with @Published properties

#### UI Components
- **LetterDisplayView**: Visual letter representation with center highlighting
- **StatsView**: Card-based statistics with color coding
- **WordCountTableView**: Grid layout for letter-based counts
- **PrefixTableView**: Interactive slider for prefix length adjustment

## 🎯 Apple Design Best Practices

### Typography
- **Large Title**: Main headers with bold weight
- **Title2**: Section headers with semibold weight
- **Headline**: Button text and important labels
- **Subheadline**: Secondary information
- **Caption**: Metadata and small text

### Colors
- **Primary**: System colors for text and icons
- **Secondary**: Subtle text and descriptions
- **Accent**: Blue for interactive elements
- **Semantic**: Green (success), Orange (warning), Yellow (center letter)

### Spacing
- **24pt**: Major section spacing
- **16pt**: Component spacing
- **12pt**: Element spacing
- **8pt**: Tight spacing

### Visual Elements
- **Corner Radius**: 12pt for cards, 16pt for sections
- **Shadows**: Subtle depth with 5% opacity
- **Icons**: SF Symbols with consistent sizing
- **Buttons**: Full-width with proper padding

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 17.0+
- macOS 14.0+

### Installation
1. Clone or download the project
2. Open `Bee Helper.xcodeproj` in Xcode
3. Select your development team in project settings
4. Build and run on simulator or device

### Configuration
- **Network Access**: App requires internet for puzzle fetching
- **Data Sources**: Configure preferred sources in Settings
- **Auto-fetch**: Enable/disable automatic puzzle loading

## 🔧 Technical Details

### Network Configuration
```swift
// Info.plist includes NSAllowsArbitraryLoads for HTTP access
// SBSolver.com and NYT.com are primary data sources
```

### Data Flow
1. **App Launch**: Auto-fetch today's puzzle if enabled
2. **Manual Input**: User enters letters when automatic fails
3. **Archive Browse**: Fetch historical puzzles by date
4. **Statistics**: Real-time computation of word analytics

### Error Handling
- **Network Failures**: Graceful fallback to sample data
- **Invalid Input**: User-friendly error messages
- **Missing Data**: Clear loading and empty states

## 📱 User Experience

### Today's Puzzle
- **Letter Display**: Visual representation with center highlighting
- **Statistics Cards**: Color-coded metrics with icons
- **Word Count Grid**: Letter-based statistics in card layout
- **Prefix Analysis**: Interactive slider for dynamic analysis
- **Action Buttons**: Clear call-to-action for manual input and word reveal

### Archive Browser
- **Date Picker**: Native iOS date selection
- **Quick Select**: Yesterday, last week shortcuts
- **Loading States**: Progress indicators during data fetch
- **Empty States**: Helpful messaging when no data available

### Settings
- **Organized Sections**: Logical grouping of preferences
- **Data Source Info**: Clear descriptions of available sources
- **App Information**: Version, privacy, and support links

## 🔮 Future Enhancements

### Planned Features
- **Offline Mode**: Local puzzle storage and caching
- **Hints System**: Smart suggestions based on letter patterns
- **Achievements**: Progress tracking and milestones
- **Social Features**: Share scores and compare with friends
- **Dark Mode**: Complete dark theme support

### Technical Improvements
- **Real HTML Parsing**: Robust web scraping for data sources
- **Local Database**: Core Data for puzzle history
- **Push Notifications**: Daily puzzle reminders
- **Widgets**: iOS home screen integration

## 🤝 Contributing

This app demonstrates modern iOS development practices:
- **SwiftUI**: Declarative UI framework
- **Async/Await**: Modern concurrency patterns
- **MVVM**: Clean architecture with ObservableObject
- **Apple Guidelines**: Human Interface Design compliance

## 📄 License

This project is for educational and personal use. Please respect the terms of service for data sources (SBSolver.com, NYT.com).

---

**Bee Helper** - Making the NYT Spelling Bee more enjoyable, one puzzle at a time! 🐝✨ 