#!/bin/bash

# ViralCaption AI - Build Script
# Builds release APKs for Android

set -e

echo "🎬 ViralCaption AI - Build Script"
echo "=================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check prerequisites
check_prereqs() {
    if ! command -v flutter &> /dev/null; then
        echo -e "${RED}Error: Flutter not found${NC}"
        exit 1
    fi
    
    if ! command -v java &> /dev/null; then
        echo -e "${RED}Error: Java not found${NC}"
        exit 1
    fi
}

# Clean build
clean() {
    echo -e "${YELLOW}Cleaning build...${NC}"
    flutter clean
    rm -rf build/
}

# Get dependencies
deps() {
    echo -e "${YELLOW}Getting dependencies...${NC}"
    flutter pub get
}

# Run tests
test() {
    echo -e "${YELLOW}Running tests...${NC}"
    flutter test
}

# Analyze code
analyze() {
    echo -e "${YELLOW}Analyzing code...${NC}"
    flutter analyze
}

# Build debug APK
build_debug() {
    echo -e "${YELLOW}Building debug APK...${NC}"
    flutter build apk --debug
    echo -e "${GREEN}✓ Debug APK ready: build/app/outputs/flutter-apk/app-debug.apk${NC}"
}

# Build release APK (universal)
build_release() {
    echo -e "${YELLOW}Building release APK (universal)...${NC}"
    flutter build apk --release
    echo -e "${GREEN}✓ Release APK ready: build/app/outputs/flutter-apk/app-release.apk${NC}"
}

# Build release APKs split by ABI
build_split_abi() {
    echo -e "${YELLOW}Building release APKs (split by ABI)...${NC}"
    flutter build apk --release --split-per-abi
    
    echo -e "${GREEN}✓ APKs ready:${NC}"
    echo "  - build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk (32-bit ARM)"
    echo "  - build/app/outputs/flutter-apk/app-arm64-v8a-release.apk (64-bit ARM)"
    echo "  - build/app/outputs/flutter-apk/app-x86_64-release.apk (64-bit x86)"
}

# Build App Bundle (for AppGallery)
build_appbundle() {
    echo -e "${YELLOW}Building App Bundle...${NC}"
    flutter build appbundle --release
    echo -e "${GREEN}✓ AAB ready: build/app/outputs/bundle/release/app-release.aab${NC}"
}

# Build all
build_all() {
    clean
    deps
    analyze
    build_split_abi
    build_appbundle
    
    echo ""
    echo -e "${GREEN}=================================="
    echo "✓ Build complete!"
    echo "==================================${NC}"
}

# Show help
help() {
    echo "Usage: ./build.sh [command]"
    echo ""
    echo "Commands:"
    echo "  clean       Clean build artifacts"
    echo "  deps        Get dependencies"
    echo "  test        Run tests"
    echo "  analyze     Analyze code"
    echo "  debug       Build debug APK"
    echo "  release     Build release APK (universal)"
    echo "  split       Build release APKs (split by ABI)"
    echo "  appbundle   Build App Bundle (AppGallery)"
    echo "  all         Clean + deps + analyze + build all"
    echo "  help        Show this help"
}

# Main
case "${1:-help}" in
    clean)
        clean
        ;;
    deps)
        deps
        ;;
    test)
        test
        ;;
    analyze)
        analyze
        ;;
    debug)
        check_prereqs
        deps
        build_debug
        ;;
    release)
        check_prereqs
        deps
        build_release
        ;;
    split)
        check_prereqs
        deps
        build_split_abi
        ;;
    appbundle)
        check_prereqs
        deps
        build_appbundle
        ;;
    all)
        check_prereqs
        build_all
        ;;
    help|*)
        help
        ;;
esac
