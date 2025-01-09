#!/bin/bash
PWD=$(pwd)
rm -rf ~/source/knulli-distribution/dl/batocera-emulationstation/
rm -rf ~/source/knulli-distribution/output/h700/build/batocera-emulationstation-quick_resume_mode_testing/
cd ~/source/knulli-distribution/
make h700-pkg PKG=batocera-emulationstation
cd $PWD
echo "Build complete."