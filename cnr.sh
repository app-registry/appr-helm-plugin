#!/bin/bash
#set -e

function list_plugin_versions {
    curl -s https://api.github.com/repos/app-registry/appr-cli/tags |grep name | cut -d'"' -f 4
};

function latest {
    list_plugin_versions | head -n 1
}

function download_cnr {
    local version=$(latest)
    if [ $# -eq 1 ]; then
      version=$1
    fi
    local PLATFORM="linux"

    if [ "$(uname)" = "Darwin" ]; then
      PLATFORM="osx"
    fi

    local URL="https://github.com/app-registry/appr-cli/releases/download/$version/cnr-$PLATFORM-x64"
    echo "downloading $URL ..."
    if which curl > /dev/null; then
      curl -s -L $URL -o $HELM_PLUGIN_DIR/cnr
    else
      wget -q -O $HELM_PLUGIN_DIR/cnr $URL
    fi
    chmod +x "$HELM_PLUGIN_DIR/cnr"
}

function download_or_noop {
  if [ ! -e "$HELM_PLUGIN_DIR/cnr" ]; then
    echo "Registry plugin assets do not exist, download them now !"
    download_cnr $1
  fi
}

function pull {
  #echo "pull $@"
  release=$($HELM_PLUGIN_DIR/cnr pull --media-type helm ${@} | tail -n1)
  echo "$release"
}

function install {
  $HELM_PLUGIN_DIR/cnr helm install $@
}

function dep {
  $HELM_PLUGIN_DIR/cnr helm dep $@
}

function upgrade {
  $HELM_PLUGIN_DIR/cnr helm upgrade $@
}

function cnr_helm {
  $HELM_PLUGIN_DIR/cnr $@ --media-type=helm
}

[ -z "$HELM_PLUGIN_DIR" ] && HELM_PLUGIN_DIR="$HOME/.helm/plugins/registry"
LATEST=$(latest)
download_or_noop $LATEST

case "$1" in
  upgrade-plugin)
    download_cnr "${@:2}"
    ;;
  list-plugin-versions)
    list_plugin_versions
    ;;
  install)
    install "${@:2}"
    ;;
  upgrade)
    upgrade "${@:2}"
    ;;
  dep)
    dep "${@:2}"
    ;;
  pull)
    pull "${@:2}"
    ;;
  push)
    cnr_helm "$@"
    ;;
  list)
    cnr_helm "$@"
    ;;
  show)
    cnr_helm "$@"
    ;;
  delete-package)
    cnr_helm "$@"
    ;;
  inspect)
    cnr_helm "$@"
    ;;
  *)
    $HELM_PLUGIN_DIR/cnr $@
    ;;
esac
