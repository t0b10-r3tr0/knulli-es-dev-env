#!/bin/bash
source ../settings.conf

PWD=$(pwd)
rm -rf "$BASE_DIR"/"$LOCAL_DISTRIBUTION_DIR_NAME"/dl/batocera-emulationstation/
rm -rf "$BASE_DIR"/"$LOCAL_DISTRIBUTION_DIR_NAME"/output/"$TARGET"/build/batocera-emulationstation-"$FEATURE_BRANCH_NAME"_"$TEST_BRANCH_SUFFIX"
cd "$BASE_DIR"/"$LOCAL_DISTRIBUTION_DIR_NAME"
make "$TARGET"-pkg PKG=batocera-emulationstation
cd $PWD
echo
echo "Build complete. 🔥"
echo
