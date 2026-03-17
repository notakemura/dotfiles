#!/bin/bash
DOTFILES_DIR="$HOME/dotfiles"

# バックアップしてからシンボリックリンクを作る関数
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

# ここに管理したいファイルを追加していく
link_file "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"

echo "✅ dotfiles installed!"
