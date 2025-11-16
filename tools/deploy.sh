#!/bin/bash
source "../settings.conf"

cd $BASE_DIR/$LOCAL_EMULATIONSTATION_DIR_NAME
CURRENT_EMULATIONSTATION_BRANCH="$(git branch --show-current)"

PWD=$(pwd)
echo "Beginning Deployment. 🤞"
ssh $DEVICE_LOGIN "mkdir -p ~/backup && cp /usr/bin/emulationstation ~/backup/emulationstation.lastversion && /etc/init.d/S31emulationstation stop"
scp "$BASE_DIR"/"$LOCAL_DISTRIBUTION_DIR_NAME"/output/"$TARGET"/build/knulli-emulationstation-"$CURRENT_EMULATIONSTATION_BRANCH"/emulationstation $DEVICE_LOGIN:~/backup/emulationstation.newversion
ssh "$DEVICE_LOGIN" "cp ~/backup/emulationstation.newversion /usr/bin/emulationstation && batocera-save-overlay ; knulli-save-overlay ; reboot && exit"
cd "$PWD"
echo
echo "Deployment complete. 🔥"
echo