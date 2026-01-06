IMAGE_NAME := aseprite-podman
VERSION ?= 1.3.16
RELEASE_DIR = output

.DEFAULT_GOAL := all

.PHONY: all build-image install uninstall purge clean

all: aseprite-$(VERSION)

build-image:
	@podman build --rm -t $(IMAGE_NAME) .

aseprite-$(VERSION): build-image
	@mkdir -p ./$(RELEASE_DIR)
	@podman run --rm \
	--tmpfs /work:rw,size=8G,mode=1777 \
	-v ./$(RELEASE_DIR):/output:z \
	$(IMAGE_NAME) $(VERSION)

aseprite.desktop:
	@mkdir -p ./$(RELEASE_DIR)
	@echo "[Desktop Entry]" >./$(RELEASE_DIR)/$@
	@echo "Name=Aseprite" >>./$(RELEASE_DIR)/$@
	@echo "Exec=$(HOME)/.local/share/aseprite/aseprite" >>./$(RELEASE_DIR)/$@
	@echo "Terminal=false" >>./$(RELEASE_DIR)/$@
	@echo "Type=Application" >>./$(RELEASE_DIR)/$@
	@echo "Icon=$(HOME)/.local/share/aseprite/data/icons/ase64.png" >>./$(RELEASE_DIR)/$@
	@echo "Comment=Create and edit pixel art" >>./$(RELEASE_DIR)/$@
	@echo "Categories=Graphics;" >>./$(RELEASE_DIR)/$@
	@chmod +x ./$(RELEASE_DIR)/$@

install: aseprite-$(VERSION) aseprite.desktop uninstall
	@cp -R ./$(RELEASE_DIR)/aseprite-$(VERSION) $(HOME)/.local/share/aseprite
	@cp ./$(RELEASE_DIR)/aseprite.desktop $(HOME)/.local/share/applications/aseprite.desktop
	@ln -s $(HOME)/.local/share/aseprite/aseprite $(HOME)/.local/bin/aseprite

uninstall:
	@rm -f $(HOME)/.local/bin/aseprite
	@rm -rf $(HOME)/.local/share/aseprite

purge: uninstall
	@rm -rf $(HOME)/.config/aseprite

clean:
	@rm -r ./$(RELEASE_DIR)
