.PHONY: image build test
all: image build

image: 
	@echo "Assembling the needed image as retrobuild:appimagebuildenv"
	podman build \
	-t retrobuild:appimagebuildenv \
	-f ./res/Containerfile-Buildenv

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
