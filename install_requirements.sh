#!/bin/bash
set -eux pipefail # For fail on any command
set +x            # Disable trace mode

# Check if the script is run as sudo or not
if [ $EUID -eq 0 ]; then
  # If yes, print a warning message in red
  echo -e "+ $(tput setaf 1)Warning:$(tput sgr0) This script should not be run as root. It will prompt for the sudo password when needed."
  exit 1
fi

# Function to check package manager and install requirements
install_packages() {
  # Try to find apt, dnf, yum, pacman or zypper in the PATH
  if command -v apt >/dev/null 2>&1; then
    # If apt is found, update the repositories and install the packages
    echo "+ $(tput setaf 6)Info:$(tput sgr0) Updating the software repositories..."
    sudo apt update >/dev/null 2>&1
    # Install pv if not already installed
    if ! command -v pv >/dev/null 2>&1; then
      echo "+ $(tput setaf 6)Info:$(tput sgr0) Installing pv..."
      sudo apt install pv >/dev/null 2>&1
    fi
    # Install dconf-cli, git, git-core, zsh, neofetch, powerline and curl with a progress bar
    echo "+ $(tput setaf 6)Info:$(tput sgr0) Installing dconf-cli, git, git-core, zsh, neofetch, powerline and curl..."
    sudo apt install dconf-cli git git-core zsh neofetch fonts-powerline curl -y 2>&1 | pv -cN packages >/dev/null
    return 0 # return success
  elif command -v dnf >/dev/null 2>&1; then
    # If dnf is found, update the repositories and install the packages
    echo "+ $(tput setaf 6)Info:$(tput sgr0) Updating the software repositories..."
    sudo dnf update >/dev/null 2>&1
    # Install pv if not already installed
    if ! command -v pv >/dev/null 2>&1; then
      echo "+ $(tput setaf 6)Info:$(tput sgr0) Installing pv..."
      sudo dnf install pv >/dev/null 2>&1
    fi
    # Install dconf-cli, git, git-core, zsh, neofetch, powerline and curl with a progress bar
    echo "+ $(tput setaf 6)Info:$(tput sgr0) Installing dconf-cli, git, git-core, zsh, neofetch, powerline and curl..."
    sudo dnf install dconf-cli git git-core zsh neofetch fonts-powerline curl -y 2>&1 | pv -cN packages >/dev/null
    return 0 # return success
  elif command -v yum >/dev/null 2>&1; then
    # If yum is found, update the repositories and install the packages
    echo "+ $(tput setaf 6)Info:$(tput sgr0) Updating the software repositories..."
    sudo yum update >/dev/null 2>&1
    # Install pv if not already installed
    if ! command -v pv >/dev/null 2>&1; then
      echo "+ $(tput setaf 6)Info:$(tput sgr0) Installing pv..."
      sudo yum install pv >/dev/null 2>&1
    fi
    # Install dconf-cli, git, git-core, zsh, neofetch, powerline and curl with a progress bar
    echo "+ $(tput setaf 6)Info:$(tput sgr0) Installing dconf-cli, git, git-core, zsh, neofetch, powerline and curl..."
    sudo yum install dconf-cli git git-core zsh neofetch fonts-powerline curl -y 2>&1 | pv -cN packages >/dev/null
    return 0 # return success
  elif command -v pacman >/dev/null 2>&1; then
    # If pacman is found, update the repositories and install the packages
    echo "+ $(tput setaf 6)Info:$(tput sgr0) Updating the software repositories..."
    sudo pacman -Syu >/dev/null 2>&1
    # Install pv if not already installed
    if ! command -v pv >/dev/null 2>&1; then
      echo "+ $(tput setaf 6)Info:$(tput sgr0) Installing pv..."
      sudo pacman -S pv >/dev/null 2>&1
    fi
    # Install dconf-cli, git, git-core, zsh, neofetch, powerline and curl with a progress bar
    echo "+ $(tput setaf 6)Info:$(tput sgr0) Installing dconf-cli, git, git-core, zsh, neofetch, powerline and curl..."
    sudo pacman -S dconf-cli git git-core zsh neofetch fonts-powerline curl -y 2>&1 | pv -cN packages >/dev/null
    return 0 # return success
  elif command -v zypper >/dev/null 2>&1; then
    # If zypper is found, update the repositories and install the packages
    echo "+ $(tput setaf 6)Info:$(tput sgr0) Updating the software repositories..."
    sudo zypper refresh >/dev/null 2>&1
    # Install pv if not already installed
    if ! command -v pv >/dev/null 2>&1; then
      echo "+ $(tput setaf 6)Info:$(tput sgr0) Installing pv..."
      sudo zypper install pv >/dev/null 2>&1
    fi
    # Install dconf-cli, git, git-core, zsh, neofetch, powerline and curl with a progress bar
    echo "+ $(tput setaf 6)Info:$(tput sgr0) Installing dconf-cli, git, git-core, zsh, neofetch, powerline and curl..."
    sudo zypper install dconf-cli git git-core zsh neofetch fonts-powerline curl -y 2>&1 | pv -cN packages >/dev/null
    return 0 # return success
  else
    # If none of them are found, print an error message and return 1 (failure)
    echo "+ $(tput setaf 1)Error:$(tput sgr0) Can't find a supported package manager."
    return 1
  fi
}

install_packages # Install all the required packages
if [ $? -eq 1 ]; then
  echo "+ $(tput setaf 1)Error:$(tput sgr0) Failed to install required packages."
  exit 1
else
  echo "+ $(tput setaf 2)Success:$(tput sgr0) Completed installing required packages."
fi

# Install oh-my-zsh for z-shell
echo "+ $(tput setaf 6)Info:$(tput sgr0) Installing oh-my-zsh for custom shell theme."
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
