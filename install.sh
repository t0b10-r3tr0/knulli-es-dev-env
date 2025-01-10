#!/bin/bash

source ./settings.conf

# function definitions
apply_git_settings() {
    git config user.name $GIT_USER
    git config user.email $GIT_EMAIL
    git config push.autoSetupRemote true
}

# Dependencies
echo "Now installing dependencies..."
sudo apt update && sudo apt install -y build-essential gettext
mkdir -p $BASE_DIR
cd $BASE_DIR || exit

apply_git_settings


# DISTRIBUTION >>>>>
echo "Now cloning distribution..."
git clone --recursive $DISTRIBUTION_FORK_REPO".git" $LOCAL_DISTRIBUTION_DIR_NAME
cd $BASE_DIR/$LOCAL_DISTRIBUTION_DIR_NAME || exit

apply_git_settings

# set up our base branch
git checkout -b $DISTRO_FORK_BRANCH
touch .initial-setup
# git commit -m "Initial commit."
# git push --set-upstream origin $DISTRO_FORK_BRANCH

# setup our testing branch
git checkout -b "$DISTRO_FORK_TESTING_BRANCH" "origin/$DISTRO_FORK_BRANCH"
# git commit -m "Initial commit."
# git push --set-upstream origin "$DISTRO_FORK_TESTING_BRANCH"


# ES image creation
echo "Now creating Docker build environment..."
./getPoFromWebsite.sh
make build-docker-image || echo "Docker image build failed. ☹️" && exit

# download all sources prior to build
echo "Now downloading all sources..."
make h700-source || echo "Downloading sources failed. ☹️" && exit

# build the ES package with the new container
echo "Now building EmulationStation package..."
make h700-pkg PKG=batocera-emulationstation || echo "Build failed. ☹️" && exit
echo
echo "Build Complete... 🔥"
echo
# DISTRIBUTION <<<<<


# EMULATIONSTATION >>>>>
git clone --recursive $EMULATIONSTATION_FORK_REPO $LOCAL_EMULATIONSTATION_DIR_NAME

# move to base directory and set git credentials
cd $BASE_DIR/$LOCAL_EMULATIONSTATION_DIR_NAME || exit
apply_git_settings
git fetch origin

# set up our base branch
git checkout -b $ES_FORK_GIT_BRANCH
git commit -m "Initial commit."
git push --set-upstream origin $ES_FORK_GIT_BRANCH

# setup our testing branch
git checkout -b "$ES_FORK_GIT_TESTING_BRANCH"
git commit -m "Initial commit."
git push --set-upstream origin "$ES_FORK_GIT_TESTING_BRANCH"

# EMULATIONSTATION <<<<<

# IN PROGRESS
sed -i "s|^BATOCERA_EMULATIONSTATION_SITE = .*|BATOCERA_EMULATIONSTATION_SITE = $EMULATIONSTATION_FORK_REPO|" $BASE_DIR/$LOCAL_DISTRIBUTION_DIR_NAME/package/batocera/emulationstation/batocera-emulationstation/batocera-emulationstation.mk
sed -i "s|^BATOCERA_EMULATIONSTATION_VERSION = .*|BATOCERA_EMULATIONSTATION_VERSION = $ES_FORK_GIT_TESTING_BRANCH|" $BASE_DIR/$LOCAL_DISTRIBUTION_DIR_NAME/package/batocera/emulationstation/batocera-emulationstation/batocera-emulationstation.mk

