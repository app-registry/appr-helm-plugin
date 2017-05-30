#!/bin/bash
#set -e

LATEST="v0.4.0"

function download_or_noop {
  if [ ! -e "$HELM_PLUGIN_DIR/cnr" ]; then
    read -p "Some registry plugin assets do not exist, download them now? [Y/n] " -n 1 -r
    echo # print a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      printf "Exiting without downloading assets."
      return
    fi

    local PLATFORM="linux"
    if [ "$(uname)" = "Darwin" ]; then
      PLATFORM="osx"
    fi

    local URL="https://github.com/app-registry/helm-plugin/releases/download/$LATEST/registry-helm-plugin-$LATEST-$PLATFORM-x64.tar.gz"

    if which curl > /dev/null; then
      curl -s -L $URL | tar xf - registry/cnr
    else
      wget -q -O - $URL | tar xf - registry/cnr
    fi

    mv registry/cnr "$HELM_PLUGIN_DIR/cnr"
    rm -rf registry
    chmod +x "$HELM_PLUGIN_DIR/cnr"
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


download_or_noop
case "$1" in
  init-plugin)
    update_cnr
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
