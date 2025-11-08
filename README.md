# Knulli EmulationStation Development Environment

## What's this monstrosity?
This project seeks to rapidly onboard contributors to the Knulli CFW project by reducing barriers to entry through automation and scripting.

## Who's it for?
This solution is designed with tinkerers in mind. It's for those who want to customize EmulationStation and then try out the changes, on-device, immediately after.

## Instructions
The following steps provide a guideline on how to use the tool.

### Before you start
To start working on Knulli EmulationStation, you need to set up a Linux system. A good choice would be *Ubuntu*/*Kubuntu*. You can either set this up as a dedicated OS, as a virtual machine, or on your Windows 10/11 computer as a WSL environment.

Whatever Linux setup you chose, make sure that *Docker* is also up and running before you proceed.

Next, make sure that you have a GitHub account and have forked the two repositories required to work on Knulli EmulationStation:
* A fork of the [Knulli Distribution repository](https://github.com/knulli-cfw/distribution).
* A fork of the [Knulli EmulationStation repository](https://github.com/knulli-cfw/

### Clone the Repository
First, navigate to the folder where you would like to set up your Knulli development environment. (In the following example, we assume you chose `/home/chrizzo/dev`).
```shell script
cd /home/chrizzo/dev
git clone --recursive https://github.com/chrizzo-hb/knulli-es-dev-env.git knulli
cd knulli
```
### Modify Configurable User Settings
Open `settings.conf` in your text-editor-of-choice and modify the values to reflect your local environment and your own forks of the Knulli repositories mentioned above.

Make sure to pick the right `TARGET` which refers to the *architecture* you want to be working on, e.g. `h700` for the Anbernic RG XX devices or `a133` for the TrimUI devices.

Here's an example:

```shell script
# Local environment (should point to the directory this repository was cloned into.)
BASE_DIR=/home/chrizzo/dev/knulli
TARGET=a133

# git settings
GIT_USER=chrizzo-hb
GIT_EMAIL=chrizzo-hb@null.void # don't put your real email here unless you want spam

# device login
DEVICE_LOGIN=root@knulli

# Repository configuration for distribution and emulationstation, local directories configuration
# Note: URLs should point to YOUR FORKS of the respective repositories
DISTRIBUTION_FORK_REPO=https://github.com/chrizzo-hb/knulli-distribution
EMULATIONSTATION_FORK_REPO=https://github.com/chrizzo-hb/knulli-emulationstation
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
### Run the install script

Once the `settings.conf` file is set up to your liking, make sure have a stable internet connection and then simply run

```shell script
./install.sh
```

to begin the installation process. **This might take some time.** Maybe even hours, so please be patient. During the process, a ton of source code will be downloaded to your machine - everything required to build Knulli and, more importantly, build Knulli ES against the respective target architecture.

## After successful installation

After successful installation, you will find that your Knulli development folder has been populated with

* `knulli-distribution/` where the Knulli *distribution* resides - a folder required for *compiling*
* `knulli-emulationstation/` where the Knulli *EmulationStation* source code resides - this is where you will edit your code.
* `tools/` where you will find two important commands
    * `build.sh` makes sure the compilation process will integrate the branch you are currently using in `knulli-emulationstation` in the compilation process before starting to compile *EmulationStation* against the target architecture of your choice as indicated by the `TARGET` setting in `settings.conf`
    * `deploy.sh` helps you deploy the latest successfully compiled version of ES to a device via SSH as indicated by the `DEVICE_LOGIN` setting in `settings.conf`
* `install.sh` the installation script
* `README.md` the instruction manual you are reading right now
* `settings.conf` your current environment settings