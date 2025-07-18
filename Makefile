# Z80 Frequency Counter Makefile
# Cross-platform build system for ZX Spectrum TZX and TAP files

# Project configuration
PROJECT_NAME = Z80FC
VERSION = 1.0

# Directories (use forward slashes - works on all platforms)
SRC_DIR = src
BUILD_DIR = build
DIST_DIR = dist

# Source files
BASIC_SRC = $(SRC_DIR)/Z80FC.bas
ASM_SRC = $(SRC_DIR)/Z80FC.asm

# Output files
TAP_FILE = $(BUILD_DIR)/Z80FC.tap
TZX_FILE = $(DIST_DIR)/Z80FC.tzx
DIST_TAP_FILE = $(DIST_DIR)/Z80FC.tap

# Tools
ZMAKEBAS = zmakebas
TAP2TZX = tap2tzx
Z80ASM = z80asm
PASMO = pasmo

# Tool options
ZMAKEBAS_FLAGS = -n "Z80FC" -a 10
TAP2TZX_FLAGS = 
Z80ASM_FLAGS = -b

# OS Detection
ifeq ($(OS),Windows_NT)
    DETECTED_OS := Windows
    MKDIR = if not exist "$(1)" mkdir "$(1)"
    RM = rmdir /s /q
    PATHSEP = \\
    DEVNULL = >nul 2>&1
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
        DETECTED_OS := Linux
    endif
    ifeq ($(UNAME_S),Darwin)
        DETECTED_OS := macOS
    endif
    MKDIR = mkdir -p $(1)
    RM = rm -rf
    PATHSEP = /
    DEVNULL = >/dev/null 2>&1
endif

