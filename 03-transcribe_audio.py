import torch
from transformers import pipeline
import os
import datetime
import argparse # Import the library for command-line arguments

# --- SECURITY NOTE ---
# Recent versions of the `transformers` library prioritize the secure
# `.safetensors` format by default, which this script uses.

def transcribe_and_save(audio_file_path, output_file_path):
    """
    Transcribes an audio file and saves the result to the specified path.

    Args:
        audio_file_path (str): The path to the input audio file.
        output_file_path (str): The path to the output text file.

    Returns:
        str: The path to the saved text file on success,
             or an error message on failure.
    """
    if not os.path.isfile(audio_file_path):
        return f"Error: Audio file not found at '{audio_file_path}'."

    try:
        if torch.backends.mps.is_available():
            device = "mps"
            print("INFO: Using Apple GPU (MPS) for acceleration.")
        elif torch.cuda.is_available():
            device = "cuda:0"
            print("INFO: Using Nvidia GPU (CUDA) for acceleration.")
        else:
            device = "cpu"
            print("INFO: Using CPU.")

        print("\nINFO: Loading the 'whisper-base' model. This may take a moment on the first run...")
        transcriber = pipeline(
            "automatic-speech-recognition",
            model="openai/whisper-base",
            device=device
        )

        print(f"\nTranscribing '{os.path.basename(audio_file_path)}'...")
        result = transcriber(
            audio_file_path,
            chunk_length_s=30,
            return_timestamps=True
        )
        transcribed_text = result["text"].strip()
        print("INFO: Transcription complete.")

        # --- MODIFICATION TO USE THE SPECIFIED OUTPUT PATH ---
        # Ensure the destination directory for the output file exists.
        output_directory = os.path.dirname(output_file_path)
        # If the path is just a filename, the dirname will be empty.
        # In that case, we don't need to create any directories.
        if output_directory:
            os.makedirs(output_directory, exist_ok=True)

        # Save the transcribed text to the file specified by the user.
        with open(output_file_path, 'w', encoding='utf-8') as f:
            f.write(f"Transcription of file: {os.path.basename(audio_file_path)}\n")
            f.write(f"Transcription date: {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
            f.write("="*40 + "\n\n")
            f.write(transcribed_text)
        # -----------------------------------------------------------

        return output_file_path

    except Exception as e:
        return f"An unexpected error occurred during transcription: {e}"


# --- Main execution block ---
if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Transcribes an audio file to a specified text file."
    )
    # Argument 1: Input file
    parser.add_argument(
        "audio_file_path",
        type=str,
        help="The full path to the audio file to be transcribed."
    )
    # Argument 2: Output file
    parser.add_argument(
        "output_file_path",
        type=str,
        help="The full path where the transcribed text file will be saved."
    )
    args = parser.parse_args()

    # Call the main function with the two arguments provided by the user
    final_result = transcribe_and_save(args.audio_file_path, args.output_file_path)

    if final_result.startswith("Error:"):
        print(f"\n{final_result}")
    else:
        print("\n" + "="*50)
        print("✅ SUCCESS!")
        print(f"The transcription was successfully saved to:")
        print(f"{final_result}")
        print("="*50)