#!/bin/bash
source "../settings.conf"

PWD=$(pwd)
echo "Beginning Deployment. 🤞"
ssh $DEVICE_LOGIN "mkdir -p ~/backup && cp /usr/bin/emulationstation ~/backup/emulationstation.lastversion && /etc/init.d/S31emulationstation stop"
scp "$BASE_DIR"/"$LOCAL_DISTRIBUTION_DIR_NAME"/output/"$TARGET"/build/batocera-emulationstation-"$FEATURE_BRANCH_NAME"_"$TEST_BRANCH_SUFFIX"/emulationstation $DEVICE_LOGIN:~/backup/emulationstation.newversion
ssh "$DEVICE_LOGIN" "cp ~/backup/emulationstation.newversion /usr/bin/emulationstation && batocera-save-overlay && reboot && exit"
cd "$PWD"
echo
echo "Deployment complete. 🔥"
echo