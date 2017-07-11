#!/bin/bash
#set -e

function list_plugin_versions {
  if [ -x "$(command -v curl)" ]; then
    local GET="curl -s"
  else
    local GET="wget -q -O -"
  fi
  $GET https://api.github.com/repos/app-registry/appr/tags |grep name | cut -d'"' -f 4
};

function latest {
    list_plugin_versions | head -n 1
}

function download_appr {
    local version=$(latest)
    if [ $# -eq 1 ]; then
      version=$1
    fi
    local PLATFORM="linux"

    if [ "$(uname)" = "Darwin" ]; then
      PLATFORM="osx"
    fi

    local URL="https://github.com/app-registry/appr/releases/download/$version/appr-$PLATFORM-x64"
    echo "downloading $URL ..."
    if [ -x "$(command -v curl)" ]; then
      curl -s -L $URL -o $HELM_PLUGIN_DIR/appr
    else
      wget -q -O $HELM_PLUGIN_DIR/appr $URL
    fi
    chmod +x "$HELM_PLUGIN_DIR/appr"
}

function download_or_noop {
  if [ ! -e "$HELM_PLUGIN_DIR/appr" ]; then
    echo "Registry plugin assets do not exist, download them now !"
    download_appr $1
  fi
}

function pull {
  #echo "pull $@"
  release=$($HELM_PLUGIN_DIR/appr pull --media-type helm ${@} | tail -n1)
  echo "$release"
}

function install {
  $HELM_PLUGIN_DIR/appr helm install $@
}

function dep {
  $HELM_PLUGIN_DIR/appr helm dep $@
}

function upgrade {
  $HELM_PLUGIN_DIR/appr helm upgrade $@
}

function appr_helm {
  $HELM_PLUGIN_DIR/appr $@ --media-type=helm
}

[ -z "$HELM_PLUGIN_DIR" ] && HELM_PLUGIN_DIR="$HOME/.helm/plugins/registry"
LATEST=$(latest)
download_or_noop $LATEST

case "$1" in
  upgrade-plugin)
    download_appr "${@:2}"
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
    appr_helm "$@"
    ;;
  list)
    appr_helm "$@"
    ;;
  show)
    appr_helm "$@"
    ;;
  delete-package)
    appr_helm "$@"
    ;;
  inspect)
    appr_helm "$@"
    ;;
  *)
    $HELM_PLUGIN_DIR/appr $@
    ;;
esac
