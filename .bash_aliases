# fzf keybindings
[ -f /usr/share/doc/fzf/examples/key-bindings.bash ] && source /usr/share/doc/fzf/examples/key-bindings.bash

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias dev='cd ~/dev'
alias www='cd /var/www'

# reload shell config
alias reload='source ~/.bashrc'

# cheatsheet
cheat() {
    case "$1" in
        disk)
            cat << 'EOF'
=== Disk / Storage ===
df -h                  ディスク全体の使用量を見やすく表示
du -skm */             カレント配下の各ディレクトリのサイズ(MB)
du -skm /path/to/dir   指定ディレクトリのサイズ(MB)
EOF
            ;;
        vim)
            cat << 'EOF'
=== Vim: カーソル移動 ===
gg         ファイル先頭へ
G          ファイル末尾へ
0          行頭へ
$          行末へ
w          次の単語へ

=== Vim: 検索 ===
/pattern   前方検索（Enterで確定）
?pattern   後方検索（Enterで確定）
n          次の検索結果へ
N          前の検索結果へ

=== Vim: 選択 ===
v          文字単位で選択開始
V          行単位で選択開始
ggVG       ファイル全体を選択
V → j/k    行選択を上下に広げる
v → iw     カーソル位置の単語を選択

=== Vim: 編集 ===
o          下に新しい行を作ってinsert mode
O          上に新しい行を作ってinsert mode
x          カーソル位置の1文字を削除
y          選択範囲をコピー
yy         1行まるごとコピー
d          選択範囲を削除（切り取り）
p          カーソルの後ろに貼り付け
P          カーソルの前に貼り付け
u          元に戻す（undo）
Ctrl+r     やり直す（redo）
EOF
            ;;
        *)
            echo "Usage: cheat [disk|vim]"
            echo "Available: disk, vim"
            ;;
    esac
}

# prompt with git branch (using built-in __git_ps1)
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export PS1='\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\]$(__git_ps1 " (%s)")\[\033[00m\]\$ '
