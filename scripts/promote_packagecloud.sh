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

if [ -z "$1" ] || [ -z "$2" ] ; then
  echo "Need to specify source and target repos, e.g. internal-staging internal"
  exit 1
fi

promote_from=$1
promote_to=$2

for fedora_version in ${repo_versions[@]} ; do
  echo package_cloud promote "pantheon/${promote_from}/fedora/${fedora_version}" "$rpm_name" "pantheon/${promote_to}"
done
