# eng-setup
macOS development environment setup: Easy-to-understand instructions with automated setup scripts for developer tools

## Table of Contents
- [Summary](#summary)
- [Running Setup Script](#running-setup-script)
- [TODO](#todo)
- [Appendix](#appendix)

## Summary
The objective of this repo is to run a single script that sets up your new work computer -- thereby minimizing the amount of time it takes you to start doing actual work. 

- The software, settings, and preferences reflect my personal development preferences. 
- Best practice is always to examine the contents of each script before running it on your machine.
- Where you deem necessary, supplement with content from the original project ([donnemartin/dev-setup](https://github.com/donnemartin/dev-setup)).

## Running Setup Script
Assuming a new or reformatted computer...

1. install your [browser of choice](https://brave.com/), add the [bitwarden extendion](https://chrome.google.com/webstore/detail/bitwarden-free-password-m/nngceckbapebfimnlniiiahkandclblb?hl=en), and login to the extension
2. [create a public ssh key & add it to ssh-agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent), log in to github, and [add the newly created key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
3. clone this repo locally: `git clone git@github.com:william-cass-wright/eng-setup.git`
4. run auto-scripts: `$bash single_setup_script.sh`
5. run followup-scripts manually
6. other manual steps: delare [git globals](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup), modify iterm preferences, modify browser preferences, and install final apps manually

- iterm preferences
	- Keys/Key Mappings: fix alt key in iterm2 ([link](https://www.clairecodes.com/blog/2018-10-15-making-the-alt-key-work-in-iterm2/))
	- Keys/Key Mappings: add alt delete ([link](https://stackoverflow.com/questions/42735929/how-to-delete-a-word-in-iterm-in-mac-os))
	- General/Working Directory: Reuse previous session's directory
	- Colors/Color Presets.../Solarized Dark
	- Colors/Minimum contrast: 20
	- Terminal/Scrollback lines: Unlimited scrollback
- browser preferences
	- autofill address -- off
	- autofill credit cards -- off
	- autofill passwords -- off
	- default search engine -- duckduckgo
- manual app installs
	- installed [Amphetamine](https://apps.apple.com/us/app/amphetamine/id937984704?mt=12) via app store
	- download [rar expander](http://rarexpander.sourceforge.net/)
	- install [ByPass Paywall](https://github.com/iamadamdev/bypass-paywalls-chrome)
- sublime text package control
	- install Package Control (`ctl`+`shift`+`p`)
	- Dockerfile Syntax Highlighting
	- FileIcons
	- Jinja2
	- SqlBeautifier

## TODO
### Random
- develop more sophisticated bash scripts that address failure modes and eleminate repetition (DRY)
- uninstall iTunes and iMovie, along with respective auto-update checks
- forgot about transferring bookmarks over
- add pre-guide for reformatting computer (cleanlieness of running on a freshly reformatted system --> coneceptually or at a high-level, what are you trying to carry over and what are you trying to leave behind?)
- ideaology on how an operating system should run? setting things up so that you don't have to think about them (interruptions, workflow, aesthetics, function before form... but also form)
- setup Brewfile (eg [link](https://github.com/gomex/mac-setup/blob/master/Brewfile))
- time setup process
- look into other IT automation tools, such as [`Ansible`](https://docs.ansible.com/ansible/latest/user_guide/index.html#getting-started) ([for example](https://github.com/geerlingguy/mac-dev-playbook))
- **autogenerate repo using cli tool, then that repo is custom setup for the system transfer over to the new mac?!!!**

### Transfer utility
- command line utility that asks which project in `/repos/` you'd like to retain
- automatically detect environment variables, passowords, or locally stored secrets and push them to AWS secretes manager
- reconstruct `/repos/` directory, containing active projects, on new machine
- save cli reposonses as json (for potential use as an input object)
- bundle `.sublime-package` files within `/Library/Application Support/Sublime Text/Installed Packages` directory (how much of an OS's performance can be captured as files... how to build a mac os image?)

## Appendix
### 20220503 personal macbook pro
- part 1.
	- opened safari
	- downloaded Brave browser
	- added bitwarden extension
	- logged into bitwarden
	- logged into github
	- created ssh keys
	- added keys to github
	- cloned eng-setup repo
	- ran `bash single_setup_script.sh` --> successfully ran brew but failed to run osx, aws, or pydata
- part 2.
	- ran `bash osx.sh`
	- restarted computer
	- ran `bash pydata.sh`
	- ran `bash aws.sh`
	- ran `bash iterm_customization.sh`
	- ran `bash mconda.sh`

- dock modifications
	- [auto-hide](https://discussions.apple.com/thread/5026935): `defaults write com.apple.Dock autohide -bool TRUE; killall Dock`
	- only active apps: `defaults write com.apple.dock static-only -bool true; killall Dock`
	- [auto-hide timer](https://apple.stackexchange.com/questions/33600/how-can-i-make-auto-hide-show-for-the-dock-faster#34097): `defaults write com.apple.dock autohide-time-modifier -int 0;killall Dock`
	- added to osx.sh script

- removed custom prompt from iterm setup
- rerun iterm customization in parts
- fixed .zshrc file
- ohmyzsh overwrites .zshrc file... this needs to be addressed somehow

- added [thefuck](https://github.com/nvbn/thefuck)
- delare [git globals](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup)
```bash
$ git config --global user.name "John Doe"
$ git config --global user.email johndoe@example.com
```

- iterm Profile stuff
	- Keys/Key Mappings: fix alt key in iterm2 ([link](https://www.clairecodes.com/blog/2018-10-15-making-the-alt-key-work-in-iterm2/))
	- Keys/Key Mappings: add alt delete ([link](https://stackoverflow.com/questions/42735929/how-to-delete-a-word-in-iterm-in-mac-os))
	- General/Working Directory: Reuse previous session's directory
	- Colors/Color Presets.../Solarized Dark
	- Colors/Minimum contrast: 20
	- Terminal/Scrollback lines: Unlimited scrollback
- increase tracking speed of track pad and mouse

**SETUP COMPLETED IN APPROXIMATELY 3 HOURS**

other notes
- cloned active projects (--> wouldn't it be great if there were a command line tool to retain active projects or passwords you'd like to retain?)

### 20210207 wayfair mac setup
- open safari
- downloaded Brave
- installed BitWarden
- logged into github
- added ssh keys ([link](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account))
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

- installed [Amphetamine](https://apps.apple.com/us/app/amphetamine/id937984704?mt=12) via app store

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

### Tree
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

### Other Projects
- [What I should install on my Mac?](https://dev.to/gomex/what-i-should-install-on-my-mac-5bbi)

### Alternative to inital setup
```bash
curl -L https://github.com/william-cass-wright/eng-setup/zipball/main/ -o eng-setup.zip
unzip eng-setup.zip
cd william-cass-wright-eng-setup-9aeaeb2 # or whatever suffix is added
bash single_setup_script.sh
```
...not sure exactly how this process would play out but it seems more concise on the surface
