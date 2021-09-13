** project in progress **

# eng-setup
macOS development environment setup: Easy-to-understand instructions with automated setup scripts for developer tools

## Table of Contents

- [Summary](#summary)
- [Process Definition](#process-definition)
- [Ideal Setup](#setup)
- [Notes](#notes)

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

- setup aws credentials ([link](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)) via `aws configure`