"""Install Ruby on Linux and macOS."""
"""License: AGPL-3.0"""

import subprocess
import sys
import platform
import os

def is_user_root():
    """Check if the current user is root (UID 0)."""
    return os.geteuid() == 0

def identify_linux_distro():
    """Identify the Linux distribution."""
    try:
        with open("/etc/os-release", "r") as f:
            os_release = f.read().lower()
        if "debian" in os_release or "ubuntu" in os_release:
            return "debian"
        elif "fedora" in os_release:
            return "fedora"
        elif "arch" in os_release or "manjaro" in os_release:
            return "arch"
        elif "rhel" in os_release or "centos" in os_release:
            return "rhel"
        elif "suse" in os_release:
            return "opensuse"
    except FileNotFoundError:
        pass
    return "unknown"

def install_ruby_linux(distro):
    """Install Ruby on Linux."""
    commands = {
        "debian": "sudo apt-get install -y ruby-full",
        "fedora": "sudo dnf install -y ruby",
        "arch": "sudo pacman -Sy ruby",
        "rhel": "sudo yum install -y ruby",
        "opensuse": "sudo zypper install -y ruby"
    }

    install_cmd = commands.get(distro, "")
    if install_cmd:
        subprocess.run(install_cmd, shell=True)
    else:
        print("No specific installation command is available for your distribution.")

def install_ruby_macos():
    """Install Ruby on macOS."""
    # Check if Homebrew is installed
    brew_check = subprocess.run("command -v brew", shell=True, capture_output=True)
    if brew_check.returncode != 0:
        print("Error: Homebrew is not installed. Please install Homebrew and try again.")
        return

    # Install Ruby via Homebrew
    subprocess.run("brew install ruby", shell=True)

if __name__ == "__main__":
    try:
        os_name = platform.system().lower()
        if os_name == "linux":
            if not is_user_root():
                print("Error: This script must be run with root or sudo privileges on Linux.")
            else:
                distro = identify_linux_distro()
                if distro == "unknown":
                    print("Unable to determine the Linux distribution. Please install Ruby manually.")
                else:
                    print(f"Installing Ruby on {distro.capitalize()}.")
                    install_ruby_linux(distro)
        elif os_name == "darwin":
            print("Installing Ruby on macOS.")
            install_ruby_macos()
        else:
            print("This script only supports Linux and macOS.")
    except Exception as e:
        print(f"An error occurred during Ruby installation: {e}")

