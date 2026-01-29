# Elegant SDDM Theme for Arch Linux

![Modern Design](elegant-archlinux/Screenshots/modern.png)

Originally released in 2016, I have completely modernized **Elegant Arch Linux** SDDM theme to meet today's standards while keeping the classic elegance you love.

Rebuilt from the ground up with **Qt 6**, it is now faster and smoother. Whether you are on a standard laptop or a HiDPI monitor, it scales perfectly.

## Features

-   **Clean & Modern**: Minimalist aesthetics with a glass-morphism inspired panel.
-   **High DPI Ready**: I made everything scalable, so it looks crisp on any screen.
-   **Qt 6 Powered**: Built using modern QtQuick modules.
-   **Modular Design**: Structured neatly so you can easily tweak it.
-   **Dynamic Welcome**: Displays your system hostname (e.g., "Welcome to Arch").

## Installation

### One-Line Install (Interactive)

This script will automatically detect your distribution, install dependencies, and let you **choose your preferred Blur Strength** (None, Medium, or Strong) before activating the theme.

Run this command on **Arch Linux, Fedora, Ubuntu/Debian, or openSUSE**:
```bash
curl -sSL https://raw.githubusercontent.com/sniper1720/elegant-sddm-archlinux-theme/main/install.sh | sudo bash
```

### Install via AUR (Arcn Linux)

You can easily install this theme from the AUR using your favorite helper (e.g., `yay` or `paru`):

```bash
yay -S sddm-theme-elegant-archlinux-git
```
*Note: After installing from AUR, run `sudo /usr/share/sddm/themes/elegant-archlinux/customize.sh` to customize and activate it!*

### Install via KDE System Settings

If you are using KDE Plasma, you can install it directly from the UI:
1. Go to **System Settings** > **Login Screen (SDDM)**.
2. Click **"Get New SDDM Themes..."**.
3. Search for **"Elegant Arch Linux"**.
4. Click **Install**.


### Manual Installation

Getting this set up is super easy. Just follow these steps:

1.  **Clone the repo** to your machine:
    ```bash
    git clone https://github.com/sniper1720/elegant-sddm-archlinux-theme.git
    cd elegant-sddm-archlinux-theme
    ```

2.  **Move the theme folder** to where SDDM expects it:
    ```bash
    sudo cp -r elegant-archlinux /usr/share/sddm/themes/
    ```

3.  **Activate it!**
    Open (or create) `/etc/sddm.conf.d/theme.conf` and add:
    ```ini
    [Theme]
    Current=elegant-archlinux
    ```

    *Tip: You can test how it looks without logging out:*
    ```bash
    sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/elegant-archlinux
    ```

## Customization

You can customize the theme at any time (even after installation) by running the helper script.

**To change Blur Strength:**
1.  Navigate to the theme directory: `/usr/share/sddm/themes/elegant-archlinux/`
2.  Run the customizer:
    ```bash
    sudo ./customize.sh
    ```
3.  Follow the on-screen prompts.

Alternatively, you can manually edit the configuration file:
`/usr/share/sddm/themes/elegant-archlinux/theme.conf.user`

### Manual Options

Add your overrides under the `[General]` section:

```ini
[General]
# Change your wallpaper (Provide absolute path)
background=/path/to/your/custom/wallpaper.jpg

# Adjust Background Blur Strength
# Options: 0.0 (None), 0.5 (Medium), 1.0 (Strong/Default)
BlurStrength=1.0
```

*Note: The "Change Background" button in KDE System Settings is also fully supported!*


## Dependencies

Make sure you have these packages installed (you probably fit the requirements already if you're on Arch):

-   `sddm`
-   `qt6-base`
-   `qt6-declarative`
-   `qt6-svg`

## ❤️ Support the Project

If you find this theme helpful, there are many ways to support the project:

### Financial Support
If you'd like to support the development financially:

<a href="https://www.buymeacoffee.com/linuxtechmore"><img src="https://img.shields.io/badge/Fuel%20the%20next%20commit-f1fa8c?style=for-the-badge&logo=buy-me-a-coffee&logoColor=282a36" height="42" /></a>
<a href="https://github.com/sponsors/sniper1720"><img src="https://img.shields.io/badge/Become%20a%20Sponsor-bd93f9?style=for-the-badge&logo=github&logoColor=white" height="42" /></a>
<br><br>

<div align="center">
  <h3>Bitcoin (BTC) Support</h3>
  <img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=1ALZQ6F2CkjQMP8rJrUnXgfVdWwbc6RPYu" alt="BTC QR Code" width="150" />
  <p><code>1ALZQ6F2CkjQMP8rJrUnXgfVdWwbc6RPYu</code></p>
</div>

### Contribute & Support
Financial contributions are not the only way to help! Here are other options:
- **Star the Repository**: It helps more people find the project!
- **Report Bugs**: Found an issue? Open a ticket on GitHub.
- **Suggest Features**: Have a cool idea? Let me know!
- **Share**: Tell your friends!

Every bit of support helps keep the project alive and ensures I can spend more time developing open source tools for the Linux community!

## Credits

This project wouldn't be possible without the community.

-   **Inspiration**: Inspired by the work of Guidobelix.
-   **Built by**: Djalel (sniper1720).

## License

This project is licensed under the **Creative Commons Attribution-ShareAlike 3.0 (CC-BY-SA 3.0)**. Feel free to share and adapt it! See the [LICENSE](elegant-archlinux/LICENSE) file for more details.
