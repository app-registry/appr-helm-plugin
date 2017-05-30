PLUGIN_FILES = plugin.yaml LICENSE cnr.sh README.md Changelog.md


dist/%:
	mkdir -p $@/registry
	cp $(PLUGIN_FILES) $@/registry
	cd $@ && tar czvf registry-helm-plugin-$(notdir $@)-x64.tar.gz registry
	cp $@/registry-helm-plugin-$(notdir $@)-x64.tar.gz dist

all: osx linux

osx: dist/osx
linux: dist/linux

win:
	mkdir -p dist/win/registry
	curl -o dist/win/registry/cnr.exe -L -XGET "https://github.com/app-registry/cnr-cli/releases/download/$(CLI_V)/cnr-win-x64.exe"
	chmod +x dist/win/registry/cnr.exe
	cp $(PLUGIN_FILES) dist/win/registry
	sed -r -i "s:HELM_PLUGIN_DIR/cnr:$HELM_PLUGIN_DIR/cnr.exe:g" dist/win/registry/cnr.sh
	cd dist/win && tar czvf registry-helm-plugin-win-x64.tar.gz registry
	cp dist/win/registry-helm-plugin-win-x64.tar.gz dist

install-linux: dist/linux
	cp dist/registry-helm-plugin-linux-x64.tar.gz ~/.helm/plugins
	cd ~/.helm/plugins && tar xvf registry-helm-plugin-linux-x64.tar.gz

install-win: dist/win
	cp dist/registry-helm-plugin-win-x64.tar.gz ~/.helm/plugins
	cd ~/.helm/plugins && tar xvf registry-helm-plugin-win-x64.tar.gz

install-osx: dist/linux
	cp dist/registry-helm-plugin-osx-x64.tar.gz ~/.helm/plugins
	cd ~/.helm/plugins && tar xvf registry-helm-plugin-osx-x64.tar.gz

clean:
	rm -rf dist

.PHONY: clean

dev:
	cp $(PLUGIN_FILES) ~/.helm/plugins/registry
