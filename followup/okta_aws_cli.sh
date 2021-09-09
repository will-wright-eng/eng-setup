#!/usr/bin/env bash

#########
# EDIT  #
#########

# replace <firstname.lastname> with your information
VAR1='<firstname>.<lastname>'
# replace bash_profile with your shell of choice (eg VAR2=~/.bash_profile)
# default iTerm shell on MacOS:
VAR2=~/.zshrc
VAR3=~/.aws/config

#########
# START #
#########

PREFIX=~/.okta bash <(curl -fsSL https://raw.githubusercontent.com/oktadeveloper/okta-aws-cli-assume-role/master/bin/install.sh) -i

# add Komodo information to empty okta config.properties
echo ""
echo "#### populating ~/.okta/config.properties with Komodo info ####"
echo ""
rm ~/.okta/config.properties
touch ~/.okta/config.properties

echo "#OktaAWSCLI" >> ~/.okta/config.properties
echo "OKTA_ORG=https://komodohealth.okta.com" >> ~/.okta/config.properties
echo "OKTA_AWS_APP_URL=https://komodohealth.okta.com/home/amazon_aws/0oa18u28b1QELhw4n357/272" >> ~/.okta/config.properties
echo "OKTA_USERNAME=$VAR1" >> ~/.okta/config.properties
echo "OKTA_BROWSER_AUTH=True" >> ~/.okta/config.properties
echo "OKTA_STS_DURATION = 43200" >> ~/.okta/config.properties

export PATH=$PATH:~/.okta/bin

# add section to shell profile, as recommended by ~/.okta install
echo ""
echo "#### adding 'okta-aws' to command line ####"
echo ""
echo '' >> $VAR2
echo '# OktaAWSCLI insert' >> $VAR2
echo 'if [[ -f "$HOME/.okta/bash_functions" ]]; then' >> $VAR2
echo '    . "$HOME/.okta/bash_functions"' >> $VAR2
echo 'fi' >> $VAR2
echo 'if [[ -d "$HOME/.okta/bin" && ":$PATH:" != *":$HOME/.okta/bin:"* ]]; then' >> $VAR2
echo '    PATH="$HOME/.okta/bin:$PATH"' >> $VAR2
echo 'fi' >> $VAR2

source ~/.zshrc

# default aws configs are still necessary for 'okta-aws' to function properly
echo ""
echo "#### adding aws default region and output ####"
echo ""
mkdir ~/.aws
rm $VAR3
touch $VAR3

echo '[default]' >> $VAR3
echo 'region = us-west-2' >> $VAR3
echo 'output = json' >> $VAR3

#########
# END   #
#########

echo ""
echo "#########"
echo "#########"
echo "okta-aws install and setup complete"
echo " "
echo "to continue the setup guide:"
echo "https://komodohealth.atlassian.net/wiki/spaces/LAIRS/pages/1321468122/AWS+CLI+Access+via+Okta"
echo " "
echo "recommended use is to run:"
echo "okta-aws default get-caller-identity"


#########
# TODO  #
#########
# - add check for Java JDK
# - incorperate into single_setup_script.sh by requiring VARs as command line inputs
