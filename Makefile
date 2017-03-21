CLI_V = v0.3.7-dev

PLUGIN_FILES = plugins.yaml LICENSE cnr.sh
TAR_NAME = cnr-$TRAVIS_TAG-$TRAVIS_OS_NAME-x64-helm-plugin.tar.gz


dist/$(CLI_V)/%:
	mkdir -p $@/registry
	curl -o $@/registry/cnr -L -XGET "https://github.com/app-registry/cnr-cli/releases/download/$(CLI_V)/cnr-$(CLI_V)-$(notdir $@)-x64"
	cp $(PLUGIN_FILES) $@/registry
	cd $@ && tar xvf cnr-$(CLI_V)-$(notdir $@)-x64-helm-plugin.tar.gz .

osx: dist/$(CLI_V)/osx
linux: dist/$(CLI_V)/linux

clean:
	rm -rf build dist

.PHONY: clean
