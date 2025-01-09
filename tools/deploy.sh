#!/bin/bash
PWD=$(pwd)
ssh root@rg35xxsp "mkdir -p ~/backup && cp /usr/bin/emulationstation ~/backup/emulationstation.lastversion && /etc/init.d/S31emulationstation stop"
scp ~/source/knulli-distribution/output/h700/build/batocera-emulationstation-quick_resume_mode_testing/emulationstation root@RG35XXSP:~/backup/emulationstation.newversion
ssh root@RG35XXSP "cp ~/backup/emulationstation.newversion /usr/bin/emulationstation && batocera-save-overlay && reboot"
cd "$PWD"
echo
echo "Deployment complete. 🔥"
echo
