# Knulli EmulationStation Development Environment

## What's this monstrosity?
This project seeks to rapidly onboard contributors to the Knulli CFW project by reducing barriers to entry through automation and scripting.

## Who's it for?
This solution is designed with tinkerers in mind. It's for those who want to customize EmulationStation and then try out the changes, on-device, immediately after.

## Instructions
The following steps provide a guideline on how to use the tool.
### Clone the Repository
```shell script
git clone --recursive https://github.com/t0b10-r3tr0/knulli-es-dev-env.git
cd knulli-es-dev-env
```
### Modify Configurable User Settings
Open `install.sh` in your text-editor-of-choice and modify the values within the section titled `USER-PROVIDED CONFIGURATION SETTINGS` to reflect your local environment. This tool assumes that you already have the following set-up, which will be required in the above mentioned settings:
* A fork of the [Knulli Distribution repository](https://github.com/knulli-cfw/distribution).
* A fork of the [Knulli EmulationStation repository](https://github.com/knulli-cfw/batocera-emulationstation).

The following represents the user settings that must be configured.
```shell script
# Local environment (should point to the directory this repository was cloned into.)
BASE_DIR=/home/t0b10/source/knulli-es-dev-env
TARGET=h700

# git settings
GIT_USER=t0b10
GIT_EMAIL=t0b10@null.void # don't put your real email here unless you want spam

# device login
DEVICE_LOGIN=root@knulli

# Repository configuration for distribution and emulationstation, local directories configuration
# Note: URLs should point to YOUR FORKS of the respective repositories
DISTRIBUTION_FORK_REPO=https://github.com/t0b10-r3tr0/knulli-distribution
EMULATIONSTATION_FORK_REPO=https://github.com/t0b10-r3tr0/knulli-emulationstation
LOCAL_DISTRIBUTION_DIR_NAME=knulli-distribution
LOCAL_EMULATIONSTATION_DIR_NAME=knulli-emulationstation

# Project Information
# Note: the test branch suffix will be added to the end of feature branch name. I.E. 'quick_resume_mode' -> 'quick_resume_mode_testing'
FEATURE_BRANCH_NAME=quick_resume_mode
TEST_BRANCH_SUFFIX=testing

# Generated branch names, change at your own risk
DISTRO_FORK_BRANCH=$FEATURE_BRANCH_NAME
DISTRO_FORK_TESTING_BRANCH=${FEATURE_BRANCH_NAME}_${TEST_BRANCH_SUFFIX}
ES_FORK_GIT_BRANCH=$FEATURE_BRANCH_NAME
ES_FORK_GIT_TESTING_BRANCH=${FEATURE_BRANCH_NAME}_${TEST_BRANCH_SUFFIX}
```
### More coming soon
