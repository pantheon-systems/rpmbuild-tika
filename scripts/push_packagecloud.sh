#!/bin/bash
#
#  wrapper for pushing rpm's up to both repos
#
repo_versions=(22)

bin="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

source $bin/values.sh

if [ -z "$(which package_cloud)" ]; then
  echo "Error no 'package_cloud' found in PATH"
  exit 1
fi

if [ -z "$1" ] ; then
  echo "Need to specify target repo: internal, internal-staging"
  exit 1
fi

for fedora_version in ${repo_versions[@]} ; do
  echo package_cloud push "pantheon/$1/fedora/$fedora_version" $target_dir/$rpm_name
done
