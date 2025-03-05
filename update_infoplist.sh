#!/bin/bash

# Path to the project.pbxproj file
PROJECT_FILE="/Users/phyo/Documents/iOS-Projects/CryptoSize/CryptoSize.xcodeproj/project.pbxproj"

# Backup the original file
cp "$PROJECT_FILE" "${PROJECT_FILE}.bak"

# Find the macOS target build configuration section and add INFOPLIST_FILE
sed -i '' 's/CODE_SIGN_ENTITLEMENTS = "CryptoSize-macOS\/CryptoSize_macOS.entitlements";/CODE_SIGN_ENTITLEMENTS = "CryptoSize-macOS\/CryptoSize_macOS.entitlements";\n\t\t\t\tINFOPLIST_FILE = "CryptoSize-macOS\/Info.plist";/' "$PROJECT_FILE"

echo "Project file updated. Original backed up to ${PROJECT_FILE}.bak"
