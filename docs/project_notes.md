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
