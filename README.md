# Cerberus

**Cerberus** is a tool for securely deleting files and directories using the DoD 5220.22-M method. It offers two interfaces: a command-line application and a graphical user interface (GUI) using Shoes.

## Features

- **Secure File Deletion**: Wipes files using the DoD 5220.22-M pattern (3 passes: zeros, ones, and random data).
- **Command-Line Interface**: Simple interface for deleting files and directories.
- **Graphical User Interface**: Shoes-based GUI for easier interaction.

## Installation

1. **Install Ruby**: Make sure Ruby is installed on your system. You can download it from [Ruby's official website](https://www.ruby-lang.org/en/downloads/).

2. **Install Required Gems**:
    - For the GUI version:
      ```sh
      gem install shoes --pre
      ```
    - For the terminal version:
      ```sh
      gem install concurrent-ruby
      ```

3. **Clone the Repository**:
    ```sh
    git clone https://github.com/equinox-01/cerberus
    cd cerberus
    ```

## Usage

### Command-Line Version

1. **Run the Terminal App**:
    ```sh
    ruby cerberus.rb path/to/file1 path/to/file2 path/to/directory
    ```

2. **Example**:
    ```sh
    ruby cerberus.rb file1.txt file2.txt /path/to/directory
    ```

### GUI Version

1. **Run the GUI App**:
    ```sh
    ruby cerberus_gui.rb
    ```

2. **Select Files or Folders**:
    - Click "Select Files" to choose files or directories for deletion.
    - The selected files will be displayed in the interface.

3. **Confirm Deletion**:
    - Click "Erase Files" to start the deletion process.
    - The GUI will show progress and status updates.

## Code Structure

- **`secure_file_eraser.rb`**: Contains the core logic for securely deleting files and directories.
- **`cerberus.rb`**: Command-line application for handling file and directory deletion.
- **`cerberus_gui.rb`**: Shoes-based GUI application for selecting and deleting files.

## Example

### Terminal App

```sh
ruby cerberus.rb file1.txt file2.txt /path/to/directory
