#!/bin/bash
# confirm-rpm.sh

set -eo pipefail

bin="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

source $bin/../scripts/values.sh

if [ ! -d "$pkg_dir" ]
then
  echo "Package directory $pkg_dir not found."
  exit 1
fi

rpmName=$(ls $pkg_dir | grep $highest_version)

if [ -z "$rpmName" ]
then
  echo 'No build found.'
  exit 1
fi

echo
echo "RPM info:"
echo "-------------------------------"
echo "RPM is $rpmName"
rpm -qpi "$pkg_dir/$rpmName"
echo
echo "RPM contents:"
echo "-------------------------------"
rpm -qpl "$pkg_dir/$rpmName"
echo

name=$(rpm -qp --queryformat '%{NAME}\n' "$pkg_dir/$rpmName")
if [ "$(echo "$name" | sed -e 's/[0-9]*$//')" != "$shortname" ]
then
  echo "Name is not $shortname"
  exit 1
fi

epoch=$(rpm -qp --queryformat '%{EPOCH}\n' "$pkg_dir/$rpmName")
if [ -z "$(echo "$epoch" | grep '^[0-9]\{10\}$')" ]
then
  echo "Epoch $epoch does not look like an epoch"
  exit 1
fi

release=$(rpm -qp --queryformat '%{RELEASE}\n' "$pkg_dir/$rpmName")
if [ -z "$(echo "$release" | grep '^\([0-9]\+\)$')" ] && [ -z "$(echo "$release" | grep '^\([0-9]\+\)\.git[0-9a-f]\{7\}\|[0-9]\{10\}$')" ]
then
  echo "Release $release does not match our expected format"
  exit 1
fi

# This semver regex just ignores the pre-release section without validating it
version=$(rpm -qp --queryformat '%{VERSION}\n' "$pkg_dir/$rpmName")
if [ -z "$(echo "$version" | grep '^[0-9]\+\.[0-9]\+\.*[0-9]*')" ]
then
  echo "Version $version does not follow expected form"
  exit 1
fi

contents=$(rpm -qpl "$pkg_dir/$rpmName")
if [ -z "$(echo "$contents" | grep '/opt/pantheon/tika')" ]
then
  echo "RPM contents not correct"
  exit 1
fi

echo 'Basic rpm validation checks all passed.'
exit 0
