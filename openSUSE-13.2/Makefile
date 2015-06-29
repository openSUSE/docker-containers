PROJECT_DIR = $(CURDIR)
BUILD_DIR = /tmp/openSUSE_13.2_root
OUTPUT_DIR = /tmp/openSUSE_13.2_root_result

build :: clean
	sudo /usr/sbin/kiwi --prepare $(PROJECT_DIR) --root $(BUILD_DIR)
	mkdir -p $(OUTPUT_DIR)
	sudo /usr/sbin/kiwi --create $(BUILD_DIR) --type docker -d $(OUTPUT_DIR)

clean ::
	sudo rm -rf $(BUILD_DIR)
	sudo rm -rf $(OUTPUT_DIR)
	sudo rm -f $(BUILD_DIR).log

import ::
	docker import - opensuse:13.2 < $(OUTPUT_DIR)/suse-13.2-docker-guest-docker.x86_64-1.0.0.tar.xz
