#!/bin/bash
set -eux pipefail # For fail on any command
set +x            # Disable trace mode

# Check if the script is run as sudo or not
if [ $EUID -eq 0 ]; then
  # If yes, print a warning message in red
  echo -e "$(tput setaf 1)Warning:$(tput sgr0) This script should not be run as sudo. It will prompt for the sudo password when needed."
  exit 1
fi

# Function to check package manager and install requirements
install_packages() {
  # Try to find apt, dnf, yum, pacman or zypper in the PATH
  if command -v apt >/dev/null 2>&1; then
    # If apt is found, update the repositories and install the packages
    echo "Updating the software repositories..."
    sudo apt update >/dev/null 2>&1
    # Install pv if not already installed
    if ! command -v pv >/dev/null 2>&1; then
      echo "Installing pv..."
      sudo apt install pv >/dev/null 2>&1
    fi
    # Install git, git-core, zsh, neofetch and curl with a progress bar
    echo "Installing git, git-core, zsh, neofetch and curl..."
    sudo apt install git git-core zsh neofetch curl -y 2>&1 | pv -cN packages >/dev/null
    return 0 # return success
  elif command -v dnf >/dev/null 2>&1; then
    # If dnf is found, update the repositories and install the packages
    echo "Updating the software repositories..."
    sudo dnf update >/dev/null 2>&1
    # Install pv if not already installed
    if ! command -v pv >/dev/null 2>&1; then
      echo "Installing pv..."
      sudo dnf install pv >/dev/null 2>&1
    fi
    # Install git, git-core, zsh, neofetch and curl with a progress bar
    echo "Installing git, git-core, zsh, neofetch and curl..."
    sudo dnf install git git-core zsh neofetch curl -y 2>&1 | pv -cN packages >/dev/null
    return 0 # return success
  elif command -v yum >/dev/null 2>&1; then
    # If yum is found, update the repositories and install the packages
    echo "Updating the software repositories..."
    sudo yum update >/dev/null 2>&1
    # Install pv if not already installed
    if ! command -v pv >/dev/null 2>&1; then
      echo "Installing pv..."
      sudo yum install pv >/dev/null 2>&1
    fi
    # Install git, git-core, zsh, neofetch and curl with a progress bar
    echo "Installing git, git-core, zsh, neofetch and curl..."
    sudo yum install git git-core zsh neofetch curl -y 2>&1 | pv -cN packages >/dev/null
    return 0 # return success
  elif command -v pacman >/dev/null 2>&1; then
    # If pacman is found, update the repositories and install the packages
    echo "Updating the software repositories..."
    sudo pacman -Syu >/dev/null 2>&1
    # Install pv if not already installed
    if ! command -v pv >/dev/null 2>&1; then
      echo "Installing pv..."
      sudo pacman -S pv >/dev/null 2>&1
    fi
    # Install git, git-core, zsh, neofetch and curl with a progress bar
    echo "Installing git, git-core, zsh, neofetch and curl..."
    sudo pacman -S git git-core zsh neofetch curl -y 2>&1 | pv -cN packages >/dev/null
    return 0 # return success
  elif command -v zypper >/dev/null 2>&1; then
    # If zypper is found, update the repositories and install the packages
    echo "Updating the software repositories..."
    sudo zypper refresh >/dev/null 2>&1
    # Install pv if not already installed
    if ! command -v pv >/dev/null 2>&1; then
      echo "Installing pv..."
      sudo zypper install pv >/dev/null 2>&1
    fi
    # Install git, git-core, zsh, neofetch and curl with a progress bar
    echo "Installing git, git-core, zsh, neofetch and curl..."
    sudo zypper install git git-core zsh neofetch curl -y 2>&1 | pv -cN packages >/dev/null
    return 0 # return success
  else
    # If none of them are found, print an error message and return 1 (failure)
    echo "Error: Can't find a supported package manager"
    return 1
  fi
}

echo -e "$(tput setaf 1)IMPORTANT:$(tput setaf 3) To apply the changes and install the plugins, you need to run the command `exit` after the shell switches to zsh.$(tput sgr0)"
install_packages # Install all the required packages

sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"                  # Install oh-my-zsh for zsh
(cd ~/.oh-my-zsh/custom/plugins && git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting) # Install syntax-highlighting plugin
(cd ~/.oh-my-zsh/custom/plugins && git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions)     # Install autosuggestions plugin

sudo cat configs/zshrc > ~/.zshrc # Replace the zsh configs file with the one in configs/
sudo cp configs/settings.conf  ~/.config/neofetch/ # Replace the default neofetch config file

# Backup and load new terminal profile
echo -e "$(tput setaf 6)NOTE: The original settings of your terminal are saved in this file: ~/terminal_profile_backup.dconf$(tput sgr0)"
dconf dump /org/gnome/terminal/legacy/profiles:/ > ~/terminal_profile_backup.dconf
dconf load /org/gnome/terminal/legacy/profiles:/ < configs/terminal_profile.dconf

# Switch shell from bash to zsh
chsh -s $(which zsh)
