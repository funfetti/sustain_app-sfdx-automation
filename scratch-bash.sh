#!/usr/bin/env bash

# run chmod u+x scratch-bash.sh
# to actually execute: bash scratch-bash.sh
#
#your project-scratch-def.json should look something like this
# {
#  "orgName": "sustainability cloud scratch",
#  "edition": "Developer",
#  "features": [
#    "DevelopmentWave",
#    "SustainabilityCloud"
#  ]
# }
# 

# get alias from user 
echo "name your sustainability scratch org:"
read sname

echo -e "\e[1mcreating your scratch org $sname...\e[0m"
sfdx force:org:create -f config/project-scratch-def.json -s -a $sname

echo "installing 1.12"
sfdx force:package:install -p 04t3k000000iy8qAAA -w 20 

# output looks like: 
# PackageInstallRequest is currently InProgress. You can continue to query the status using
# sfdx force:package:install:report -i 0Hf210000004kNqCAI -u test-sptpbsctyvpw@example.com

echo "assigning perms"
# PSL/Perms 
# using shane's plugins https://github.com/mshanemc/shane-sfdx-plugins

sfdx shane:user:psl -l User -g User -n sustain_app_SustainabilityCloudPsl

# if the permset assignment fails you need to run $ sfdx plugins:install user for whatever reason. see this gh issue https://github.com/forcedotcom/cli/issues/802
sfdx force:user:permset:assign -n SustainabilityCloud
sfdx force:user:permset:assign -n SustainabilityAppManager
sfdx force:user:permset:assign -n SustainabilityAnalytics

# make the EA dashboards populate correctly 
sfdx shane:user:permset:assign -l User -g Integration -n SustainabilityAnalytics

## actually you need to push the page layout assignments first (stored in profile)
sfdx force:source:deploy -p force-app/main/default/profiles/Admin.profile-meta.xml

#load data - right now a little weird 
# sfdx automig:load -f demo-data/automig-load.json
sfdx automig:load -d demo-data/ --concise --mappingobjects RecordType:DeveloperName,sustain_app__EmissionFactorElectricity__c:Name,sustain_app__EmissionFactorOther__c:Name,sustain_app__EmissionFactorScope3__c:Name

#create EA apps
#sfdx analytics:app:create -m Sustainability  
#sfdx analytics:app:create -m Sustainability_Audit -a 

# alrighty lets push source
# make sure wave folder is deleted or empty!!! 
# sfdx force:source:push 