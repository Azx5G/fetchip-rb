[![StandWithPalestine](https://github.com/Safouene1/support-palestine-banner/blob/master/StandWithPalestine.svg)](https://github.com/Safouene1/support-palestine-banner)

# FetchIP-RB

FetchIP-RB is a Ruby script that retrieves the user's public, local IP address and displays detailed information such as the Internet Service Provider (ISP), country, region, city, and the country's flag as an emoji. The script also detects the primary language of the country associated with the IP address and displays the information in that language, with a fallback to English if the language is not supported. And now detects the computer's operating system and the version.

## Features

- Retrieves the user's local/public IP address. (IPv4 Only IPv6 support coming soon)
- Displays detailed IP address information: ISP, country, region, city.
- Shows the country's flag as an emoji. (e.g. 🇫🇷 for France - Not supported on Windows)
- Detects the primary language of the country and displays information in that language. (only supports English, French, Spanish, Russian, Arabic and Chinese)
- Fallback to English if the language is not supported.
- Detects the computer's operating system and the version.

## Installation

A Python script is provided to facilitate the installation of Ruby on both Linux and macOS systems. This script automatically detects your operating system and installs Ruby using the appropriate method for your system.
WARNING: This script does not work on Windows systems. Please follow the instructions below to install Ruby on Windows.

### Steps to Use the Installation Script (macOS and Linux)

1. Download the `installrb.py` script.
2. Run the script in your terminal:
    - On Linux: Use `sudo python3 installrb.py`.
    - On macOS: Simply run `python3 installrb.py`.
3. The script will install Ruby on your system.
4. Proceed to the [Usage](#usage) section.

### Windows

1. Download and install Ruby from the [RubyInstaller for Windows website](https://rubyinstaller.org/downloads/).
2. Follow the instructions on the website to install Ruby.
3. Proceed to the [Usage](#usage) section.

## Dependencies

- Ruby
- Python 3 (only for the installation script/not required for the main script)

## Usage

1. Ensure Ruby is installed on your system (use the installation script if needed). And you are connected to the Internet.
2. Download the `fetchip-rb.rb` script.
3. Run the script in your terminal using the command `ruby fetchip-rb.rb`.
4. Informations will appear in the terminal.

## License

This project is distributed under the GNU Affero General Public License version 3.0 (AGPL-3.0). This license requires that any modifications and larger works based on this project must also be released under the same license. Additionally, if you run a modified version of this software in a network server or provide access to it to others in any way, you must also make the source code available under this license. 

## Author

- Azx5G
