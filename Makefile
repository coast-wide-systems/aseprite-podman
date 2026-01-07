IMAGE_NAME := aseprite-podman
IMAGE_TAG:= latest
VERSION ?= 1.3.16
OUTPUT_DIR = output
APP_NAME = aseprite
DATA_DIR = .local/share
CONF_DIR = .config
BIN_DIR = .local/bin

.DEFAULT_GOAL := all

.PHONY: all build-image install uninstall purge clean

all: build-image $(OUTPUT_DIR)/aseprite-$(VERSION)

build-image:
	@podman build --rm -t $(IMAGE_NAME) .

$(OUTPUT_DIR)/aseprite-$(VERSION):
	@mkdir -p ./$(OUTPUT_DIR)
	@podman run --rm \
	--tmpfs /work:rw,size=8G,mode=1777 \
	-v ./$(OUTPUT_DIR):/output:z \
	$(IMAGE_NAME) $(VERSION)

$(OUTPUT_DIR)/aseprite.desktop:
	@mkdir -p ./$(OUTPUT_DIR)
	@echo "[Desktop Entry]" >./$@
	@echo "Name=Aseprite" >>./$@
	@echo "Exec=$(HOME)/$(DATA_DIR)/aseprite/aseprite" >>./$@
	@echo "Terminal=false" >>./$@
	@echo "Type=Application" >>./$@
	@echo "Icon=$(HOME)/$(DATA_DIR)/aseprite/data/icons/ase64.png" >>./$@
	@echo "Comment=Create and edit pixel art" >>./$@
	@echo "Categories=Graphics;" >>./$@
	@chmod +x ./$@

install: $(OUTPUT_DIR)/aseprite-$(VERSION) $(OUTPUT_DIR)/aseprite.desktop uninstall
	@cp -R ./$(OUTPUT_DIR)/aseprite-$(VERSION) $(HOME)/$(DATA_DIR)/aseprite
	@cp ./$(OUTPUT_DIR)/aseprite.desktop $(HOME)/$(DATA_DIR)/applications/aseprite.desktop
	@ln -s $(HOME)/$(DATA_DIR)/aseprite/aseprite $(HOME)/$(BIN_DIR)/aseprite || true

uninstall:
	@rm -f $(HOME)/$(BIN_DIR)/aseprite
	@rm -rf $(HOME)/$(DATA_DIR)/aseprite

purge: uninstall
	@rm -rf $(HOME)/$(CONF_DIR)/aseprite

clean:
	@rm -rf ./$(OUTPUT_DIR)
	@podman rmi $(IMAGE_NAME):$(IMAGE_TAG) || true
