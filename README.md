 # Cerberus

 **Cerberus** is a file and directory deletion tool that securely wipes files using the DoD 5220.22-M method. It offers two interfaces: a command-line application and a graphical user interface (GUI) using Shoes.

 ## Features

 - **Secure File Deletion**: Wipes files with the DoD 5220.22-M pattern (3 passes: zeros, ones, and random data).
 - **Progress Bar**: Tracks progress based on the size of the files being deleted.
 - **Terminal Version**: Command-line interface for deleting files and directories.
 - **GUI Version**: Shoes-based graphical interface for easier interaction.

 ## Installation

 1. **Install Ruby**: Make sure Ruby is installed on your system. You can download it from [Ruby's official website](https://www.ruby-lang.org/en/downloads/).

 2. **Install Required Gems**:
    - For the GUI version: 
      ```
      gem install shoes --pre
      ```
    - For the terminal version:
      ```
      gem install ruby-progressbar
      ```

 3. **Clone the Repository**:
    ```
    https://github.com/equinox-01/cerberus
    cd cerberus
    ```

 ## Usage

 ### Terminal Version

 1. **Run the Terminal App**:
    ```
    ruby cerberus.rb
    ```

 2. **Input Paths**: Enter the paths of the files and directories you want to delete when prompted. Paths should be comma-separated.

 3. **Progress Bar**: The terminal will show a progress bar indicating the deletion progress based on the total size of the files.

 ### GUI Version

 1. **Run the GUI App**:
    ```
    shoes cerberus_gui.rb
    ```

 2. **Select Files or Folders**:
    - Click "Add File" or "Add Folder" to choose files or directories for deletion.
    - You can view selected files and navigate through them with "Previous" and "Next" buttons.

 3. **Confirm Deletion**:
    - Click "Confirm Deletion" to start the deletion process.
    - The GUI will show progress as files are deleted and provide status updates.

 ## Code Structure

 - **`deletion.rb`**: Contains the core logic for securely deleting files and directories using the DoD 5220.22-M method.
 - **`cerberus.rb`**: Terminal-based application to handle file deletion with a progress bar.
 - **`cerberus_gui.rb`**: GUI-based application using Shoes for selecting and deleting files.

 ## Example

 ### Terminal App

 ```
 ruby cerberus.rb
 ```

 ```
 Enter paths to delete (comma separated):
 /path/to/file1, /path/to/file2
 ```

 ### GUI App

 ```
 shoes cerberus_gui.rb
 ```

 - Select files or folders to delete using the provided buttons.
 - Confirm deletion to start the process with progress updates shown in the GUI.
