IMAGE_NAME := aseprite-podman
VERSION ?= v1.3.16
RELEASE_DIR = output

.DEFAULT_GOAL := build

.PHONY: build build-image

build: build-image
	@mkdir -p ./$(RELEASE_DIR)
	@podman run --rm \
	--tmpfs /work:rw,size=24G,mode=1777 \
	-v ./$(RELEASE_DIR):/output:z \
	$(IMAGE_NAME) $(VERSION)

build-image:
	@podman build --rm -t $(IMAGE_NAME) .

clean:
	@rm -r ./$(RELEASE_DIR)
