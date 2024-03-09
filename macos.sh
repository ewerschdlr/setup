#!/usr/bin/env bash

GIT_NAME="$1"
GIT_EMAIL="$2"
LOG_FILE="${3:-/tmp/macsetup.log}"

DEV_LANGUAGES=(
    "flutter"
    "kotlin"
    "clojure"
    "nvm"
)

DEV_TOOLS=(
    "iterm2"
    "dbeaver-community"
    "insomnia"
    "postman"
    "font-fira-code"
    "android-platform-tools"
    "android-file-transfer"
    "github"
    "openjdk"
    "zsh"
    "powerlevel10k"
    "docker"
    "maven"
    "gradle"
    "xcodegen"
    "scrcpy"
)

CODE_EDITORS=(
    "neovim"
    "emacs"
    "intellij-idea-ce"
    "android-studio"
    "visual-studio-code"
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
    "zoom"
    "microsoft-teams"
    "google-chrome"
    "brave-browser"
    "firefox"
    "obsidian"
    "miro"
    "figma"
    "raycast"
    "fig"
    "gimp"
    "anki"
    "setapp"
    "cleanshot"
    "obs"
    "vlc"
    "grammarly-desktop"
    "nordvpn"
    "cirruslabs/cli/tart"
)

DEVICES_SOFTWARES=(
    "logi-options-plus"
    "ankerwork"
)

FILE_SYSTEM_EXTENSION=(
    "macfuse"
)

if [ -z "$GIT_NAME" ]; then
  echo "Please provide your git name"
  exit 1
fi

if [ -z "$GIT_EMAIL" ]; then
  echo "Please provide your git email"
  exit 1
fi

# Xcode CLI
xcode-select --install 2>&1 | tee -a $LOG_FILE

# git config
git config --global user.name $GIT_NAME
git config --global user.email $GIT_EMAIL

(
    # homebrew
    echo '# Installing Homebrew'
    curl -s https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
    echo '# This loads homebrew' >> $HOME/.zprofile
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # dev languages
    echo '# Installing dev languages'
    brew install ${DEV_LANGUAGES[@]};

    echo "export NVM_DIR=\"\$HOME/.nvm\"" >> $HOME/.zprofile
    echo "[ -s \"/opt/homebrew/opt/nvm/nvm.sh\" ] && \. \"/opt/homebrew/opt/nvm/nvm.sh\"  # This loads nvm" >> $HOME/.zprofile
    echo "[ -s \"/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm\" ] && \. \"/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm\"  # This loads nvm bash_completion" >> $HOME/.zprofile
    source $HOME/.zprofile
    nvm install --lts;
    nvm use --lts;

    # dev tools
    echo '# Installing dev tools'
    brew install ${DEV_TOOLS[@]};

    # code editors
    echo '# Installing code editors'
    brew install ${CODE_EDITORS[@]};

    # softwares
    echo '# Installing softwares'
    brew install ${SOFTWARES[@]};

    # devices software
    echo '# Installing devices software'
    brew install ${DEVICES_SOFTWARES[@]};

    # file system extension
    echo '# Installing file system extension'
    brew install ${FILE_SYSTEM_EXTENSION[@]};
) 2>&1 | tee -a $LOG_FILE
