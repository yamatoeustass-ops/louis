#!/bin/bash

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo ""
echo "========================================"
echo "  ViralCaption AI - Build & Install"
echo "========================================"
echo ""

# Step 1
echo -e "${YELLOW}[1/4] Getting dependencies...${NC}"
flutter pub get
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Failed to get dependencies!${NC}"
    echo "Make sure Flutter is installed and in PATH."
    exit 1
fi

# Step 2
echo -e "${YELLOW}[2/4] Building release APK...${NC}"
flutter build apk --release
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Build failed!${NC}"
    echo "Run 'flutter doctor' to check your setup."
    exit 1
fi

# Step 3
echo -e "${YELLOW}[3/4] Copying APK to web folder...${NC}"
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    cp "build/app/outputs/flutter-apk/app-release.apk" "web/app-release.apk"
    echo -e "${GREEN}SUCCESS: APK copied to web folder!${NC}"
else
    echo -e "${RED}ERROR: APK not found!${NC}"
    exit 1
fi

# Step 4
echo -e "${YELLOW}[4/4] Opening download page...${NC}"
if [[ "$OSTYPE" == "darwin"* ]]; then
    open "web/download.html"
else
    xdg-open "web/download.html"
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  BUILD COMPLETE!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Next steps:"
echo "1. Click the 'Download APK' button on the webpage"
echo "2. Transfer the APK to your Huawei phone"
echo "3. Install and enjoy!"
echo ""
echo "APK location: $(pwd)/build/app/outputs/flutter-apk/app-release.apk"
echo ""
