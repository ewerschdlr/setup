#!/usr/bin/env bash

GIT_NAME="$1"
GIT_EMAIL="$2"
LOG_FILE="$3"
DEFAULT_LOG_FILE="/tmp/setup-mac-$(date +%Y/%m/%d-%H:%M:%S).log"

GREEN="\033[1;32m"
GRAY="\033[1;90m"
RED="\033[1;31m"
ENDCOLOR="\033[0m"

BREW_FORMULAE_DEV_TOOLS=(
    "kotlin"
    "nvm"
    "neovim"
    "gh"
    "openjdk"
    "zsh"
    "powerlevel10k"
    "maven"
    "gradle"
    "xcodegen"
    "scrcpy"
    "python@3.10"
    "bash"
    "fastlane"
    "oha"
    "oven-sh/bun/bun"
    "ffmpeg"
)

BREW_CASKS_DEV_TOOLS=(
    "flutter"
    "android-studio"
    "iterm2"
    "dbeaver-community"
    "insomnia"
    "postman"
    "android-platform-tools"
    "android-file-transfer"
    "github"
    "google-cloud-sdk"
    "docker"
    "keycastr"
)

SOFTWARES=(
    "rectangle"
    "discord"
    "slack"
    "whatsapp"
    "telegram"
    "spotify"
    "notion"
    "notion-calendar"
    "miro"
    "figma"
    "zoom"
    "google-chrome"
    "brave-browser"
    "obsidian"
    "raycast"
    "gimp"
    "setapp"
    "cleanshot"
    "obs"
    "vlc"
    "grammarly-desktop"
    "nordvpn"
    "appcleaner"
    "logi-options-plus"
    "ankerwork"
    "balenaetcher"
)

SYSTEM_EXTENSIONS=(
    "macfuse"
)

FONTS=(
  "font-fira-code"
)

if [ -z "$LOG_FILE" ]; then
  echo -ne "Enter file in which to save the log ${GRAY}(/tmp/setup-mac.log)${ENDCOLOR}: "
  read -r LOG_FILE

  if [ -z "$LOG_FILE" ]; then
    LOG_FILE="${DEFAULT_LOG_FILE}"
  else
    LOG_DIR=$(dirname "$LOG_FILE")

    if [ ! -d "$LOG_DIR" ]; then
      echo "The directory $LOG_DIR does not exist."
      echo -ne "Do you want to create it? ${GRAY}(${ENDCOLOR}y${GRAY}/n)${ENDCOLOR}: "
      read -r create_dir
      if [[ "$create_dir" == "y" || "$create_dir" == "Y" || "$create_dir" == "" ]]; then
        mkdir -p "$LOG_DIR"
      else
        LOG_FILE="${DEFAULT_LOG_FILE}"
        echo "Using the default destination instead: $LOG_FILE"
      fi
    fi
  fi
fi

echo -ne "Do you want to config your git user name and email? ${GRAY}(${ENDCOLOR}y${GRAY}/n)${ENDCOLOR}: "
read -r config_git
if [[ "$config_git" == "y" || "$config_git" == "Y" || "$config_git" == "" ]]; then
  if [ -z "$GIT_NAME" ]; then
    echo -n "Please provide your git name: "
    read -r GIT_NAME
  fi

  if [ -z "$GIT_EMAIL" ]; then
    echo -n "Please provide your git email: "
    read -r GIT_EMAIL
  fi
fi

echo -e "${GREEN}Starting the installations at $(date +%Y/%m/%d-%H:%M:%S)${ENDCOLOR}\n\n" 2>&1 | tee -a "$LOG_FILE"

# Xcode CLI tools
echo -e "\n${GREEN}# Installing Xcode Command Line Tools${ENDCOLOR}\n" 2>&1 | tee -a "$LOG_FILE"
xcode-select --install 2>&1 | tee -a "$LOG_FILE"

# git config
if [ -n "$GIT_NAME" ]; then
  git config --global user.name "$GIT_NAME"
fi
if [ -n "$GIT_EMAIL" ]; then
  git config --global user.email "$GIT_EMAIL"
fi

(
    # homebrew
    if ! command -v brew &>/dev/null; then
        echo -e "\n${GREEN}# Installing Homebrew${ENDCOLOR}\n"
        curl -s https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
        echo "eval \"$(/opt/homebrew/bin/brew shellenv)\" # This loads homebrew" >> "$HOME"/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
        brew update
    fi

    # cleaning the environment for brew installs
    brew uninstall --ignore-dependencies node
    brew uninstall --force node

    ## development tools
    echo -e "\n${GREEN}# Installing brew casks development tools${ENDCOLOR}\n"
    brew install "${BREW_FORMULAE_DEV_TOOLS[@]}"

    echo -e "\n${GREEN}# Installing brew formulae development tools${ENDCOLOR}\n"
    brew install --cask "${BREW_CASKS_DEV_TOOLS[@]}"

    # development configs
    # node
    if brew list nvm &> /dev/null; then
        if [ -z "$NVM_DIR" ]; then
            mkdir ~/.nvm
            {
              echo "export NVM_DIR=\"\$HOME/.nvm\""
              "[ -s \"/opt/homebrew/opt/nvm/nvm.sh\" ] && \. \"/opt/homebrew/opt/nvm/nvm.sh\"  # This loads nvm"
              "[ -s \"/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm\" ] && \. \"/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm\"  # This loads nvm bash_completion"
            } >> "$HOME"/.zprofile
            source "$HOME"/.zprofile
            nvm install --lts
            nvm use --lts
        fi
    else
        echo -e "\n${RED}nvm and node is not installed.${ENDCOLOR}"
    fi

    # zsh
    if brew list powerlevel10k &> /dev/null; then
        echo "source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
    fi

    # gcloud
    export CLOUDSDK_PYTHON=$(which python3.10)
    source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
    source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

    ## software
    echo -e "\n${GREEN}# Installing softwares${ENDCOLOR}\n"
    brew install --cask "${SOFTWARES[@]}";

    ## file system extensions
    echo -e "\n${GREEN}# Installing system extensions${ENDCOLOR}\n"
    brew install --cask "${SYSTEM_EXTENSIONS[@]}";

    ## fonts
    echo -e "\n${GREEN}# Installing fonts${ENDCOLOR}\n"
    brew tap homebrew/cask-fonts
    brew install --cask "${FONTS[@]}";

    echo -e "${GREEN}Ending the installations at $(date +%Y/%m/%d %H:%M:%S)${ENDCOLOR}\n\n"

) 2>&1 | tee -a "$LOG_FILE"
