PLUGIN_FILES = plugin.yaml LICENSE README.md Changelog.md cnr.ps1 cnr.sh


dist/helm-registry_linux.tar.gz:
	mkdir -p dist/linux/registry
	cp $(PLUGIN_FILES) dist/linux/registry
	cp cnr.sh dist/linux/registry
	cd dist/linux && tar czvf helm-registry_linux.tar.gz registry
	cp dist/linux/helm-registry_linux.tar.gz dist/

dist/helm-registry_windows.tar.gz:
	mkdir -p dist/win/registry
	cp $(PLUGIN_FILES) dist/win/registry
	cp plugin_win.yaml dist/win/registry/plugin.yaml
	cd dist/win && tar czvf helm-registry_windows.tar.gz registry
	cp dist/win/helm-registry_windows.tar.gz dist/

all: dist/helm-registry_linux.tar.gz dist/helm-registry_windows.tar.gz


install: dist/helm-registry_linux.tar.gz
	cp dist/helm-registry_linux.tar.gz ~/.helm/plugins
	cd ~/.helm/plugins && tar xvf helm-registry_linux.tar.gz

clean:
	rm -rf dist

.PHONY: clean

dev:
	cp $(PLUGIN_FILES) ~/.helm/plugins/registry
