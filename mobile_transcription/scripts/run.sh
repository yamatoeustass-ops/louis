#!/bin/bash

# ViralCaption AI - Run Script
# Runs the app on connected device/emulator

set -e

echo "🎬 ViralCaption AI - Run Script"
echo "================================"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check prerequisites
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}Error: Flutter not found${NC}"
    exit 1
fi

# Get dependencies
echo -e "${YELLOW}Getting dependencies...${NC}"
flutter pub get

# Check for connected devices
echo -e "${YELLOW}Checking for devices...${NC}"
DEVICE=$(flutter devices | grep -E "•" | head -1 | awk -F'• ' '{print $2}' | awk -F' ' '{print $1}')

if [ -z "$DEVICE" ]; then
    echo -e "${RED}No device found. Please connect a device or start an emulator.${NC}"
    flutter devices
    exit 1
fi

echo -e "${GREEN}Found device: $DEVICE${NC}"

# Run based on mode
MODE="${2:-debug}"

case "$MODE" in
    debug)
        echo -e "${YELLOW}Running in DEBUG mode...${NC}"
        flutter run --device-id "$DEVICE"
        ;;
    profile)
        echo -e "${YELLOW}Running in PROFILE mode...${NC}"
        flutter run --profile --device-id "$DEVICE"
        ;;
    release)
        echo -e "${YELLOW}Running in RELEASE mode...${NC}"
        flutter run --release --device-id "$DEVICE"
        ;;
    *)
        echo "Usage: ./run.sh [device] [debug|profile|release]"
        exit 1
        ;;
esac

echo -e "${GREEN}✓ App running on $DEVICE${NC}"
