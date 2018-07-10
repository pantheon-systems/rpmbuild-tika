#!/bin/sh

set -ex
bin="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

# epoch to use for -revision
epoch=$(date +%s)

source $bin/values.sh

url="https://github.com/pantheon-systems/rpmbuild-tika"
install_prefix="/opt/pantheon/$shortname"

mkdir -p "$pkg_dir"

fpm -s dir -t rpm	 \
	--package "$rpm_name" \
	--name "${name}" \
	--version "${highest_version}" \
	--iteration "${iteration}" \
	--epoch "${epoch}" \
	--architecture "${arch}" \
	--url "${url}" \
	--vendor "${vendor}" \
	--description "${description}" \
	--prefix "$install_prefix" \
	-C $download_dir \
	$(ls $download_dir)

# Finish up by running our tests.
sh $bin/../tests/confirm-rpm.sh $name
