#!/bin/bash

# Add new files to Xcode project
echo "Adding DictionaryService.swift to Xcode project..."
xcodebuild -project "Bee Helper.xcodeproj" -target "Bee Helper" -add-file "Bee Helper/Services/DictionaryService.swift"

echo "Adding NetworkStatusView.swift to Xcode project..."
xcodebuild -project "Bee Helper.xcodeproj" -target "Bee Helper" -add-file "Bee Helper/Views/NetworkStatusView.swift"

echo "Files added to Xcode project!" 