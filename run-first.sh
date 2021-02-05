#!/usr/bin/env bash

# run chmod u+x run-first.sh
# to actually execute: bash run-first.sh

# to do
# write a forceignore
# bonus - rename scratch config file with org deets

echo "name your sfdx project:"
read proj

echo "creating sfdx project..."

#create a project
sfdx force:project:create -n $proj -d ..

# copy scratch-bash, config file, Admin profile, and demo data to the right folder
echo "ok! copying to $proj..."

cp scratch-bash ../$proj/
cp project-scratch-def.json ../$proj/config/
mkdir ../$proj/force-app/main/default/profiles/
cp Admin.profile-meta.xml ../$proj/force-app/main/default/profiles/
cp -a demo-data/. ../$proj/demo-data/

echo "done"