 [![GitHub: fourdollars/autopktest-resource](https://img.shields.io/badge/GitHub-fourdollars%2Fdput%E2%80%90ppa%E2%80%90resource-lightgray.svg)](https://github.com/fourdollars/autopktest-resource/) [![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT) [![Bash](https://img.shields.io/badge/Language-Bash-red.svg)](https://www.gnu.org/software/bash/) ![Docker](https://github.com/fourdollars/autopktest-resource/workflows/Docker/badge.svg) [![Docker Pulls](https://img.shields.io/docker/pulls/fourdollars/autopktest-resource.svg)](https://hub.docker.com/r/fourdollars/autopktest-resource/)
# autopktest-resource
[concourse-ci](https://concourse-ci.org/)'s autopktest-resource

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

### put step

* path: **Required**. Specify a path to run autopkgtest.
* args: Optional. '--apt-upgrade' and '--quiet' by default.

```yaml
- put: autopkgtest
  params:
    path: SomeFolderInTask
    args:
     - --apt-upgrade
     - --quiet
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
    pastebinit:
      pastebin: paste.debian.net
      author: WhoIam
      format: text
```
