CLI_V = v0.3.7-dev

PLUGIN_FILES = plugin.yaml LICENSE cnr.sh README.md

dist/%:
	mkdir -p $@/registry
	curl -o $@/registry/cnr -L -XGET "https://github.com/app-registry/cnr-cli/releases/download/$(CLI_V)/cnr-$(CLI_V)-$(notdir $@)-x64"
	chmod +x $@/registry/cnr
	cp $(PLUGIN_FILES) $@/registry
	cd $@ && tar czvf registry-helm-plugin-$(CLI_V)-$(notdir $@)-x64.tar.gz registry
	cp $@/registry-helm-plugin-$(CLI_V)-$(notdir $@)-x64.tar.gz dist

all: osx linux

osx: dist/osx
linux: dist/linux

install-linux: dist/linux
	cp dist/registry-helm-plugin-$(CLI_V)-linux-x64.tar.gz ~/.helm/plugins
	cd ~/.helm/plugins && tar xvf registry-helm-plugin-$(CLI_V)-linux-x64.tar.gz

install-osx: dist/linux
	cp dist/registry-helm-plugin-$(CLI_V)-osx-x64.tar.gz ~/.helm/plugins
	cd ~/.helm/plugins && tar xvf registry-helm-plugin-$(CLI_V)-osx-x64.tar.gz

clean:
	rm -rf dist

.PHONY: clean
