.DEFAULT_GOAL := build
.PHONY: all image clone build clean test-image

# Unless specified will use the UID/GID of the user invoking Make
UID				?= $(shell id -u)
GID				?= $(shell id -g)

BUILDROOT		:= $(CURDIR)
GITDIR			:= $(BUILDROOT)/res/git
RESOURCEDIR		:= $(BUILDROOT)/res/vol

# User can specify different output dir
OUTPUTDIR		?= $(BUILDROOT)/output

# I want an interactive tty attached in most cases, but for some steps, some using CI might want it off
# I want it defaulted to be interactive, CI setup can disable it, but I do not want to add that step for users
NOINTERACTIVE	?= 0
TTY_FLAG		:= $(if $(filter 1,$(NOINTERACTIVE)),,-it)

IMAGE			:= retrobuild:appimagebuildenv

#
ENGINE			?= podman
# The build script handles cases for COMMIT/LABEL/SUFFIX to be unset and/or empty, so I pass them as is
ENGINE_RUN		:= $(ENGINE) run \
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

ifeq ($(ENGINE), podman)
IMAGE_EXISTS	:= $(ENGINE) image exists "$(IMAGE)"
else ifeq ($(ENGINE), docker)
IMAGE_EXISTS	:= $(ENGINE) image inspect "$(IMAGE)" >/dev/null 2>&1
else
$(error Unsupported ENGINE: $(ENGINE).  Valid options are 'podman' or 'docker'.)
endif

all: build

image:
	@if test "x$(FORCE)" = "x1" || ! $(IMAGE_EXISTS); then \
		echo "Assembling the needed image as $(IMAGE)"; \
		$(ENGINE) build \
			-t "$(IMAGE)" \
			-f ./res/Containerfile .; \
	else \
		echo "Image \"$(IMAGE)\" already exists.  Not creating."; \
	fi

clone: image
	@if test -d "$(GITDIR)/RetroArch/.git"; then \
		echo "RetroArch git repo already exists. Not cloning."; \
	else \
		$(ENGINE_RUN) $(TTY_FLAG) "$(IMAGE)" \
			git clone https://github.com/libretro/RetroArch.git /git/RetroArch; \
	fi

build: image clone
	@echo "Running build"
	$(ENGINE_RUN) $(TTY_FLAG) "$(IMAGE)" \
		/res/scripts/build.sh

# Does not remove build artifacts, only files used for the build itself
clean:
	@rm -rf "$(GITDIR)/RetroArch"

# This is intended to spawn an interactive shell within the container, so -it is hard coded here
test-image: image
	$(ENGINE_RUN) -it "$(IMAGE)" \
		bash
