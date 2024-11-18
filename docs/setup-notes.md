# setup notes

a record of my setup process each time I go through a computer reset, so as to imporove and expedite the time-to-coding each time

## 20231126-setup

### references

- [Managing Multiple Python Versions With pyenv – Real Python](https://realpython.com/intro-to-pyenv/)
- [macos - Linking pyenv python to homebrew in order to avoid homebrew python@3.8 installation - Stack Overflow](https://stackoverflow.com/questions/62249443/linking-pyenv-python-to-homebrew-in-order-to-avoid-homebrew-python3-8-installat)

## 20231221-willcasswrig

### reset notes

```bash
$system_profiler SPHardwareDataType

Hardware:

    Hardware Overview:

      Model Name: MacBook Pro
      Model Identifier: MacBookPro16,2
      Processor Name: Quad-Core Intel Core i7
      Processor Speed: 2.3 GHz
      Number of Processors: 1
      Total Number of Cores: 4
      L2 Cache (per Core): 512 KB
      L3 Cache: 8 MB
      Hyper-Threading Technology: Enabled
      Memory: 16 GB
      System Firmware Version: 1968.120.12.0.0 (iBridge: 20.16.5060.0.0,0)
      OS Loader Version: 577~170
      Serial Number (system): ...ML85
```

### Browser setup

```bash
brew install brave
```

- settings/ search: 'save for later' / set to false
   	- credit cards, addresses, passwords
- extensions
   	- dark viewer
   	- bitwarden
   	- rescuetime
   	- tab sorter
   	- tabs to clipboard
   	- tracking extension
   	- duckduckgo
   	- ublock origin
   	- wayback machine
   	- wappalyzer

### Brew

```bash
$brew list | column -t
## Formulae
ack
# act
# autoconf
# automake
bash
bat
# berkeley-db
# binutils
blueutil
# brotli
# c-ares
# ca-certificates
# cffi
# coreutils
# direnv
# docutils
# fd
# fzf
# gdbm
# gettext
gh
git
glow
# gmp
go
grep
htop
hugo
# icu4c
# iproute2mac
jq
# krb5
# ldns
# libcbor
# libevent
# libfido2
# libgit2
# libgit2@1.6
# libgpg-error
# libidn2
# libksba
# liblinear
# libnghttp2
# libsodium
# libssh2
# libtool
# libunistring
# libuv
# libyaml
# llvm
# llvm@16
# lua
# lua@5.3
# lz4
# m4
make
mods
# mpdecimal
# ncurses
nginx
nmap
node
# oniguruma
openssh
# openssl@1.1
# openssl@3
# pandoc
# pcre
# pcre2
# perl
pipx
# pkg-config
# postgresql@14
pre-commit
# pycparser
pyenv
# python-argcomplete
# python-certifi
# python-cryptography
# python-distlib
# python-filelock
# python-packaging
# python-platformdirs
# python-setuptools
# python@3.11
# python@3.12
# python@3.8
# pyyaml
# readline
# ripgrep
# ruby
# rust
# shc
# shellcheck
# six
# speedtest-cli
# sqlite
# tcl-tk
# terraform
thefuck
tig
# transmission-cli
tree
vim
# virtualenv
# wget
# xidel
# xmlstarlet
# xz
# z3
# zeromq
# zlib
# zsh
zsh-autosuggestions
zsh-syntax-highlighting
# zstd

## Casks
docker
# google-chrome
# google-cloud-sdk
iterm2
# lulu
# macdown
# michaelvillar-timer
# microsoft-auto-update
# microsoft-excel
# microsoft-word
# postico
rar
rectangle
rescuetime
# slack
# snowflake-snowsql
# soapui
spotify
sublime-text
transmission
# visual-studio-code
vlc
# warp
zoom
```

### references

- [Use AirDrop on your Mac - Apple Support](https://support.apple.com/en-us/102538)
- [Manual · Tig - Text-mode interface for Git](https://jonas.github.io/tig/doc/manual.html)
- [Dotfiles Management - mitxela.com](https://mitxela.com/projects/dotfiles_management)
- [macOS migrations with Brewfile - Open Folder](https://openfolder.sh/macos-migrations-with-brewfile)
- [commit - git add only modified changes and ignore untracked files - Stack Overflow](https://stackoverflow.com/questions/7124726/git-add-only-modified-changes-and-ignore-untracked-files)

## 20231221-ww

### setup notes

- running as media computer for about 6-months
- mostly used to test out new MacOS and run Brave Browser

```bash
brew install rectangle
brew install iterm2
```