# Colors (only on Unix-like systems)
ifneq ($(DETECTED_OS),Windows)
    COLOR_GREEN = \033[0;32m
    COLOR_BLUE = \033[0;34m
    COLOR_YELLOW = \033[1;33m
    COLOR_RED = \033[0;31m
    COLOR_RESET = \033[0m
else
    COLOR_GREEN = 
    COLOR_BLUE = 
    COLOR_YELLOW = 
    COLOR_RED = 
    COLOR_RESET = 
endif

# Default target
.PHONY: all
all: $(TZX_FILE) $(DIST_TAP_FILE)
	@echo "$(COLOR_GREEN)✓ Build complete: $(TZX_FILE) and $(DIST_TAP_FILE)$(COLOR_RESET)"

# Create TZX file from TAP
$(TZX_FILE): $(TAP_FILE) | $(DIST_DIR)
	@echo "$(COLOR_BLUE)Converting TAP to TZX...$(COLOR_RESET)"
	$(TAP2TZX) $(TAP2TZX_FLAGS) $< $@
	@echo "$(COLOR_GREEN)✓ Created TZX file: $@$(COLOR_RESET)"

# Copy TAP file to distribution directory
$(DIST_TAP_FILE): $(TAP_FILE) | $(DIST_DIR)
	@echo "$(COLOR_BLUE)Copying TAP to distribution...$(COLOR_RESET)"
ifeq ($(DETECTED_OS),Windows)
	@copy "$(subst /,\,$<)" "$(subst /,\,$@)" >nul
else
	@cp $< $@
endif
	@echo "$(COLOR_GREEN)✓ Created distribution TAP: $@$(COLOR_RESET)"

# Create TAP file from BASIC source
$(TAP_FILE): $(BASIC_SRC) | $(BUILD_DIR)
	@echo "$(COLOR_BLUE)Building BASIC program...$(COLOR_RESET)"
	$(ZMAKEBAS) $(ZMAKEBAS_FLAGS) -o $@ $<
	@echo "$(COLOR_GREEN)✓ Created TAP file: $@$(COLOR_RESET)"

# Alternative: Create TAP from assembly source
# NOTE: If you modify the ASM file, you must update DATA statements in the BAS file
$(BUILD_DIR)/Z80FC_asm.tap: $(ASM_SRC) | $(BUILD_DIR)
	@echo "$(COLOR_BLUE)Assembling Z80 code...$(COLOR_RESET)"
	$(Z80ASM) $(Z80ASM_FLAGS) -o $@ $<
	@echo "$(COLOR_GREEN)✓ Assembled: $@$(COLOR_RESET)"
	@echo "$(COLOR_YELLOW)⚠ Remember to update DATA statements in Z80FC.bas if assembly changed$(COLOR_RESET)"

# Alternative: Use pasmo assembler (like c.sh script)
$(BUILD_DIR)/Z80FC_pasmo.bin: $(ASM_SRC) | $(BUILD_DIR)
	@echo "$(COLOR_BLUE)Assembling with pasmo...$(COLOR_RESET)"
	$(PASMO) $< $@
	@echo "$(COLOR_GREEN)✓ Assembled binary: $@$(COLOR_RESET)"
	@echo "$(COLOR_YELLOW)⚠ Remember to update DATA statements in Z80FC.bas$(COLOR_RESET)"

# Create directories (cross-platform)
$(BUILD_DIR):
	@$(call MKDIR,$(BUILD_DIR))

$(DIST_DIR):
	@$(call MKDIR,$(DIST_DIR))

# Development targets
.PHONY: asm
asm: $(BUILD_DIR)/Z80FC_asm.tap
	@echo "$(COLOR_GREEN)✓ Assembly build complete$(COLOR_RESET)"

.PHONY: pasmo
pasmo: $(BUILD_DIR)/Z80FC_pasmo.bin
	@echo "$(COLOR_GREEN)✓ Pasmo assembly complete$(COLOR_RESET)"

.PHONY: test
test: $(TZX_FILE)
	@echo "$(COLOR_YELLOW)Testing with emulator...$(COLOR_RESET)"
ifeq ($(DETECTED_OS),Windows)
	@echo "Windows: Try SpectEmu, Fuse for Windows, or QAOP-JS in browser"
	@echo "File ready: $(TZX_FILE)"
else ifeq ($(DETECTED_OS),macOS)
	@if command -v fuse $(DEVNULL); then \
		fuse --machine spectrum48 $(TZX_FILE); \
	else \
		echo "$(COLOR_RED)FUSE not found. Install with: brew install fuse-emulator$(COLOR_RESET)"; \
		echo "Alternative: Use online emulator at https://torinak.com/qaop"; \
	fi
else
	@if command -v fuse $(DEVNULL); then \
		fuse --machine spectrum48 $(TZX_FILE); \
	else \
		echo "$(COLOR_RED)FUSE not found. Install with: sudo apt-get install fuse-emulator-sdl$(COLOR_RESET)"; \
		echo "Alternative: Use online emulator at https://torinak.com/qaop"; \
	fi
endif

.PHONY: clean
clean:
	@echo "$(COLOR_YELLOW)Cleaning build files...$(COLOR_RESET)"
ifeq ($(DETECTED_OS),Windows)
	@if exist "$(BUILD_DIR)" $(RM) "$(BUILD_DIR)"
else
	@$(RM) $(BUILD_DIR)
endif
	@echo "$(COLOR_GREEN)✓ Build directory cleaned$(COLOR_RESET)"

.PHONY: distclean
distclean: clean
	@echo "$(COLOR_YELLOW)Cleaning distribution files...$(COLOR_RESET)"
ifeq ($(DETECTED_OS),Windows)
	@if exist "$(DIST_DIR)" $(RM) "$(DIST_DIR)"
else
	@$(RM) $(DIST_DIR)
endif
	@echo "$(COLOR_GREEN)✓ All generated files cleaned$(COLOR_RESET)"

# Information targets
.PHONY: info
info:
	@echo "$(COLOR_BLUE)Z80 Frequency Counter Build System$(COLOR_RESET)"
	@echo "=================================="
	@echo "Project: Z80FC v$(VERSION)"
	@echo "Platform: $(DETECTED_OS)"
	@echo "Source: $(BASIC_SRC)"
	@echo "Outputs: $(TZX_FILE), $(DIST_TAP_FILE)"
	@echo ""
	@echo "Available targets:"
	@echo "  all       - Build complete TZX and TAP files (default)"
	@echo "  asm       - Build from assembly source (z80asm)"
	@echo "  pasmo     - Build assembly with pasmo (like c.sh)"
	@echo "  test      - Test with emulator (platform-specific)"
	@echo "  clean     - Remove build files"
	@echo "  distclean - Remove all generated files"
	@echo "  check     - Check tool dependencies"
	@echo "  install   - Show installation instructions"
	@echo "  watch     - Watch files and auto-rebuild (Unix/macOS)"
	@echo "  release   - Create release package"
	@echo "  help      - Show this help"

.PHONY: help
help: info

# Dependency checking (cross-platform)
.PHONY: check
check:
	@echo "$(COLOR_BLUE)Checking dependencies on $(DETECTED_OS)...$(COLOR_RESET)"
	@printf "zmakebas: "
	@if command -v $(ZMAKEBAS) $(DEVNULL); then \
		echo "$(COLOR_GREEN)✓ Found$(COLOR_RESET)"; \
	else \
		echo "$(COLOR_RED)✗ Missing$(COLOR_RESET)"; \
	fi
	@printf "tap2tzx: "
	@if command -v $(TAP2TZX) $(DEVNULL); then \
		echo "$(COLOR_GREEN)✓ Found$(COLOR_RESET)"; \
	else \
		echo "$(COLOR_RED)✗ Missing$(COLOR_RESET)"; \
	fi
	@printf "z80asm: "
	@if command -v $(Z80ASM) $(DEVNULL); then \
		echo "$(COLOR_GREEN)✓ Found$(COLOR_RESET)"; \
	else \
		echo "$(COLOR_YELLOW)- Optional$(COLOR_RESET)"; \
	fi
	@printf "pasmo: "
	@if command -v $(PASMO) $(DEVNULL); then \
		echo "$(COLOR_GREEN)✓ Found$(COLOR_RESET)"; \
	else \
		echo "$(COLOR_YELLOW)- Optional (used by c.sh)$(COLOR_RESET)"; \
	fi

# Tool installation helper (cross-platform)
.PHONY: install
install:
	@echo "$(COLOR_BLUE)Installing build dependencies on $(DETECTED_OS)...$(COLOR_RESET)"
	@echo ""
ifeq ($(DETECTED_OS),Windows)
	@echo "Windows Installation:"
	@echo "1. Install Git for Windows (includes bash)"
	@echo "2. Install zmakebas:"
	@echo "   git clone https://github.com/chris-y/zmakebas.git"
	@echo "   cd zmakebas && make"
	@echo "3. Install tap2tzx:"
	@echo "   git clone https://github.com/dominicjprice/tap2tzx.git"
	@echo "   cd tap2tzx && make"
	@echo "4. Add tools to PATH or copy to a directory in PATH"
	@echo ""
	@echo "Alternative: Use WSL (Windows Subsystem for Linux)"
else ifeq ($(DETECTED_OS),macOS)
	@echo "macOS Installation:"
	@echo "1. Install Homebrew if not present: /bin/bash -c \"$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
	@echo "2. Install build tools: brew install make"
	@echo "3. Install zmakebas:"
	@echo "   git clone https://github.com/chris-y/zmakebas.git"
	@echo "   cd zmakebas && make && sudo make install"
	@echo "4. Install tap2tzx:"
	@echo "   git clone https://github.com/dominicjprice/tap2tzx.git"
	@echo "   cd tap2tzx && make && sudo make install"
	@echo "5. Optional: brew install z80asm"
else
	@echo "Linux Installation:"
	@echo "1. Install zmakebas:"
	@echo "   git clone https://github.com/chris-y/zmakebas.git"
	@echo "   cd zmakebas && make && sudo make install"
	@echo "2. Install tap2tzx:"
	@echo "   git clone https://github.com/dominicjprice/tap2tzx.git"
	@echo "   cd tap2tzx && make && sudo make install"
	@echo "3. Optional packages:"
	@echo "   sudo apt-get install z80asm           # Debian/Ubuntu"
	@echo "   sudo dnf install z80asm               # Fedora"
	@echo "   sudo pacman -S z80asm                 # Arch"
	@echo "4. Optional - Install pasmo (Z80 assembler used by c.sh):"
	@echo "   Download from http://pasmo.speccy.org/ or build from source"
endif

# Release target (cross-platform)
.PHONY: release
release: distclean all
	@echo "$(COLOR_BLUE)Creating release package...$(COLOR_RESET)"
ifeq ($(DETECTED_OS),Windows)
	@cd $(DIST_DIR) && tar -czf Z80FC-v$(VERSION).tar.gz *.tzx *.tap || powershell Compress-Archive -Path *.tzx,*.tap -DestinationPath Z80FC-v$(VERSION).zip
	@echo "$(COLOR_GREEN)✓ Release package created in $(DIST_DIR)$(COLOR_RESET)"
else
	@cd $(DIST_DIR) && tar -czf Z80FC-v$(VERSION).tar.gz *.tzx *.tap
	@echo "$(COLOR_GREEN)✓ Release package created: $(DIST_DIR)/Z80FC-v$(VERSION).tar.gz$(COLOR_RESET)"
endif

# Watch for changes (cross-platform)
.PHONY: watch
watch:
	@echo "$(COLOR_BLUE)Watching for changes on $(DETECTED_OS)...$(COLOR_RESET)"
ifeq ($(DETECTED_OS),Windows)
	@echo "Windows file watching not implemented in Makefile."
	@echo "Suggestion: Use an IDE with auto-build or manually run 'make' after changes."
	@echo "Alternative: Use PowerShell with FileSystemWatcher or install WSL."
else ifeq ($(DETECTED_OS),macOS)
	@if command -v fswatch $(DEVNULL); then \
		fswatch -o $(SRC_DIR)/Z80FC.bas $(SRC_DIR)/Z80FC.asm | while read; do \
			echo "$(COLOR_YELLOW)File changed, rebuilding...$(COLOR_RESET)"; \
			$(MAKE) all; \
		done; \
	else \
		echo "$(COLOR_RED)fswatch not installed. Install with: brew install fswatch$(COLOR_RESET)"; \
	fi
else
	@if command -v inotifywait $(DEVNULL); then \
		while inotifywait -e modify $(SRC_DIR)/Z80FC.bas $(SRC_DIR)/Z80FC.asm $(DEVNULL); do \
			echo "$(COLOR_YELLOW)File changed, rebuilding...$(COLOR_RESET)"; \
			$(MAKE) all; \
		done; \
	else \
		echo "$(COLOR_RED)inotify-tools not installed. Install with: sudo apt-get install inotify-tools$(COLOR_RESET)"; \
	fi
endif

# Debug build with extra information
.PHONY: debug
debug: ZMAKEBAS_FLAGS += -v
debug: TAP2TZX_FLAGS += -v
debug: $(TZX_FILE) $(DIST_TAP_FILE)
	@echo "$(COLOR_GREEN)✓ Debug build complete$(COLOR_RESET)"

