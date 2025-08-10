#!/bin/bash

echo "Adding files to Xcode project..."

echo "Adding DictionaryService.swift to Xcode project..."
xcodebuild -project "Bee Helper.xcodeproj" -target "Bee Helper" -add-file "Bee Helper/Services/DictionaryService.swift"

echo "Adding cleaned_scraped_words.txt to Xcode project..."
xcodebuild -project "Bee Helper.xcodeproj" -target "Bee Helper" -add-file "cleaned_scraped_words.txt"

echo "Adding Bee_HelperApp.swift to Xcode project..."
xcodebuild -project "Bee Helper.xcodeproj" -target "Bee Helper" -add-file "Bee Helper/Bee_HelperApp.swift"

echo "Adding ContentView.swift to Xcode project..."
xcodebuild -project "Bee Helper.xcodeproj" -target "Bee Helper" -add-file "Bee Helper/Views/ContentView.swift"

echo "Adding ManualInputView.swift to Xcode project..."
xcodebuild -project "Bee Helper.xcodeproj" -target "Bee Helper" -add-file "Bee Helper/Views/ManualInputView.swift"

echo "Adding TodayView.swift to Xcode project..."
xcodebuild -project "Bee Helper.xcodeproj" -target "Bee Helper" -add-file "Bee Helper/Views/TodayView.swift"

echo "Adding ArchiveView.swift to Xcode project..."
xcodebuild -project "Bee Helper.xcodeproj" -target "Bee Helper" -add-file "Bee Helper/Views/ArchiveView.swift"

echo "Adding SettingsView.swift to Xcode project..."
xcodebuild -project "Bee Helper.xcodeproj" -target "Bee Helper" -add-file "Bee Helper/Views/SettingsView.swift"

echo "All files added successfully!" 