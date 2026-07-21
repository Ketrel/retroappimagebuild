.PHONY: image clone build test
all: image build

image: 
	@echo "Assembling the needed image as retrobuild:appimagebuildenv"
	podman build \
	-t retrobuild:appimagebuildenv \
	-f ./res/Containerfile

clone:
	@test ! -d "$$(pwd)/res/git/RetroArch" || { \
		echo "RetroArch git repo already exists"; \
		exit 1; \
	}
	podman run \
		--log-driver=json-file \
		-e UID=$$(id -u) \
		-e GID=$$(id -g) \
		-v "$$(pwd)/res/vol:/res:ro" \
		-v "$$(pwd)/res/git:/git" \
		--rm \
		-it retrobuild:appimagebuildenv \
		sh -c 'cd /git && if [ ! -d "RetroArch" ]; then git clone https://github.com/libretro/RetroArch.git; fi'
build:
	@echo "would build"

test:
	podman run \
		--log-driver=json-file \
		-e UID=$$(id -u) \
		-e GID=$$(id -g) \
		-e COMMIT=$(COMMIT) \
		-v "$$(pwd)/output:/output" \
		-v "$$(pwd)/res/vol:/res:ro" \
		--rm \
		-it retrobuild:appimagebuildenv \
		sh -c 'if [ -n "${COMMIT}" ]; then echo "${COMMIT}"; else echo "No Commit"; fi'
