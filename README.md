[![CircleCI](https://circleci.com/gh/pantheon-systems/rpmbuild-tika.svg?style=shield)](https://circleci.com/gh/pantheon-systems/rpmbuild-tika)

# RPM for Apache Tika

This repository builds an RPM for Apache Tika.

The RPM filename built by this repository is:
```
tika-{version}-1.gitc57cfd1.noarch.rpm
```
The version of the RPM is always set to be the highest version of tika installed by this RPM. Older versions of tike are also included in the same RPM.

This initial version of the RPM installs:

- /opt/pantheon/tika/tika-app-1.1.jar
- /opt/pantheon/tika/tika-app-1.18.jar

For more information, see the [Apache Tika Pantheon documentation](https://pantheon.io/docs/external-libraries/#apache-tika).

## Picking Tika versions

To specify Tika versions to include, simply edit VERSIONS.txt. Each entry in VERSIONS.txt should contain the Tika version to build and the SHA512 hash of the download, separated by a `:`.

The latest available version of Tika and its SHA512 hash can be found on the [Apache Tika Downloads page](https://tika.apache.org/download.html). Be sure to copy the SHA512 hash for the tika-app.jar.

## Building locally

Simply update the VERSIONS.txt file and commit. Run `make all`. The resulting RPM will be in the `pkg` directory.

## Releasing to Package Cloud

Any time a commit is merged on a tracked branch, then a Tika RPM is built and pushed up to Package Cloud.

Branch       | Target
------------ | ---------------
master       | pantheon/internal/fedora/#
`*`            | pantheon/internal-staging/fedora/#

In the table above, # is the fedora build number (22). Note that Tika is only installed on app servers, and there are no app servers on anything prior to f22; therefore, at the moment, we are only publishing for f22. Note also that these are noarch RPMs.

To release new versions of Tika, simply update the VERSIONS.txt file and create a pull request. The rpm will be build on Circle and deployed to pantheon/internal-staging on PakcageCloud, which will cause it to automatically be deployed to the Yolo environment.  Merge the PR and the rpm will be pushed to pantheon/internal, which will cause it to automatically be deployed to production.

## Provisioning Tika on Pantheon

Pantheon will automatically install any new RPM that is deployed to Package Cloud. This is controlled by [pantheon-cookbooks/tika](https://github.com/pantheon-cookbooks/tika/blob/master/recipes/default.rb).

The Pantheon cookbook must be modified to create symbolic links from `/srv/bin` to each `.jar` file in `/opt/pantheon/tika`. If an older version of Tika is removed from the platform, and the removed version is compatibeble with the next release still installed on the system, then the symlink from the removed version may be pointed to the version that remains.

