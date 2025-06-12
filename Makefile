IMAGE_NAME := aseprite-podman

build: build-image
	mkdir -p ${PWD}/output
	podman run --rm \
	--tmpfs /work:rw,size=24G,mode=1777 \
	-v ${PWD}/output:/output:z \
	${IMAGE_NAME}

build-image:
	podman build -t ${IMAGE_NAME} .
