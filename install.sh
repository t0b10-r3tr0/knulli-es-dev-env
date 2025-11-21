#!/bin/bash

source ./settings.conf

# function definitions
apply_git_settings() {
    git config user.name $GIT_USER
    git config user.email $GIT_EMAIL
    git config push.autoSetupRemote true
}

# # Dependencies
echo "Now installing dependencies..."
sudo apt update && sudo apt install -y build-essential gettext

mkdir -p $BASE_DIR
cd $BASE_DIR || exit
apply_git_settings

# # DISTRIBUTION >>>>>
if [ -d "$BASE_DIR/$LOCAL_DISTRIBUTION_DIR_NAME" ]; then
    echo "$BASE_DIR/$LOCAL_DISTRIBUTION_DIR_NAME already exists - skipping git cloning distribution."
else
    echo "Now cloning distribution..."
    git clone --recursive $DISTRIBUTION_FORK_REPO".git" $LOCAL_DISTRIBUTION_DIR_NAME
fi
cd $BASE_DIR/$LOCAL_DISTRIBUTION_DIR_NAME || exit
apply_git_settings
git fetch origin

# set up our base branch
git ls-remote --exit-code --heads origin $DISTRO_FORK_BRANCH >/dev/null 2>&1
EXIT_CODE=$?

if [[ $EXIT_CODE == '0' ]]; then
    echo "Git branch '$DISTRO_FORK_BRANCH' exists in the remote repository"
    git checkout $DISTRO_FORK_BRANCH
elif [[ $EXIT_CODE == '2' ]]; then
    echo "Git branch '$DISTRO_FORK_BRANCH' does not exist in the remote repository."
    git checkout -b $DISTRO_FORK_BRANCH
    touch .initial-setup
    git commit -m "Initial commit."
    git push --set-upstream origin $DISTRO_FORK_BRANCH
fi

# set up our base branch
git ls-remote --exit-code --heads origin $DISTRO_FORK_TESTING_BRANCH >/dev/null 2>&1
EXIT_CODE=$?

if [[ $EXIT_CODE == '0' ]]; then
    echo "Git branch '$DISTRO_FORK_TESTING_BRANCH' exists in the remote repository"
    git checkout $DISTRO_FORK_TESTING_BRANCH
elif [[ $EXIT_CODE == '2' ]]; then
    echo "Git branch '$DISTRO_FORK_TESTING_BRANCH' does not exist in the remote repository."
    git checkout -b "$DISTRO_FORK_TESTING_BRANCH" "origin/$DISTRO_FORK_BRANCH"
    git commit -m "Initial commit."
    git push --set-upstream origin "$DISTRO_FORK_TESTING_BRANCH"
fi

# ES image creation
echo "Now creating Docker build environment..."
cd $BASE_DIR/$LOCAL_DISTRIBUTION_DIR_NAME
./getPoFromWebsite.sh
make build-docker-image || { echo "Docker image build failed. ☹️"; exit; }
                        # TODO: find different way to check for success (maybe docker container ls)

# download all sources prior to build
echo "Now downloading all sources..."
make $TARGET-source || { echo "Downloading sources failed. ☹️"; exit; }
                        # TODO: find different way to check for success

# build the ES package with the new container
echo "Now building EmulationStation package..."
make $TARGET-pkg PKG=knulli-emulationstation || { echo "Build failed. ☹️"; exit; }
echo
echo "Build Complete... 🔥"
echo
# DISTRIBUTION <<<<<


# EMULATIONSTATION >>>>>
cd $BASE_DIR

if [ -d "$BASE_DIR/$LOCAL_DISTRIBUTION_DIR_NAME" ]; then
    echo "$BASE_DIR/$LOCAL_DISTRIBUTION_DIR_NAME already exists - skipping git cloning emulationstation."
else
    echo "Now cloning emulationstation..."
    git clone --recursive $EMULATIONSTATION_FORK_REPO".git" $LOCAL_EMULATIONSTATION_DIR_NAME
fi

# move to base directory and set git credentials
cd $BASE_DIR/$LOCAL_EMULATIONSTATION_DIR_NAME || exit
apply_git_settings
git fetch origin

# set up our base branch
git ls-remote --exit-code --heads origin $ES_FORK_GIT_BRANCH >/dev/null 2>&1
EXIT_CODE=$?

if [[ $EXIT_CODE == '0' ]]; then
    echo "Git branch '$ES_FORK_GIT_BRANCH' exists in the remote repository"
    git checkout $ES_FORK_GIT_BRANCH
elif [[ $EXIT_CODE == '2' ]]; then
    echo "Git branch '$ES_FORK_GIT_BRANCH' does not exist in the remote repository."
    git checkout -b $ES_FORK_GIT_BRANCH
    touch .initial-setup
    git commit -m "Initial commit."
    git push --set-upstream origin $ES_FORK_GIT_BRANCH
fi

# set up our base branch
git ls-remote --exit-code --heads origin $ES_FORK_GIT_TESTING_BRANCH >/dev/null 2>&1
EXIT_CODE=$?

if [[ $EXIT_CODE == '0' ]]; then
    echo "Git branch '$ES_FORK_GIT_TESTING_BRANCH' exists in the remote repository"
    git checkout $ES_FORK_GIT_TESTING_BRANCH
elif [[ $EXIT_CODE == '2' ]]; then
    echo "Git branch '$ES_FORK_GIT_TESTING_BRANCH' does not exist in the remote repository."
    git checkout -b "$ES_FORK_GIT_TEcd STING_BRANCH" "origin/$ES_FORK_GIT_BRANCH"
    git commit -m "Initial commit."
    git push --set-upstream origin "$ES_FORK_GIT_TESTING_BRANCH"
fi
# EMULATIONSTATION <<<<<

# IN PROGRESS
sed -i "s|^KNULLI_EMULATIONSTATION_SITE = .*|KNULLI_EMULATIONSTATION_SITE = $EMULATIONSTATION_FORK_REPO|" $BASE_DIR/$LOCAL_DISTRIBUTION_DIR_NAME/package/emulationstation/knulli-emulationstation/knulli-emulationstation.mk
sed -i "s|^KNULLI_EMULATIONSTATION_VERSION = .*|KNULLI_EMULATIONSTATION_VERSION = $ES_FORK_GIT_TESTING_BRANCH|" $BASE_DIR/$LOCAL_DISTRIBUTION_DIR_NAME/package/emulationstation/knulli-emulationstation/knulli-emulationstation.mk
