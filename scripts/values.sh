#!/bin/sh

shortname="tika"
arch='noarch'
vendor='Pantheon'
iteration=1
description='tika: Pantheon rpm containing Apache Tika - a content analysis toolkit'

highest_version=$(cat $bin/../VERSIONS.txt | grep -v '^#' | cut -d : -f 1 | sort -nr | head -n 1)
versions=$(cat $bin/../VERSIONS.txt | grep -v '^#')

base_url='http://archive.apache.org/dist/tika/'
download_dir="$bin/../builds/$shortname-$highest_version"

# Set "channel" to "dev" for non-Circle builds, and "release" for Circle builds
CHANNEL="dev"
if [ -n "$CIRCLECI" ] ; then
  CHANNEL="release"
fi

if [ "$CHANNEL" == "dev" ]
then
  # Add the git SHA hash to the rpm build if the local working copy is clean
  if [ -z "$(git diff-index --quiet HEAD --)" ]
  then
    GITSHA=$(git log -1 --format="%h")
    iteration=${iteration}.git${GITSHA}
  else
    iteration=${iteration}.dev
  fi
fi

name="$shortname"
rpm_name=${name}-${highest_version}-${iteration}.${arch}.rpm
