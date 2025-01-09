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
BASE_DIR=/home/t0b10/source/knulli-es-dev-env # directory where this repository is installed
GIT_USER=t0b10 # your GitHub account user name
GIT_EMAIL=t0b10@null.void # do NOT put your real email here *unless you want spam*
DISTRIBUTION_FORK_REPO=https://github.com/t0b10-r3tr0/knulli-distribution.git # your fork of Knulli Distro
EMULATIONSTATION_FORK_REPO=https://github.com/t0b10-r3tr0/knulli-emulationstation.git # your fork of Knulli ES
LOCAL_DISTRIBUTION_DIR_NAME=knulli-distribution # local directory name for Knulli Distro fork
LOCAL_EMULATIONSTATION_DIR_NAME=knulli-emulationstation  # local directory name for Knulli ES fork
FEATURE_BRANCH_NAME=awesome_new_feature # the name of the feature you're developing
TEST_BRANCH_SUFFIX=testing # added to the end of feature name for the testing branch
```

### More coming soon