#!/bin/bash

set -e

echo "🚀 Starting dotfiles setup..."

# Homebrewのインストールチェック
if ! command -v brew &> /dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    echo "⚙️  Setting up Homebrew PATH..."
    echo >> ~/.zprofile
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "✅ Homebrew is already installed"
fi

# パッケージのインストール
echo "📦 Installing packages from Brewfile..."
brew bundle --file=~/dotfiles/Brewfile

# シンボリックリンクの作成
echo "🔗 Creating symbolic links..."

# バックアップディレクトリの作成
BACKUP_DIR=~/dotfiles_backup_$(date +%Y%m%d_%H%M%S)
mkdir -p "$BACKUP_DIR"

# 既存ファイルがある場合はバックアップ
if [ -f ~/.zshrc ]; then
    echo "📋 Backing up existing .zshrc to $BACKUP_DIR"
    cp ~/.zshrc "$BACKUP_DIR/.zshrc"
fi

if [ -f ~/.gitconfig ]; then
    echo "📋 Backing up existing .gitconfig to $BACKUP_DIR"
    cp ~/.gitconfig "$BACKUP_DIR/.gitconfig"
fi

# シンボリックリンクを作成
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig

echo ""
echo "✨ Setup completed!"
echo ""
echo "📝 Next steps:"
echo "  1. Edit ~/.gitconfig to add your name and email"
echo "  2. Run 'source ~/.zshrc' to apply changes"
echo "  3. (Optional) Import dictionary backup if you have one"
echo ""
