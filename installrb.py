"""Install Ruby on Linux and macOS."""
"""License: AGPL-3.0"""
import subprocess, sys, platform, os

def is_root():
    return os.geteuid() == 0

def linux_distro():
    try:
        with open("/etc/os-release") as f:
            r = f.read().lower()
        if "debian" in r or "ubuntu" in r: return "debian"
        elif "fedora" in r: return "fedora"
        elif "arch" in r or "manjaro" in r: return "arch"
        elif "rhel" in r or "centos" in r: return "rhel"
        elif "suse" in r: return "opensuse"
    except: pass
    return "unknown"

def install_linux(d):
    c = {"debian": "sudo apt-get install -y ruby-full", "fedora": "sudo dnf install -y ruby",
         "arch": "sudo pacman -Sy ruby", "rhel": "sudo yum install -y ruby", "opensuse": "sudo zypper install -y ruby"}
    i = c.get(d, "")
    if i: subprocess.run(i, shell=True)
    else: print("No specific installation command is available for your distribution.")

def install_mac():
    if subprocess.run("command -v brew", shell=True, capture_output=True).returncode != 0:
        print("Error: Homebrew is not installed. Please install Homebrew and try again.")
        return
    subprocess.run("brew install ruby", shell=True)

if __name__ == "__main__":
    try:
        o = platform.system().lower()
        if o == "linux":
            if not is_root(): 
                print("Error: This script must be run with root or sudo privileges on Linux.")
            else:
                d = linux_distro()
                if d == "unknown": 
                    print("Unable to determine the Linux distribution. Please install Ruby manually.")
                else:
                    print(f"Installing Ruby on {d.capitalize()}.")
                    install_linux(d)
        elif o == "darwin":
            print("Installing Ruby on macOS.")
            install_mac()
        else:
            print("This script only supports Linux and macOS.")
    except Exception as e: 
        print(f"An error occurred during Ruby installation: {e}")
