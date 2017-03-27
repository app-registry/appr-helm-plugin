#!/bin/bash

function update_cnr {
    echo "wip: install/update cnr-cli"



    if [ -e $HELM_PLUGIN_DIR/cnr ] ; then
        chmod +x $HELM_PLUGIN_DIR/cnr
    fi

}

function pull {
    #echo "pull $@"
    release=`$HELM_PLUGIN_DIR/cnr pull --media-type helm ${@} |tail -n1`
    echo $release
}

function install {
    $HELM_PLUGIN_DIR/cnr helm install $@
}

function upgrade {
    $HELM_PLUGIN_DIR/cnr helm upgrade $@
}

function cnr_helm {
    $HELM_PLUGIN_DIR/cnr $@ --media-type=helm
}


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
