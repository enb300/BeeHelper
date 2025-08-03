# Bee Helper - NYT Spelling Bee Assistant

A comprehensive iOS app designed to help users solve the New York Times Spelling Bee puzzle. The app provides tools to analyze puzzle statistics, explore word patterns, and access archived puzzles.

## 🧩 Features

### Core Functionality
- **Daily Puzzle Import**: Automatically fetches today's 7 letters from NYT Spelling Bee
- **Manual Input**: Fallback option to manually enter letters when automatic import fails
- **Real-time Statistics**: Shows total words, pangrams, and compound words
- **Word Analysis**: Displays word counts by starting letter and prefix patterns
- **Archive System**: Browse past puzzles by date with quick access buttons

### Key Components

#### 📊 Statistics Dashboard
- Total word count for the day
- Number of pangrams (words using all 7 letters)
- Number of compound words
- Visual representation with color-coded cards

#### 🔤 Letter Analysis
- **Word Count Table**: Shows how many words start with each of the 7 letters
- **Dynamic Prefix Table**: Adjustable prefix length (2-6 letters) with real-time updates
- **Interactive Slider**: Smooth control over prefix length for detailed analysis

#### 📚 Word Management
- **Reveal All Words**: Complete list of valid words for the day
- **Categorized Display**: Pangrams, compound words, and regular words in separate sections
- **Search and Filter**: Easy navigation through word lists

#### 🗓️ Archive System
- **Date Picker**: Select any past date to view archived puzzles
- **Quick Access**: Yesterday, last week, last month, and random date buttons
- **Historical Data**: View puzzle statistics for any archived date

#### ⚙️ Settings & Configuration
- **Auto-fetch Toggle**: Control automatic puzzle loading
- **Display Preferences**: Customize word list ordering and default prefix length
- **Data Management**: Cache clearing and export options

## 🏗️ Technical Architecture

### Data Models
- `PuzzleData`: Core data structure containing letters, words, and calculated statistics
- `PuzzleService`: Service layer for fetching and managing puzzle data
- Observable objects for real-time UI updates

### Views Structure
```
Bee Helper/
├── Models/
│   └── PuzzleData.swift
├── Services/
│   └── PuzzleService.swift
├── Views/
│   ├── ContentView.swift
│   ├── TodayView.swift
│   ├── ArchiveView.swift
│   ├── SettingsView.swift
│   ├── WordCountTableView.swift
│   ├── PrefixTableView.swift
│   ├── AllWordsView.swift
│   ├── ManualInputView.swift
│   └── RevealWordsButton.swift
└── Bee_HelperApp.swift
```

### Data Sources
1. **Primary**: NYT Spelling Bee website (https://www.nytimes.com/puzzles/spelling-bee)
2. **Fallback**: SBSolver.com for alternative data
3. **Manual**: User input when automatic sources are unavailable

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0 or later
- macOS 14.0 or later (for development)

### Installation
1. Clone or download the project
2. Open `Bee Helper.xcodeproj` in Xcode
3. Select your target device or simulator
4. Build and run the project (⌘+R)

### Configuration
The app includes several configurable settings:
- Auto-fetch puzzle on app launch
- Default prefix length for analysis
- Word list display preferences
- Data source preferences

## 🔧 Development Notes

### Network Security
The app includes `NSAppTransportSecurity` settings to allow HTTP connections for data fetching from external sources.

### Sample Data
For testing purposes, the app includes sample puzzle data that demonstrates all features when external sources are unavailable.

### Future Enhancements
- Enhanced web scraping for more reliable data fetching
- Offline puzzle storage and caching
- Social features for sharing solutions
- Advanced word analysis tools
- Custom puzzle creation

## 📱 User Interface

### Design Principles
- **Clean and Minimal**: Focus on readability and ease of use
- **Color-coded Elements**: Visual distinction between different word types
- **Responsive Layout**: Adapts to different screen sizes and orientations
- **Intuitive Navigation**: Tab-based interface with clear section separation

### Accessibility
- Dynamic Type support for text scaling
- VoiceOver compatibility
- High contrast mode support
- Clear visual hierarchy

## 🤝 Contributing

This project is designed as a personal tool for NYT Spelling Bee enthusiasts. Contributions are welcome for:
- Bug fixes and improvements
- Enhanced data fetching capabilities
- Additional analysis features
- UI/UX improvements

## 📄 License

This project is provided as-is for educational and personal use. Please respect the terms of service of data sources used by the app.

## 🐛 Known Issues

- Manual letter input currently uses placeholder functionality
- Web scraping may be limited by site structure changes
- Archive data availability depends on external sources

## 📞 Support

For issues or feature requests, please check the Settings tab within the app for support options.

---

**Bee Helper** - Making the NYT Spelling Bee more accessible and enjoyable! 🐝 