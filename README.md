
# Audio Transcription Project with Whisper

This project provides a set of scripts to extract audio from video files and transcribe it into text using OpenAI's `whisper-base` model. The workflow is optimized for macOS and utilizes hardware acceleration (Apple GPU via MPS or Nvidia via CUDA), if available.

PS: this project was created by using Gemini (2.5 Pro preview)
---

## Features

-   **Automated Installation**: An installation script to set up the environment on macOS, including Homebrew, FFmpeg, and the necessary Python libraries.
-   **Audio Extraction**: A script to extract the audio track from any video file using FFmpeg.
-   **AI-Powered Transcription**: A Python script that uses the Hugging Face `transformers` library and the `whisper-base` model to perform transcription.
-   **Hardware Acceleration**: Automatically detects and uses the available Apple GPU (MPS) or Nvidia GPU (CUDA) to speed up the transcription process, falling back to the CPU if no GPU is found.
-   **Formatted Output**: The transcribed text is saved to a text file with the date/time and the name of the source file.

---

## Prerequisites

Before you begin, ensure you are on a macOS environment with the following tools installed:

-   [Python 3](https://www.python.org/)
-   [pip](https://pip.pypa.io/en/stable/installation/)
-   Internet access to download dependencies.

---

## ⚙️ Installation and Setup

To prepare your environment, run the installation script. It will install Homebrew (if necessary), FFmpeg, and the required Python libraries (`torch`, `transformers`, etc.).

Open your terminal and run the following command:

```bash
chmod +x 01-install.sh
./01-install.sh
```

The script will:
1.  Check for and install **Homebrew**.
2.  Configure the Homebrew environment in your Zsh profile (`.zprofile`).
3.  Install **FFmpeg**.
4.  Install all necessary Python libraries via `pip`.

---

## 🚀 How to Use

The process is divided into two main steps: audio extraction and transcription.

### Step 1: Extract Audio from Video

Use the `02-extract_audio.sh` script to extract the audio from a video file. It requires the path to the input video and the path for the output audio file.

Make the script executable and run it:

```bash
chmod +x 02-extract_audio.sh
./02-extract_audio.sh /path/to/your/video.mp4 /path/to/save/audio.mp3
```

**Example:**

```bash
./02-extract_audio.sh ./videos/my-meeting.mov ./audio/meeting-audio.mp3
```

If the command is successful, you will see a success message, and the `meeting-audio.mp3` file will be created in the `audio` directory.

### Step 2: Transcribe the Audio File

After extracting the audio, use the `03-transcribe_audio.py` script to generate the transcription. It requires the path to the input audio file and the path for the output text file.

Run the script as follows:

```bash
python3 03-transcribe_audio.py /path/to/your/audio.mp3 /path/to/save/transcription.txt
```

**Example:**

```bash
python3 03-transcribe_audio.py ./audio/meeting-audio.mp3 ./transcriptions/meeting-transcribed.txt
```

The script will load the `whisper-base` model (which may take a moment on the first run) and perform the transcription. At the end, it will save the text to the specified file.

---

## 📜 Script Details

### `01-install.sh`

This script prepares the entire necessary environment on macOS. It is idempotent, meaning it can be run multiple times without causing issues. If a dependency is already installed (like Homebrew or FFmpeg), the script will skip its installation.

### `02-extract_audio.sh`

A command-line utility that uses FFmpeg to extract the audio track from a video file. It is designed with error checking to ensure the input and output file paths are provided correctly.

### `03-transcribe_audio.py`

The core of the project. This Python script:
-   Accepts an audio file and an output path as command-line arguments.
-   Detects and utilizes the best available acceleration technology (`mps`, `cuda`, or `cpu`).
-   Loads the `openai/whisper-base` model from Hugging Face.
-   Transcribes the audio and saves the transcription to a formatted text file.
-   Uses the secure `.safetensors` format by default.

## 🛡️ Security and Privacy

This project is designed to run entirely on your local machine.

* **Local Execution**: All scripts, from audio extraction to transcription, run on your computer.
* **Private Data**: Your audio files and the generated transcriptions are never sent to the cloud or external servers.
* **No Retraining**: Your data is not used to retrain or improve the AI model. The script uses a local instance of the `openai/whisper-base` model to perform the transcription.
* **Secure Format**: The transcription script prioritizes using the secure `.safetensors` format by default when loading the model.