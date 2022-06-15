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
- Where you deem necessary, supplement with content from the original project ([donnemartin/dev-setup](https://github.com/donnemartin/dev-setup)) and inspired by others ([mlent/dotfiles](https://github.com/mlent/dotfiles)). 

## Running Setup Script
Assuming a new or reformatted computer...

1. install your [browser of choice](https://brave.com/), add the [bitwarden extendion](https://chrome.google.com/webstore/detail/bitwarden-free-password-m/nngceckbapebfimnlniiiahkandclblb?hl=en), and login to the extension
2. [create a public ssh key & add it to ssh-agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent), log in to github, and [add the newly created key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
3. clone this repo locally: `git clone git@github.com:william-cass-wright/eng-setup.git`
4. run auto-scripts: `$bash single_setup_script.sh`
5. run followup-scripts manually
6. other manual steps: delare [git globals](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup), modify iterm preferences, modify browser preferences, and install final apps manually

### Manual App Process
- iterm preferences
	- Keys/Key Mappings: fix alt key in iterm2 ([link](https://www.clairecodes.com/blog/2018-10-15-making-the-alt-key-work-in-iterm2/))
	- Keys/Key Mappings: add alt delete ([link](https://stackoverflow.com/questions/42735929/how-to-delete-a-word-in-iterm-in-mac-os))
	- General/Working Directory: Reuse previous session's directory
	- Colors/Color Presets.../Solarized Dark
	- Colors/Minimum contrast: 20
	- Terminal/Scrollback lines: Unlimited scrollback
- browser preferences
	- autofill address 		-- off
	- autofill credit cards -- off
	- autofill passwords 	-- off
	- default search engine -- duckduckgo
- manual app installs
	- installed [Amphetamine](https://apps.apple.com/us/app/amphetamine/id937984704?mt=12) via app store
	- download [rar expander](http://rarexpander.sourceforge.net/)
	- install [ByPass Paywall](https://github.com/iamadamdev/bypass-paywalls-chrome)
- sublime text
	- install Package Control (`ctl`+`shift`+`p`)
	- install packages (`ctl`+`shift`+`p` --> `Package Control: Install Package`):
		- Dockerfile Syntax Highlighting
		- A File Icon
		- Jinja2
		- SqlBeautifier
		- MarkdownPreview
		- LiveReload (enable package and simple reload)
	- [retrieve Sublime Text license key](https://www.sublimetext.com/retrieve_key) then copy/paste it by following `Help/Enter License` in application... or just search "Sublime Text License Key" in your email because you've done this a few times

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
**what config files and data can be transferred between computers without copying over the entire file system**
- directories
	- dot config directories at $HOME
	- Sublime Text package directory
	- bundle `.sublime-package` files within `/Library/Application Support/Sublime Text/Installed Packages` directory (how much of an OS's performance can be captured as files... how to build a mac os image?)
- repos
	- command line utility that asks which project in `/repos/` you'd like to retain
	- reconstruct `/repos/` directory, containing active projects, on new machine
- save cli reposonses as json (for potential use as an input object)
- ~automatically detect environment variables, passowords, or locally stored secrets and push them to AWS secretes manager~
- record system state in 'transfer report'
	- command line tools `system_profiler` and `sysctl` to record state of hardware and software

## Appendix
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
