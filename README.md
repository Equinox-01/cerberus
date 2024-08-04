# Cerberus

**Cerberus** is a tool for securely deleting files and directories using the DoD 5220.22-M method. It offersa command-line application.

## Features

- **Secure File Deletion**: Wipes files using the DoD 5220.22-M pattern (3 passes: zeros, ones, and random data).
- **Command-Line Interface**: Simple interface for deleting files and directories.

## Installation

1. **Install Ruby**: Make sure Ruby is installed on your system. You can download it from [Ruby's official website](https://www.ruby-lang.org/en/downloads/).

2. **Install Required Gems**:
      ```sh
      gem install concurrent-ruby
      ```

3. **Clone the Repository**:
    ```sh
    git clone https://github.com/equinox-01/cerberus
    cd cerberus
    ```

## Usage


1. **Run the Terminal App**:
    ```sh
    ruby cerberus.rb path/to/file1 path/to/file2 path/to/directory
    ```

2. **Example**:
    ```sh
    ruby cerberus.rb file1.txt file2.txt /path/to/directory
    ```

## Code Structure

- **`secure_file_eraser.rb`**: Contains the core logic for securely deleting files and directories.
- **`cerberus.rb`**: Command-line application for handling file and directory deletion.

## Example

```sh
ruby cerberus.rb file1.txt file2.txt /path/to/directory
