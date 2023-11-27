# FetchIP-RB

FetchIP-RB is a Ruby script that retrieves the user's public IP address and displays detailed information such as the Internet Service Provider (ISP), country, region, city, and the country's flag as an emoji. The script also detects the primary language of the country associated with the IP address and displays the information in that language, with a fallback to English if the language is not supported.

## Features

- Retrieves the user's public IP address.
- Displays detailed IP address information: ISP, country, region, city.
- Shows the country's flag as an emoji.
- Detects the primary language of the country and displays information in that language.
- Fallback to English if the language is not supported.

## Installation

A Python script is provided to facilitate the installation of Ruby on both Linux and macOS systems. This script automatically detects your operating system and installs Ruby using the appropriate method for your system.

### Steps to Use the Installation Script

1. Download the `installrb.py` script.
2. Run the script in your terminal:
    - On Linux: Use `sudo python3 installrb.py`.
    - On macOS: Simply run `python3 installrb.py`.
3. The script will install Ruby on your system.

## Dependencies

- Ruby
- Internet access for HTTP requests
- No external gems are required, as the script uses `net/http` and `json` included in Ruby's standard library.

## Usage

1. Ensure Ruby is installed on your system (use the installation script if needed).
2. Download the `fetchip-rb.rb` script.
3. Run the script in your terminal using the command `ruby fetchip-rb.rb`.
4. IP address information will appear in the terminal.

## License

This project is distributed under the MIT license, which means you are free to use, modify, and distribute it.

## Author

- Azx5G
