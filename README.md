 [![GitHub: fourdollars/autopkgtest-resource](https://img.shields.io/badge/GitHub-fourdollars%2Fautopkgtest%E2%80%90resource-darkgreen.svg)](https://github.com/fourdollars/autopkgtest-resource/) [![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT) [![Bash](https://img.shields.io/badge/Language-Bash-red.svg)](https://www.gnu.org/software/bash/) ![Docker](https://github.com/fourdollars/autopkgtest-resource/workflows/Docker/badge.svg) [![Docker Pulls](https://img.shields.io/docker/pulls/fourdollars/autopkgtest-resource.svg)](https://hub.docker.com/r/fourdollars/autopkgtest-resource/)
# autopkgtest-resource
[concourse-ci](https://concourse-ci.org/)'s autopkgtest-resource

autopkgtest against ubuntu:latest so far.

## Config

### Resource Type

```yaml
resource_types:
- name: resource-autopkgtest
  type: registry-image
  source:
    repository: fourdollars/autopkgtest-resource
    tag: latest
```

or

```yaml
resource_types:
- name: resource-autopkgtest
  type: registry-image
  source:
    repository: ghcr.io/fourdollars/autopkgtest-resource
    tag: latest
```

### Resource

* pastebin: Optional. Paste the complete log.
* webdav: Optional. Store all artifacts generated by autopkgtest.
* setup-commands: Optional. Setup commands for autopkgtest.
* env: Optional. Set --env=VAR=value for autopkgtest.
* isolation-machine: Optional. Disabled by default.

```yaml
resources:
- name: autopkgtest
  icon: bug-check
  type: resource-autopkgtest
  source:
    pastebin: paste.debian.net
    author: YourName
    format: text
```

```yaml
resources:
- name: autopkgtest
  icon: bug-check
  type: resource-autopkgtest
  source:
    webdav: https://webdav.some.where/project/folder
    username: YourUserName
    password: YourPassWord
```

```yaml
resources:
- name: autopkgtest
  icon: bug-check
  type: resource-autopkgtest
  source:
    env:
      DEBFULLNAME: "Shih-Yuan Lee (FourDollars)"
      DEBEMAIL: "fourdollars@debian.org"
    setup-commands: |
      #!/bin/sh
      apt-get -q -q -y install software-properties-common
      add-apt-repository -sy ppa:fourdollars/energy-tools
```

### put step

* path: **Required**. Specify a path to run autopkgtest.
* debian: Optional. Specify an external Debian packaging folder.
* args: Optional. '--apt-upgrade' and '--quiet' by default.
* get_params: skip: Optional. Disabled by default. It won't download the log when it is enabled.
* get_params: max_depth: Optional. It will use '--max-depth=2' by default of `rclone copy` on WebDAV when it downloads the log.
* setup-commands: Optional. Setup commands for autopkgtest.
* env: Optional. Set --env=VAR=value for autopkgtest.
* dont_fail: Optional. The step will fail when autopkgtest failed by default.
* exit_status: Optional. Expected exit status of autopkgtest.
* isolation-machine: Optional. Disabled by default.

```yaml
- put: autopkgtest
  params:
    path: SomeFolderInTask
    args:
     - --apt-upgrade
     - --quiet
    setup-commands: |
      #!/bin/sh
      apt-get -q -q -y install software-properties-common
      add-apt-repository -sy ppa:fourdollars/energy-tools
    dont_fail: true
  get_params:
    skip: true
```

```yaml
- put: autopkgtest
  params:
    path: SomeFolderInTask
    args:
     - --apt-upgrade
     - --quiet
    setup-commands: |
      #!/bin/sh
      apt-get -q -q -y install software-properties-common
      add-apt-repository -sy ppa:fourdollars/energy-tools
    exit_status:
      - 0
      - 2
  get_params:
    skip: true
```

## Example

```yaml
jobs:
- name: test
  plan:
  - get: libchewing
    trigger: true
    params:
      depth: 1
  - put: autopkgtest
    params:
      path: libchewing

resource_types:
- name: resource-autopkgtest
  type: registry-image
  source:
     repository: fourdollars/autopkgtest-resource
     tag: latest

resources:
- name: libchewing
  icon: debian
  type: git
  source:
    uri: https://salsa.debian.org/input-method-team/libchewing.git
    branch: master
- name: autopkgtest
  type: resource-autopkgtest
  icon: bug-check
  source:
    pastebin: paste.debian.net
    author: WhoIam
    format: text
```
