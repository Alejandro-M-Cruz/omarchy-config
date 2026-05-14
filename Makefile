CONFIGS = alacritty hypr omarchy waybar

HOME_DIR := $(HOME)
REPO_DIR := $(HOME_DIR)/Configs

.PHONY: move link unlink restore status

move:
	@echo "Moving configs into omarchy-configs repo..."
	@for dir in $(CONFIGS); do \
		mkdir -p $(REPO_DIR)/$$dir/.config; \
		if [ -d $(HOME_DIR)/.config/$$dir ]; then \
			mv $(HOME_DIR)/.config/$$dir $(REPO_DIR)/$$dir/.config/; \
			printf "Moved $$dir\n"; \
		else \
			printf "Skipping $$dir (not found)\n"; \
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
	@for dir in $(CONFIGS); do \
		if [ -d $(REPO_DIR)/$$dir/.config/$$dir ]; then \
			mv $(REPO_DIR)/$$dir/.config/$$dir $(HOME_DIR)/.config/; \
			printf "Restored $$dir\n"; \
		else \
			printf "Skipping $$dir (not found in repo)\n"; \
		fi; \
	done

status:
	@echo "Current symlinks in ~/.config:"
	@find $(HOME_DIR)/.config -maxdepth 1 -type l -ls