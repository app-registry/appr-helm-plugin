PLUGIN_FILES = plugin.yaml LICENSE cnr.sh README.md Changelog.md


dist/registry-helm-plugin.tar.gz:
	mkdir -p dist/registry
	cp $(PLUGIN_FILES) dist/registry
	cd dist && tar czvf registry-helm-plugin.tar.gz registry

all: dist/registry-helm-plugin.tar.gz


install: dist/registry-helm-plugin.tar.gz
	cp dist/registry-helm-plugin.tar.gz ~/.helm/plugins
	cd ~/.helm/plugins && tar xvf registry-helm-plugin.tar.gz

clean:
	rm -rf dist

.PHONY: clean

dev:
	cp $(PLUGIN_FILES) ~/.helm/plugins/registry
