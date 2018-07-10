#!/bin/sh

set -ex
bin="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

DEBUG=echo

source $bin/values.sh

$DEBUG rm -rf $download_dir
mkdir -p $download_dir

for version_with_sha in $versions; do(

  version=$(echo $version_with_sha | cut -d : -f 1)
  sha=$(echo $version_with_sha | cut -d : -f 2)

  name="$shortname"
  filename="$shortname-app-$version.jar"
  url="$base_url/$filename"
  target_dir="$bin/../pkgs/"

  $DEBUG wget $url -O $download_dir/$filename

  # Verify the checksum for the downloaded file

  sha_flag=-sha512
  if [ "$(echo -n $sha | wc -c | awk '{ print $1 }')" = "40" ] ; then
    sha_flag=-sha1
  fi
  actual="$(openssl dgst $sha_flag $download_dir/$filename | awk '{ print $2 }')"

  if [ "$sha" == "$actual" ] ; then
    echo "SHA CHECKSUM MATCH"
  else
    set +x
    echo "### ERROR SHA CHECKSUM MISMATCH"
    echo "expected sha: $sha"
    echo "actual sha:   $actual"
    exit 1
  fi

)done
