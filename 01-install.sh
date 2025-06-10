#!/bin/bash

# 01-install.sh (for macOS)
# This script dynamically prepares the environment for audio transcription.

echo "--- Starting transcription environment setup on macOS ---"

# --- Step 1: Check for and install Homebrew ---
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    # Executes the Homebrew installation non-interactively
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi


# --- Step 2: Configure the Homebrew environment in .zprofile ---
# This is the MODIFIED section to dynamically use the user's directory

# Defines the path to the .zprofile file dynamically using $HOME
ZPROFILE_PATH="$HOME/.zprofile"
BREW_SHELLENV_CMD='eval "$(/opt/homebrew/bin/brew shellenv)"'

echo -e "\n--- Configuring the Homebrew environment in $ZPROFILE_PATH ---"

# Ensures the .zprofile file exists
touch "$ZPROFILE_PATH"

# Adds the Homebrew configuration ONLY if it doesn't already exist in the file
if ! grep -qF "$BREW_SHELLENV_CMD" "$ZPROFILE_PATH"; then
    echo "Adding the Homebrew environment to your Zsh profile..."
    echo "" >> "$ZPROFILE_PATH"
    echo "$BREW_SHELLENV_CMD" >> "$ZPROFILE_PATH"
else
    echo "The Homebrew environment is already configured in your profile."
fi

# Loads the Homebrew environment for the current terminal session
eval "$(/opt/homebrew/bin/brew shellenv)"


# --- Step 3: Install ffmpeg ---
echo -e "\n--- Checking for and installing ffmpeg ---"
if ! brew list ffmpeg &>/dev/null; then
    echo "Installing ffmpeg via Homebrew..."
    brew install ffmpeg
else
    echo "ffmpeg is already installed."
fi

# --- Step 4: Create a requirements.txt file ---
echo -e "\n--- Creating the requirements.txt file ---"
cat > requirements.txt << EOL
# Python libraries for the transcription project
transformers
torch
torchaudio
torchvision
accelerate
EOL
echo "requirements.txt file created successfully."

# --- Step 5: Install Python libraries ---
echo -e "\n--- Installing Python libraries via pip ---"
# We use --pre for PyTorch to get good support for MPS (Apple Silicon)
pip3 install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cpu
pip3 install -r requirements.txt

echo -e "\n\n--- ✅ Setup complete! ---"
echo "You can now run your Python transcription script."