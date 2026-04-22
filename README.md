# dotfiles

個人の設定ファイル（dotfiles）を管理するリポジトリ。

## 目的

各設定ファイルの仕組みを把握・記録しておくため。

---

## ファイル構成

```
dotfiles/
├── install.sh          # シンボリックリンクを貼るセットアップスクリプト
├── .bash_aliases       # Bashのエイリアス・関数・プロンプト設定
├── .gitconfig_shared   # Git エイリアス（include で読み込む）
├── .tmux.conf          # tmux 設定
└── .gitignore          # .bak ファイルを除外
```

---

## 各ファイルの仕組み

### `install.sh`

`~/dotfiles/` 内の各設定ファイルを、ホームディレクトリにシンボリックリンクとして貼るスクリプト。

**`link_file` 関数の動作：**
1. リンク先にすでに通常ファイルが存在する場合、`.bak` を末尾につけてリネームしてバックアップ
2. `ln -sf` でシンボリックリンクを作成（すでにリンクがある場合は上書き）

**`.gitconfig` のインクルード処理：**
- `~/.gitconfig` に `gitconfig_shared` の記述がなければ、`[include]` セクションを追記する
- 既に記述がある場合は何もしない（べき等）

**実行方法：**
```bash
bash ~/dotfiles/install.sh
```

---

### `.bash_aliases`

`~/.bashrc` から自動的に読み込まれる（Ubuntuなどのデフォルト設定）。

#### fzf キーバインド

```bash
[ -f /usr/share/doc/fzf/examples/key-bindings.bash ] && source ...
```

fzf のキーバインド設定ファイルが存在する場合だけ読み込む。ファイルがなくてもエラーにならない。

主なキーバインド（fzf 標準）：
- `Ctrl+r` : コマンド履歴をあいまい検索
- `Ctrl+t` : ファイルをあいまい検索してコマンドラインに挿入
- `Alt+c`  : ディレクトリをあいまい検索して `cd`

#### ナビゲーション系エイリアス

| エイリアス | 内容                                   |
| ---------- | -------------------------------------- |
| `..`       | `cd ..`                                |
| `...`      | `cd ../..`                             |
| `dev`      | `cd ~/dev`                             |
| `www`      | `cd /var/www`                          |
| `reload`   | `source ~/.bashrc`（設定を再読み込み） |

#### `cheat` 関数

よく忘れるコマンドをカテゴリ別に表示するチートシート関数。`case` 文で引数を分岐。

```bash
cheat disk   # ディスク関連コマンド
cheat vim    # Vim 操作
cheat tmux   # tmux 操作
```

#### プロンプト（PS1）

```bash
export GIT_PS1_SHOWDIRTYSTATE=1       # 変更あり → * 、ステージ済み → +
export GIT_PS1_SHOWUNTRACKEDFILES=1   # 未追跡ファイルあり → %
export PS1='...$(__git_ps1 " (%s)")...'
```

`__git_ps1` は `git` のソースに含まれるシェル関数（通常 `/usr/lib/git-core/git-sh-prompt` などで提供）。カレントディレクトリの Git ブランチ名と状態をプロンプトに表示する。

表示例：
```
user:~/dev/myapp (main *)$
```

---

### `.gitconfig_shared`

Git のエイリアス集。`~/.gitconfig` に直接書くのではなく、別ファイルに切り出して `include` で読み込む構成にしている。

**なぜ分けるか：**
- `~/.gitconfig` にはユーザー名やメールアドレスなどマシン固有の情報が含まれるため、リポジトリで管理したくない
- エイリアスだけをこのファイルに集約することで、複数マシン間で安全に共有できる

**`install.sh` との連携：**
`install.sh` が `~/.gitconfig` に以下を追記することで有効になる。

```ini
[include]
    path = ~/.gitconfig_shared
```

**定義されているエイリアス：**

| エイリアス | 内容                                        |
| ---------- | ------------------------------------------- |
| `git st`   | `status`                                    |
| `git co`   | `checkout`                                  |
| `git cob`  | `checkout -b`（ブランチ作成）               |
| `git br`   | `branch`                                    |
| `git lg`   | `log --oneline --graph --all`（グラフ表示） |
| `git last` | `log -1 HEAD`（直前のコミット確認）         |
| `git cp`   | `cherry-pick`                               |
| `git d`    | `diff`                                      |
| `git dc`   | `diff --cached`（ステージ済みの差分）       |
| `git bl`   | `blame`                                     |
| `git bll`  | `blame -L`（行範囲指定 blame）              |
| `git sh`   | `show`                                      |

---

### `.tmux.conf`

#### マウス操作の有効化

```
set -g mouse on
```

マウスでペインのリサイズ、クリックによるフォーカス移動、スクロールが可能になる。

#### 全ペイン同期トグル（`Ctrl+b s`）

```
bind s setw synchronize-panes \; display "sync: #{?pane_synchronized,ON,OFF}"
```

`Ctrl+b s` で `synchronize-panes` を ON/OFF 切り替える。ON にすると、同じウィンドウ内の全ペインに同じキー入力が送られる。複数サーバーに同じコマンドを打ちたいときに便利。

`#{?pane_synchronized,ON,OFF}` は tmux のフォーマット構文で、条件が真なら `ON`、偽なら `OFF` を表示する。

---

### `.gitignore`

```
*.bak
```

`install.sh` が生成する `.bak` ファイルをリポジトリの追跡対象から除外する。

---

## セットアップ手順

```bash
# 1. リポジトリをクローン
git clone <リポジトリURL> ~/dotfiles

# 2. セットアップスクリプトを実行
bash ~/dotfiles/install.sh

# 3. シェルを再読み込み
source ~/.bashrc
```
