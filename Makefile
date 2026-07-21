.PHONY: image clone build clean test
all: image clone build

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
	@podman run \
		--log-driver=json-file \
		-e UID=$$(id -u) \
		-e GID=$$(id -g) \
		-v "$$(pwd)/res/vol:/res:ro" \
		-v "$$(pwd)/res/git:/git" \
		--rm \
		-it retrobuild:appimagebuildenv \
		sh -c 'cd /git && if [ ! -d "RetroArch" ]; then git clone https://github.com/libretro/RetroArch.git; fi'

build:
	@test -d "$$(pwd)/res/git/RetroArch" || { \
		echo "RetroArch git directory missing, please run 'make clone'."; \
		exit 1; \
	}
	@echo "would build"
	@podman run \
		--log-driver=json-file \
		-e UID=$$(id -u) \
		-e GID=$$(id -g) \
		-e COMMIT=$(COMMIT) \
		-e LABEL=$(LABEL) \
		-e SUFFIX=$(SUFFIX) \
		-v "$$(pwd)/output:/output" \
		-v "$$(pwd)/res/vol:/res:ro" \
		-v "$$(pwd)/res/git:/git" \
		-v "/etc/localtime:/etc/localtime:ro" \
		--rm \
		-it retrobuild:appimagebuildenv \
		/res/scripts/build.sh

clean:
	@rm -rf "$$(pwd)/res/git/RetroArch"

test:
	podman run \
		--log-driver=json-file \
		-e UID=$$(id -u) \
		-e GID=$$(id -g) \
		-e COMMIT=$(COMMIT) \
		-e LABEL=$(LABEL) \
		-e SUFFIX=$(SUFFIX) \
		-v "$$(pwd)/output:/output" \
		-v "$$(pwd)/res/vol:/res:ro" \
		-v "$$(pwd)/res/git:/git" \
		--rm \
		-it retrobuild:appimagebuildenv \
		sh
