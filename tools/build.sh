#!/bin/bash
source ../settings.conf

cd $BASE_DIR/$LOCAL_EMULATIONSTATION_DIR_NAME
CURRENT_EMULATIONSTATION_BRANCH="$(git branch --show-current)"

echo "Setting emulationstation to current development branch $CURRENT_EMULATIONSTATION_BRANCH."

sed -i "s|^KNULLI_EMULATIONSTATION_SITE = .*|KNULLI_EMULATIONSTATION_SITE = $EMULATIONSTATION_FORK_REPO|" $BASE_DIR/$LOCAL_DISTRIBUTION_DIR_NAME/package/emulationstation/knulli-emulationstation/knulli-emulationstation.mk
sed -i "s|^KNULLI_EMULATIONSTATION_VERSION = .*|KNULLI_EMULATIONSTATION_VERSION = $CURRENT_EMULATIONSTATION_BRANCH|" $BASE_DIR/$LOCAL_DISTRIBUTION_DIR_NAME/package/emulationstation/knulli-emulationstation/knulli-emulationstation.mk

PWD=$(pwd)
rm -rf "$BASE_DIR"/"$LOCAL_DISTRIBUTION_DIR_NAME"/dl/knulli-emulationstation/
rm -rf "$BASE_DIR"/"$LOCAL_DISTRIBUTION_DIR_NAME"/output/"$TARGET"/build/knulli-emulationstation-"$CURRENT_EMULATIONSTATION_BRANCH"
cd "$BASE_DIR"/"$LOCAL_DISTRIBUTION_DIR_NAME"
make "$TARGET"-pkg PKG=knulli-emulationstation
cd $PWD
echo
echo "Build complete. 🔥"
echo
