CONFIGS = alacritty chromium-flags.conf hypr pwsafe omarchy waybar

HOME_DIR := $(HOME)
REPO_DIR := $(HOME_DIR)/Configs

.PHONY: move link unlink restore status

move:
	@echo "Moving configs into omarchy-configs repo..."
	@for item in $(CONFIGS); do \
		if [ -e $(HOME_DIR)/.config/$$item ]; then \
			mkdir -p $(REPO_DIR)/$$item/.config; \
			mv $(HOME_DIR)/.config/$$item $(REPO_DIR)/$$item/.config/; \
			printf "Moved $$item\n"; \
		else \
			printf "Skipping $$item (not found)\n"; \
		fi; \
	done

link:
	@echo "Creating symlinks with stow..."
	@cd $(REPO_DIR) && stow $(CONFIGS)
	@echo "Done."

unlink:
	@echo "Removing symlinks..."
	@cd $(REPO_DIR) && stow -D $(CONFIGS)
	@echo "Done."

restore: unlink
	@echo "Restoring configs back into ~/.config..."
	@for item in $(CONFIGS); do \
		if [ -e $(REPO_DIR)/$$item/.config/$$item ]; then \
			mv $(REPO_DIR)/$$item/.config/$$item $(HOME_DIR)/.config/; \
			printf "Restored $$item\n"; \
		else \
			printf "Skipping $$item (not found in repo)\n"; \
		fi; \
	done

status:
	@echo "Current symlinks in ~/.config:"
	@find $(HOME_DIR)/.config -maxdepth 1 -type l -ls