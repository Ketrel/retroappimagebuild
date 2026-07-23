.DEFAULT_GOAL := build
.PHONY: all image clone build clean test

UID := $(shell id -u)
GID := $(shell id -g)

BUILDROOT	:= $(CURDIR)
GITDIR		:= $(BUILDROOT)/res/git
RESOURCEDIR	:= $(BUILDROOT)/res/vol
OUTPUTDIR	:= $(BUILDROOT)/output

IMAGE       := retrobuild:appimagebuildenv
PODMAN_RUN  := podman run \
	--log-driver=none \
	--rm \
	-e UID=$(UID) \
	-e GID=$(GID) \
	-e COMMIT=$(COMMIT) \
	-e LABEL=$(LABEL) \
	-e SUFFIX=$(SUFFIX) \
	-v "$(RESOURCEDIR):/res:ro" \
	-v "$(GITDIR):/git" \
	-v "$(OUTPUTDIR):/output" \
	-v "/etc/localtime:/etc/localtime:ro" 

all: build

image: 
	@if test "x$(FORCE)" = "x1" || ! podman image exists "$(IMAGE)"; then \
		echo "Assembling the needed image as $(IMAGE)"; \
		podman build \
			-t "$(IMAGE)" \
			-f ./res/Containerfile; \
	else \
		echo "Image \"$(IMAGE)\" already exists.  Not creating."; \
	fi

clone:
	@if test -d "$(GITDIR)/RetroArch/.git"; then \
		echo "RetroArch git repo already exists. Not cloning."; \
	else \
		$(PODMAN_RUN) -it "$(IMAGE)" \
		git -C /git clone https://github.com/libretro/RetroArch.git; \
	fi

build: image clone
	@echo "Running build"
	@$(PODMAN_RUN) -it "$(IMAGE)" \
	/res/scripts/build.sh

clean:
	@rm -rf "$(GITDIR)/RetroArch"

test:
	$(PODMAN_RUN) -it "$(IMAGE)" \
		bash
