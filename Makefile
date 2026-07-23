.DEFAULT_GOAL := build
.PHONY: all image clone build clean test-image

.ONESHELL:
.SHELLFLAGS		:= -ec

UID				:= $(shell id -u)
GID				:= $(shell id -g)

BUILDROOT		:= $(CURDIR)
GITDIR			:= $(BUILDROOT)/res/git
RESOURCEDIR		:= $(BUILDROOT)/res/vol

#User can specify different output dir
OUTPUTDIR		?= $(BUILDROOT)/output

#I want an interactive tty attached in most cases, but for some steps, some using CI might want it off
#I want it defaulted to be interactive, CI setup can disable it, but I do not want to add that step for users
NOINTERACTIVE	?= 0
TTY_FLAG		?= $(if $(filter 1,$(NOINTERACTIVE)),,-it)

IMAGE			:= retrobuild:appimagebuildenv

#The build script handles cases for COMMIT/LABEL/SUFFIX to be unset and/or empty, so I pass them as is
PODMAN_RUN		:= podman run \
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
	@if test "x$(FORCE)" = "x1" || ! podman image exists "$(IMAGE)"; then
		echo "Assembling the needed image as $(IMAGE)"
		podman build \
			-t "$(IMAGE)" \
			-f ./res/Containerfile .
	else
		echo "Image \"$(IMAGE)\" already exists.  Not creating."
	fi

clone: image
	@if test -d "$(GITDIR)/RetroArch/.git"; then
		echo "RetroArch git repo already exists. Not cloning."
	else
		$(PODMAN_RUN) $(TTY_FLAG) "$(IMAGE)" \
			git clone https://github.com/libretro/RetroArch.git /git/RetroArch
	fi

build: image clone
	@echo "Running build"
	@$(PODMAN_RUN) $(TTY_FLAG) "$(IMAGE)" \
		/res/scripts/build.sh

clean:
	@#Does not remove build artifacts, only files used for the build itself
	rm -rf "$(GITDIR)/RetroArch"

test-image: image
	$(PODMAN_RUN) -it "$(IMAGE)" \
		bash
