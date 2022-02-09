** project in progress **

# eng-setup
macOS development environment setup: Easy-to-understand instructions with automated setup scripts for developer tools

## Table of Contents

- [Summary](#summary)
- [Process Definition](#process-definition)
- [Ideal Setup](#setup)
- [Notes](#notes)
- [TODO](#todo)

## Summary

The objective of this repo is to run a single script that sets up your new work computer -- thereby minimizing the amount of time it takes you to start doing actual work. 

The software, settings, and preferences that are configured align with standard practices I've identified within the Healthcare Solutions lair but also reflect some of my personal preferences (specifically in the `osx.sh` script). 

Be sure to run through the contents of each script and, where you deem necessary, supplement with content from the original project ([donnemartin/dev-setup](https://github.com/donnemartin/dev-setup)).

## Process Definition
- based on the recent reformatting of my personal computer I'd like to define a process that minimizes the time to setup

1. download Firefox and install bitwarden addon
2. log in to github and add public ssh key
3. git clone eng-setup repo
4. modify and run auto-scripts (brew -> osx -> get-pip -> iterm_customization)

## Ideal Setup

** still in the process of testing, feel free to raise issues or PRs **

Ideally...

1. clone repo
2. ~~enter secrets into secret folder~~ (TODO)
3. make script executable `chmod +x single_setup_script.sh`
4. run script `./single_setup_script.sh`
5. followup checklist

## Notes
### 20210207 wayfair mac setup
- open safari
- downloaded Brave
- installed BitWarden
- logged into github
- added ssh keys
- cloned `eng-setup` repo
- ran `bash single_setup_script.sh`

- logged into okta
- added Brave extensions: tab organizer, dark reader, and bypass paywalls

- ran `iterm_customization.sh lines individually` --> I think this overwrites the existing `.zshrc` file, may want to capture what's in there and append once done installing ohmyzsh and brew zsh features

- set dock to only show active apps `defaults write com.apple.dock static-only -bool true; killall Dock`
- `defaults write com.apple.dock autohide-time-modifier -int 0;killall Dock` ([link](https://apple.stackexchange.com/questions/33600/how-can-i-make-auto-hide-show-for-the-dock-faster#34097))

- set Brave preferences
	- autofill address -- off
	- autofill credit cards -- off
	- autofill passwords -- off
	- default search engine -- duckduckgo

- delare [git globals](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup)
```bash
$ git config --global user.name "John Doe"
$ git config --global user.email johndoe@example.com
```

- adjusted application settings
	- gmail inbox tabs
	- slack dark mode
	- added my face to slack and gmail profiles

- adjusted "Turn display off after" settings

- iterm Profile stuff
	- Keys/Key Mappings: fix alt key in iterm2 ([link](https://www.clairecodes.com/blog/2018-10-15-making-the-alt-key-work-in-iterm2/))
	- Keys/Key Mappings: add alt delete ([link](https://stackoverflow.com/questions/42735929/how-to-delete-a-word-in-iterm-in-mac-os))
	- General/Working Directory: Reuse previous session's directory
	- Colors/Color Presets.../Solarized Dark
	- Colors/Minimum contrast: 20
	- Terminal/Scrollback lines: Unlimited scrollback

- [iterm prompt fixes](https://www.makeuseof.com/customize-zsh-prompt-macos-terminal/)

### 20210910 personal mac reformat notes
- open safari
- download Firefox
- install bitwarden and dark reader addon

- open terminal
- install brew 			(not needed; apart of brew.sh auto-script)
- install git with brew	(not needed; apart of brew.sh auto-script)

- download zip of eng-setup repo 
- adjusted finder format to column arrangment
- opened textedit for notes and file editing
- commented out lines in brew.sh file
- `chmod +x brew.sh`
- `./brew.sh`

- close out terminal, textedit, and safari
- opened iterm, sublimetext, and firefox

- ran osx auto script as is
- `chmod +x osx.sh`
- `./osx.sh`

- only ran the pip install in pydata script (conda envs are better)

- `brew install --cask transmission`
- "Automatically hide and show Dock"

- `./iterm_customization.sh` --> this script doesn't work, I had to add lines to .zshrc manually (fix: split script up into components and run separately)

- added ssh public key to github account ([link](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account))

- increase mouse tracking speed
- [retrieve Sublime Text license key](https://www.sublimetext.com/retrieve_key) then Help/Enter License in application

- delare [git globals](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup)
```bash
$ git config --global user.name "John Doe"
$ git config --global user.email johndoe@example.com
```

- fix alt key in iterm2 ([link](https://www.clairecodes.com/blog/2018-10-15-making-the-alt-key-work-in-iterm2/))

- set default browser to firefox

- created new IAM profile
- added aws credentials locally ([link](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)) via `aws configure`

- iterm stuff
	- General/Working Directory: Reuse previous session's directory
	- Colors/Color Presets.../Solarized Dark
	- Minimum contrast: 20
	- Scrollback lines: Unlimited scrollback

- download [rar expander](http://rarexpander.sourceforge.net/)
- set dock to only show active apps `defaults write com.apple.dock static-only -bool true; killall Dock`

- install [ByPass Paywall](https://github.com/iamadamdev/bypass-paywalls-chrome) Firefox extension

## TODO
- uninstall iTunes and iMovie
- forgot about transferring bookmarks over
- add pre-guide for reformatting computer (cleanlieness of running on a freshly reformatted system --> coneceptually or at a high-level, what are you trying to carry over and what are you trying to leave behind?)
- ideaology on how an operating system should run? setting things up so that you don't have to think about them (interruptions, workflow, aesthetics, function before form... but also form)

## Tree
```bash
%tree --filelimit 10
.
├── LICENSE
├── README.md
├── archive
│  └── okta_aws_cli.sh
├── auto-scripts
│  ├── aws.sh
│  ├── brew.sh
│  ├── osx.sh
│  └── pydata.sh
├── followup-scripts
│  ├── iterm_customization.sh
│  └── mconda.sh
└── single_setup_script.sh
```
