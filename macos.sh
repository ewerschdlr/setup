#!/usr/bin/env bash

GIT_NAME="$1"
GIT_EMAIL="$2"
LOG_FILE="$3"

GREEN="\033[1;32m"
GRAY="\033[1;90m"
ENDCOLOR="\033[0m"

DEVELOPMENT=(
    "flutter"
    "kotlin"
    "clojure"
    "neovim"
    "emacs"
    "intellij-idea-ce"
    "android-studio"
    "iterm2"
    "dbeaver-community"
    "insomnia"
    "postman"
    "font-fira-code"
    "android-platform-tools"
    "android-file-transfer"
    "gh"
    "github"
    "openjdk"
    "zsh"
    "powerlevel10k"
    "docker"
    "maven"
    "gradle"
    "xcodegen"
    "scrcpy"
    "bash"
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
    "ffmpeg"
    "logi-options-plus"
    "ankerwork"
)

FILE_SYSTEM_EXTENSIONS=(
    "macfuse"
)

if [ -z "$LOG_FILE" ]; then
  echo -ne "Enter file in which to save the log ${GRAY}(/tmp/setup-mac.log)${ENDCOLOR}: "
  read -r LOG_FILE

  if [ -z "$LOG_FILE" ]; then
    LOG_FILE="/tmp/setup-mac.log"
  else
    LOG_DIR=$(dirname "$LOG_FILE")

    if [ ! -d "$LOG_DIR" ]; then
      echo "The directory $LOG_DIR does not exist."
      echo -ne "Do you want to create it? ${GRAY}(${ENDCOLOR}y${GRAY}/n)${ENDCOLOR}: "
      read -r create_dir
      if [[ "$create_dir" == "y" || "$create_dir" == "Y" || "$create_dir" == "" ]]; then
        mkdir -p "$LOG_DIR"
      else
        LOG_FILE="/tmp/setup-mac.log"
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

# Xcode CLI tools
echo -e "\n${GREEN}# Installing Xcode Command Line Tools${ENDCOLOR}\n"
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

    # development tools
    echo -e "\n${GREEN}# Installing development tools${ENDCOLOR}\n"
    brew install "${DEVELOPMENT[@]}"

    # nvm
    if [ -z "$NVM_DIR" ]; then
        brew uninstall --ignore-dependencies node
        brew uninstall --force node
        brew install nvm
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

    # softwares
    echo -e "\n${GREEN}# Installing softwares${ENDCOLOR}\n"
    brew install "${SOFTWARES[@]}";

    # file system extensions
    echo -e "\n${GREEN}# Installing file system extensions${ENDCOLOR}\n"
    brew install "${FILE_SYSTEM_EXTENSIONS[@]}";
) 2>&1 | tee -a "$LOG_FILE"
