
# Version for docker images from git
RLA_VERSION := $(shell git describe --abbrev=0 --tags)

# Build both docker images
.PHONY: build-all
build-all: build build-gpu


# Build docker image. Application using GPU (nvidia docker needed)
.PHONY: build-gpu
build-gpu:
	docker build --file Dockerfile.gpu -t lizaalert/lacmus:$(RLA_VERSION)-gpu .

# Build docker image. Application using CPU
.PHONY: build
build:
	docker build -t lizaalert/lacmus:$(RLA_VERSION) .

# Build and run docker image. Application using CPU
.PHONY: run
run: build
	docker run --rm \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-e DISPLAY=unix$(DISPLAY) \
	--workdir=$(pwd) \
	--volume="/home/$(USER):/home/$(USER)" \
	--volume="/etc/group:/etc/group:ro" \
	--volume="/etc/passwd:/etc/passwd:ro" \
	--volume="/etc/shadow:/etc/shadow:ro" \
	--volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
	lizaalert/lacmus:$(RLA_VERSION)

# Build and run docker image. Application using GPU
run-gpu: build-gpu
	docker run --rm \
	--runtime=nvidia \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-e DISPLAY=unix$(DISPLAY) \
	--workdir=$(pwd) \
	--volume="/home/$(USER):/home/$(USER)" \
	--volume="/etc/group:/etc/group:ro" \
	--volume="/etc/passwd:/etc/passwd:ro" \
	--volume="/etc/shadow:/etc/shadow:ro" \
	--volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
	lizaalert/lacmus:$(RLA_VERSION)-gpu

