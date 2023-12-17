"""Install Ruby on Linux and macOS."""
"""License: AGPL-3.0"""
import subprocess, sys, platform, os

is_root = lambda: os.geteuid() == 0
linux_distro = lambda: next((dist for dist in ["debian", "fedora", "arch", "rhel", "opensuse"] if dist in open("/etc/os-release").read().lower()), "unknown")
install_linux = lambda d: subprocess.run({"debian": "sudo apt-get install -y ruby-full", "fedora": "sudo dnf install -y ruby", "arch": "sudo pacman -Sy ruby", "rhel": "sudo yum install -y ruby", "opensuse": "sudo zypper install -y ruby"}.get(d, "echo 'No specific installation command for your distribution.'"), shell=True)
install_mac = lambda: subprocess.run("brew install ruby" if not subprocess.run("command -v brew", shell=True, capture_output=True).returncode else "echo 'Error: Homebrew is not installed. Install Homebrew and retry.'", shell=True)

if __name__ == "__main__":
    try:
        o = platform.system().lower()
        print("Error: Run with root or sudo privileges on Linux." if not is_root() else ("Installing Ruby on " + (d := linux_distro()).capitalize() if d != "unknown" else "Unable to determine Linux distribution. Install Ruby manually."), install_linux(d) if is_root() and d != "unknown" else None) if o == "linux" else (print("Installing Ruby on macOS.", install_mac()) if o == "darwin" else print("Only supports Linux and macOS."))
    except Exception as e: print(f"Error during Ruby installation: {e}")

