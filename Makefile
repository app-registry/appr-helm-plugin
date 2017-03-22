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

clean:
	rm -rf dist

.PHONY: clean
