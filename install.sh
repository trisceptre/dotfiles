#!/bin/bash

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

DOT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

packages=(
    alacritty
    fastfetch
    hypridle
    hyprlock
    libnotify
    niri
    noctalia
    noto-fonts
    noto-fonts-emoji
    oo7
    pipewire-pulse
    starship
    ttf-jetbrains-mono-nerd
    ttf-sarasa-gothic
    vicinae
    wallust
    wireplumber
    xdg-desktop-portal-gnome
    xwayland-satellite
    zsh-autosuggestions
    zsh-syntax-highlighting
)

if command -v paru &> /dev/null; then
    AUR_HELPER="paru"
elif command -v yay &> /dev/null; then
    AUR_HELPER="yay"
else
    echo "No AUR helper found. Please install paru or yay first."
    exit 1
fi

$AUR_HELPER -S --needed --noconfirm "${packages[@]}"

if ! grep -q pam_oo7 /etc/pam.d/login; then
    sudo sed -i \
        -e '/^auth[[:space:]]\+include[[:space:]]\+system-local-login/a auth        optional    pam_oo7.so' \
        -e '/^session[[:space:]]\+include[[:space:]]\+system-local-login/a session     optional    pam_oo7.so auto_start' \
        /etc/pam.d/login
    grep -q pam_oo7 /etc/pam.d/login || echo "WARNING: /etc/pam.d/login layout unexpected, add pam_oo7.so lines by hand"
fi
systemctl --user enable oo7-daemon.service

ln -sf "$DOT_DIR/.zshrc"    "$HOME/.zshrc"
ln -sf "$DOT_DIR/.zprofile" "$HOME/.zprofile"
ln -sf "$DOT_DIR/starship.toml" "$HOME/.config/starship.toml"

touch "$HOME/.zsh_history"

chmod 600 "$HOME/.zsh_history"
chmod 600 "$HOME/.zshrc"
chmod 600 "$HOME/.zprofile"

mkdir -p "$HOME/.config"
configs=(alacritty fastfetch fontconfig hypr mpv niri noctalia vicinae wallust yazi zsh)

for folder in "${configs[@]}"; do
    ln -snf "$DOT_DIR/$folder" "$HOME/.config/$folder"
done

ln -snf "$DOT_DIR/wallpapers" "$HOME/Pictures/Wallpapers"

git -C "$DOT_DIR" config filter.scrubhome.clean 'sed "s|$HOME/|~/|g"'

NOCTALIA_STATE="$HOME/.local/state/noctalia"
mkdir -p "$NOCTALIA_STATE"
if [ -f "$NOCTALIA_STATE/settings.toml" ] && [ ! -L "$NOCTALIA_STATE/settings.toml" ]; then
    mv "$NOCTALIA_STATE/settings.toml" "$NOCTALIA_STATE/settings.toml.bak.$(date +%s)"
fi
ln -snf "$DOT_DIR/noctalia/settings.toml" "$NOCTALIA_STATE/settings.toml"

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

if [ "$SHELL" != "/usr/bin/zsh" ]; then
    sudo chsh -s /usr/bin/zsh "$USER"
fi

wallust run "$DOT_DIR/wallpapers/blackhole.jpg"
