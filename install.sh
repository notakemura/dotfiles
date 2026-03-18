#!/bin/bash
DOTFILES_DIR="$HOME/dotfiles"

link_file() {
    local src=$1
    local dest=$2

    if [ -f "$dest" ] && [ ! -L "$dest" ]; then
        echo "Backing up $dest -> ${dest}.bak"
        mv "$dest" "${dest}.bak"
    fi

    ln -sf "$src" "$dest"
    echo "Linked $src -> $dest"
}

link_file "$DOTFILES_DIR/.bash_aliases" "$HOME/.bash_aliases"
link_file "$DOTFILES_DIR/.gitconfig_shared" "$HOME/.gitconfig_shared"

# .gitconfig に include がなければ追加
if ! grep -q "gitconfig_shared" "$HOME/.gitconfig" 2>/dev/null; then
    echo '[include]' >> "$HOME/.gitconfig"
    echo '    path = ~/.gitconfig_shared' >> "$HOME/.gitconfig"
    echo "Added include to .gitconfig"
fi

echo "✅ dotfiles installed!"
