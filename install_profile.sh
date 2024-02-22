#!/bin/bash
set -eux pipefail # For fail on any command
set +x            # Disable trace mode

# Check if .oh-my-zsh directory exists
if [ -d ~/.oh-my-zsh ]; then
  # Install syntax-highlighting plugin
  (cd ~/.oh-my-zsh/custom/plugins && git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting)
  # Install autosuggestions plugin
  (cd ~/.oh-my-zsh/custom/plugins && git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions)
else
  # Print an error message and exit
  echo "+ $(tput setaf 1)Error:$(tput sgr0) The '.oh-my-zsh' directory does not exist."
  echo "+ $(tput setaf 6)Info:$(tput sgr0) Please run 'install_requirements.sh' it first."
  exit 1
fi

cat configs/zshrc > ~/.zshrc # Replace the zsh configs file with the one in configs/
mkdir ~/.config/neofetch/ >/dev/null 2>&1 # Make dir for custom neofetch config file
sudo cp configs/settings.conf  ~/.config/neofetch/ # Copy custom neofetch config file

# Backup and load new terminal profile
echo -e "$(tput setaf 6)NOTE: The original settings of your terminal are saved in this file: ~/terminal_profile_backup.dconf$(tput sgr0)"
dconf dump /org/gnome/terminal/legacy/profiles:/ > ~/terminal_profile_backup.dconf
dconf load /org/gnome/terminal/legacy/profiles:/ < configs/terminal_profile.dconf

# Copy the custom agnoster theme in the themes folder
cp configs/custom-agnoster.zsh-theme ~/.oh-my-zsh/themes/

# Switch shell from bash to zsh
chsh -s $(which zsh)
