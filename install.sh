#!/bin/bash

# git settings
FEATURE_NAME=test_feature
GIT_USER=t0b10
GIT_EMAIL=t0b10@null.void # don't put your real email here unless you want spam
TEST_BRANCH_SUFFIX=testing

# environment
BASE_DIR=/home/ryan/source/knulli-es-dev-env

# repos and local repo names (note: point to YOUR FORKS of the repositories)
REPO_URL_DISTRO=https://github.com/t0b10-r3tr0/knulli-distribution.git
REPO_URL_ES=https://github.com/t0b10-r3tr0/knulli-emulationstation.git
LOCAL_REPO_NAME_DISTRO=knulli-distribution
LOCAL_REPO_NAME_ES=knulli-emulationstation

# generated - leave as-is
ES_GIT_BRANCH=$FEATURE_NAME
DISTRO_GIT_BRANCH=$FEATURE_NAME
ES_TEST_GIT_BRANCH=${FEATURE_NAME}_${TEST_BRANCH_SUFFIX}
DISTRO_TEST_GIT_BRANCH=${FEATURE_NAME}_${TEST_BRANCH_SUFFIX}

# function definitions
apply_git_settings() {
    git config user.name $GIT_USER
    git config user.email $GIT_EMAIL
    git config --global push.autoSetupRemote true
}

# Dependencies
echo "Now installing dependencies..."
sudo apt update && sudo apt install -y build-essential || echo "failed to download dependencices" && exit
mkdir -p $BASE_DIR && cd $BASE_DIR || exit

# DISTRIBUTION >>>
echo "Now cloning distribution..."
git clone --recursive $REPO_URL_DISTRO $LOCAL_REPO_NAME_DISTRO
cd $BASE_DIR/$LOCAL_REPO_NAME_DISTRO || exit
apply_git_settings

# set up our base branch
git checkout -b $DISTRO_GIT_BRANCH
git commit -m "Initial commit."
git push --set-upstream origin $DISTRO_GIT_BRANCH

# setup our testing branch
git checkout -b "$DISTRO_TEST_GIT_BRANCH" "origin/$DISTRO_GIT_BRANCH"
git commit -m "Initial commit."
git push --set-upstream origin "$DISTRO_TEST_GIT_BRANCH"


# ES image creation
echo "Now creating Docker build environment..."
./getPoFromWebsite.sh
make build-docker-image || echo "Docker image build failed. ☹️" && exit
# download all sources prior to build
echo "Now downloading all sources..."
make h700-sorce || echo "Downloading sources failed. ☹️" && exit
# build the ES package with the new container
echo "Now building EmulationStation package..."
make h700-pkg PKG=batocera-emulationstation || echo "Build of batocera=emulationstation failed." && exit

echo
echo "Build Complete... 🔥"
echo

# DISTRIBUTION >>>

# # EMULATIONSTATION >>>
# git clone --recursive $REPO_URL_ES $LOCAL_REPO_NAME_ES

# # move to base directory and set git credentials
# cd $BASE_DIR/$LOCAL_REPO_NAME_ES || exit
# set_git_credentials
# git fetch origin

# # set up our base branch
# git checkout -b $ES_GIT_BRANCH
# git commit -m "Initial commit."
# git push --set-upstream origin $ES_GIT_BRANCH

# # setup our testing branch
# git checkout -b "$ES_TEST_GIT_BRANCH" origin/$ES_GIT_BRANCH
# git commit -m "Initial commit."
# git push --set-upstream "$ES_TEST_GIT_BRANCH"

# # EMULATIONSTATION >>>