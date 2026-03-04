PKG_ID := namecoin-electrumx
PKG_VERSION := $(shell yq e ".version" manifest.yaml)
S9PK_PATH := $(shell find . -name $(PKG_ID).s9pk -print 2>/dev/null)

.DELETE_ON_ERROR:

all: verify

verify: $(PKG_ID).s9pk
	start-sdk verify s9pk $(S9PK_PATH)

clean:
	rm -f docker-images/*.tar
	rm -f $(PKG_ID).s9pk

$(PKG_ID).s9pk: manifest.yaml LICENSE instructions.md icon.png docker-images/aarch64.tar docker-images/x86_64.tar
	start-sdk pack

docker-images/aarch64.tar: Dockerfile docker_entrypoint.sh check-electrum.sh properties.sh migrations.sh reindex.sh assets/compat/*
	mkdir -p docker-images
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build \
		--tag start9/$(PKG_ID)/main:$(PKG_VERSION) \
		--platform=linux/arm64 \
		-o type=docker,dest=docker-images/aarch64.tar .

docker-images/x86_64.tar: Dockerfile docker_entrypoint.sh check-electrum.sh properties.sh migrations.sh reindex.sh assets/compat/*
	mkdir -p docker-images
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build \
		--tag start9/$(PKG_ID)/main:$(PKG_VERSION) \
		--platform=linux/amd64 \
		-o type=docker,dest=docker-images/x86_64.tar .

x86: docker-images/x86_64.tar
arm: docker-images/aarch64.tar
