#!/bin/bash

set -o nounset
set -o errexit

ContentFolder="$1"
SiteName="$2"
OriginRemote="$3"

SitePath="$1/$2"

# setup site / content / sample / assets
[ -d $SitePath ] || mkdir -p $SitePath

# setup git repo for site path
git init $SitePath

# go into the site directory
cd $SitePath

# add remote origin
git remote add origin $OriginRemote








