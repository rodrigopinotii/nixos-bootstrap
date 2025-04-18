# nixos-bootstrap
An environment to bootstrap building a nixos configuration for daily development of Ghaf and Nixos based projects.

This is a bootstrap setup and it is intended only as a starter kit. You will have to adjust this configuration as you become more familiar with nixos to best suit your needs. 

# Pre-requisites

1. A linux machine to install Nixos on
2. An ssd from which to install the image
3. Download ["NixOS : the Linux distribution"](https://nixos.org/download/)
4. Burn the ISO to the ssd
   - Insert the ssd
   - lsblk to find the name of the ssd e.g. `/dev/sdb`
   - `sudo dd if=~/Downloads/NAME_OF_ISO.iso of=/dev/sdb bs=32M status=progress; sync`
5. Insert the ssd into the target machine
6. Select the SSD boot from the BIOS of the target machine
7. Enter the installer

# Install base Nixos System

1. enable the wifi in the installer
2. Follow the installation procedure in the installer
  - enter location
  - select the correct locale
  - choose username/password
  - use the same password for the Super User
  - choose `Erase` when presented with the formatting option
  - Allow unfree packages
  - Complete the installation
3. choose reboot from the menu top right
4. remove the ssd
5. boot into the new Nixos Image

# Bootstrap Process

1. Fork this repository to your own GitHub account
2. Enable wifi on the target machine now that it has been installed
3. Press the `windows key`
4. type `Console` and open the console application
5. Use the following command to install git temporarily
   - `nix-shell -p git`
6. `git clone https://github.com/YOURNAME/nixos-bootstrap.git ~/.dotfiles`
7. `cd ~/.dotfiles`
8. `./pre-run.sh`
9. Enter all the details that are requested.
10. Check that the process says "Success"
11. Ensure the config is correct - type `YES` when prompted CAPITAL `YES`
    - `nixos-rebuild dry-run --flake .#YOUR_HOST_NAME`
12. Assuming that was successful  - type `YES` when prompted CAPITAL `YES`
13. `sudo nixos-rebuild switch --flake .#YOUR_HOST_NAME`
14. Run the post script to finalize the installation
    - `./post-build.sh`
15. Follow the instructions to add your ssh key to github
16. reboot the laptop

# Final cleanup and commit

1. Open the terminal again and change back to your config.
   - `cd ~/.dotfiles`
2. Add your keys to the ssh-agent
3. `eval "$(ssh-agent -s)"`
4. `ssh-add ~/.ssh/github-key`
5. `git remote remove origin`
6. In your nixos-bootstrap repo select `CODE` and choose the ssh option
7. `git remote add origin git@URL_OF_REPO`
8. `git fetch`
9. `git add --all`
10. `git commit -sm "Personalize Nixos Config"`
11. `git push origin main`
12. Create PRs to upload your builder-key.pub to the development repos.

# Reboot to finalize the installation

1. Find all TODO items and ensure that you follow the instructions to complete the setup.


There are some helper scripts that will enable you to use to keep this configuration upto date.

## Update package versions to the latest

`update-host`

This will update the pinned version of the inputs in the flake.nix. In general it will fetch the latest versions of all the inputs and by doing this will update the `flake.lock` file. This will mean that you have access to all the latest packages but it does not apply them to your system.

`rebuild-host`

This script will ensure that all the changes and updated packages are applied to your system. Every time that you add a package, change the configuration or run `update-host` you should run `rebuild-host` for those changes to take effect.

After you modify the configuration be sure to commit the changes to git and push the changes to your fork so that you have a reference in the case of disaster recovery.

