#!/bin/bash

# USER-PROVIDED CONFIGURATIONSETTINGS BEGIN >>>>>

# Local environment (should point to the directory this repository was cloned into.)
BASE_DIR=/home/ryan/source/knulli-es-dev-env

# git settings
GIT_USER=t0b10
GIT_EMAIL=t0b10@null.void # don't put your real email here unless you want spam

# Repository configuration for distribution and emulationstation, local directories configuration
# Note: URLs should point to YOUR FORKS of the respective repositories
DISTRIBUTION_FORK_REPO=https://github.com/t0b10-r3tr0/knulli-distribution.git
EMULATIONSTATION_FORK_REPO=https://github.com/t0b10-r3tr0/knulli-emulationstation.git
LOCAL_DISTRIBUTION_DIR_NAME=knulli-distribution
LOCAL_EMULATIONSTATION_DIR_NAME=knulli-emulationstation

# Project Information
# Note: the test branch suffix will be added to the end of feature branch name. I.E. 'quick_resume_mode' -> 'quick_resume_mode_testing'
FEATURE_BRANCH_NAME=awesome_new_feature
TEST_BRANCH_SUFFIX=testing

# Generated branch names, change at your own risk
DISTRO_FORK_BRANCH=$FEATURE_BRANCH_NAME
DISTRO_FORK_TESTING_BRANCH=${FEATURE_BRANCH_NAME}_${TEST_BRANCH_SUFFIX}
ES_FORK_GIT_BRANCH=$FEATURE_BRANCH_NAME
ES_FORK_GIT_TESTING_BRANCH=${FEATURE_BRANCH_NAME}_${TEST_BRANCH_SUFFIX}

# USER-PROVIDED CONFIGURATION SETTINGS END <<<<<

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
git clone --recursive $DISTRIBUTION_FORK_REPO $LOCAL_DISTRIBUTION_DIR_NAME
cd $BASE_DIR/$LOCAL_DISTRIBUTION_DIR_NAME || exit

apply_git_settings

# set up our base branch
git checkout -b $DISTRO_FORK_BRANCH
touch .initial-setup
git commit -m "Initial commit."
git push --set-upstream origin $DISTRO_FORK_BRANCH

# setup our testing branch
git checkout -b "$DISTRO_FORK_TESTING_BRANCH" "origin/$DISTRO_FORK_BRANCH"
git commit -m "Initial commit."
git push --set-upstream origin "$DISTRO_FORK_TESTING_BRANCH"


# ES image creation
echo "Now creating Docker build environment..."
./getPoFromWebsite.sh
make build-docker-image || echo "Docker image build failed. ☹️" && exit

# download all sources prior to build
echo "Now downloading all sources..."
make h700-source || echo "Downloading sources failed. ☹️" && exit

# build the ES package with the new container
echo "Now building EmulationStation package..."
make h700-pkg PKG=batocera-emulationstation
echo
echo "Build Complete... 🔥"
echo
# DISTRIBUTION <<<<<


# EMULATIONSTATION >>>>>
git clone --recursive $EMULATIONSTATION_FORK_REPO $LOCAL_EMULATIONSTATION_DIR_NAME

# move to base directory and set git credentials
cd $BASE_DIR/$LOCAL_EMULATIONSTATION_DIR_NAME || exit
set_git_credentials
git fetch origin

# set up our base branch
git checkout -b $ES_FORK_GIT_BRANCH
git commit -m "Initial commit."
git push --set-upstream origin $ES_FORK_GIT_BRANCH

# setup our testing branch
git checkout -b "$ES_FORK_GIT_TESTING_BRANCH" origin/$ES_FORK_GIT_BRANCH
git commit -m "Initial commit."
git push --set-upstream "$ES_FORK_GIT_TESTING_BRANCH"

# EMULATIONSTATION <<<<<