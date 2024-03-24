# My Wezterm config file

 ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
 ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
 ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
 ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
 ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
 A GPU-accelerated cross-platform terminal emulator
 [Wezterm](https://wezfurlong.org/wezterm/)

## Install Wezterm Nightly

### Mac

Use [Homebrew](https://brew.sh/) to install Wezterm.

```bash
brew tap homebrew/cask-versions
brew install --cask wezterm-nightly
```

Upgrade

```bash
brew upgrade --cask wezterm-nightly --no-quarantine --greedy-latest
```

### Windows

Use [Choco](https://chocolatey.org/) to install Wezterm.

```powershell
choco install wezterm
```

## Configuration

### Mac

```bash
git clone https://github.com/joncrangle/wezterm.git "${XDG_CONFIG_HOME:-$HOME/.config}"/wezterm
```

### Windows

```powershell
git clone https://github.com/joncrangle/wezterm.git $env:USERPROFILE\AppData\Local\wezterm\
```
