#!/bin/bash
set -e

echo "🚀 Cloning ohmyzsh-dotfiles from GitHub..."
git clone https://github.com/justrunme/ohmyzsh-dotfiles.git ~/ohmyzsh-dotfiles || echo "✅ Репозиторий уже склонирован"

echo "📦 Installing dependencies..."
sudo apt update && sudo apt install -y \
    zsh git curl wget fonts-powerline locales

echo "🎨 Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "✅ Oh My Zsh уже установлен"
fi

echo "⚡ Installing Powerlevel10k..."
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

echo "📁 Copying .zshrc and .p10k.zsh configs..."
cp ~/ohmyzsh-dotfiles/.zshrc ~/
cp ~/ohmyzsh-dotfiles/.p10k.zsh ~/

echo "🔌 Installing DevOps plugins..."
mkdir -p ~/.oh-my-zsh/custom/plugins
cp -r ~/ohmyzsh-dotfiles/plugins/* ~/.oh-my-zsh/custom/plugins/

echo "🧠 Setting ZSH as default shell..."
chsh -s $(which zsh)

echo "✅ Done! Launching zsh..."
exec zsh
