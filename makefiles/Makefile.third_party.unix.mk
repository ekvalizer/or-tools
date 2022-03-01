.PHONY: help_third_party # Generate list of Prerequisite targets with descriptions.
help_third_party:
	@echo Use one of the following Prerequisite targets:
	@grep "^.PHONY: .* #" $(CURDIR)/makefiles/Makefile.third_party.unix.mk | sed "s/\.PHONY: \(.*\) # \(.*\)/\1\t\2/" | expand -t20
	@echo

# Checks if the user has overwritten default libraries and binaries.
BUILD_TYPE ?= Release
USE_COINOR ?= ON
USE_SCIP ?= ON
USE_GLPK ?= OFF
USE_CPLEX ?= OFF
USE_XPRESS ?= OFF
PROTOC ?= $(OR_TOOLS_TOP)/bin/protoc

# Main target.
.PHONY: third_party # Build OR-Tools Prerequisite
third_party:  $(BUILD_DIR)/Makefile

THIRD_PARTY_TARGET = $(BUILD_DIR)/Makefile

$(BUILD_DIR):
	mkdir $(BUILD_DIR)

$(BUILD_DIR)/Makefile: $(CURDIR)/makefiles/Makefile.third_party.unix.mk | $(BUILD_DIR)
	cmake -S . -B $(BUILD_DIR) -DBUILD_DEPS=ON \
	-DBUILD_PYTHON=$(BUILD_PYTHON) \
	-DBUILD_JAVA=$(BUILD_JAVA) \
	-DBUILD_DOTNET=$(BUILD_DOTNET) \
	-DBUILD_EXAMPLES=OFF \
	-DBUILD_SAMPLES=OFF \
	-DUSE_COINOR=$(USE_COINOR) \
	-DUSE_SCIP=$(USE_SCIP) \
	-DUSE_GLPK=$(USE_GLPK) \
	-DUSE_CPLEX=$(USE_CPLEX) \
	-DUSE_XPRESS=$(USE_XPRESS) \
	-DCMAKE_BUILD_TYPE=$(BUILD_TYPE) \
	-DCMAKE_INSTALL_PREFIX=$(OR_ROOT_FULL)

.PHONY: clean_third_party # Clean everything.
clean_third_party:
	-$(DEL) Makefile.local
	-$(DELREC) $(BUILD_DIR)
	-$(DELREC) bin
	-$(DELREC) include
	-$(DELREC) share
	-$(DELREC) lib

.PHONY: detect_third_party # Show variables used to find third party
detect_third_party:
	@echo Relevant info on third party:
	@echo BUILD_TYPE = $(BUILD_TYPE)
	@echo USE_GLOP = ON
	@echo USE_PDLP = ON
	@echo USE_COINOR = $(USE_COINOR)
	@echo USE_SCIP = $(USE_SCIP)
	@echo USE_GLPK = $(USE_GLPK)
	@echo USE_CPLEX = $(USE_CPLEX)
	@echo USE_XPRESS = $(USE_XPRESS)
ifdef GLPK_ROOT
	@echo GLPK_ROOT = $(GLPK_ROOT)
endif
ifdef CPLEX_ROOT
	@echo CPLEX_ROOT = $(CPLEX_ROOT)
endif
ifdef XPRESS_ROOT
	@echo XPRESS_ROOT = $(XPRESS_ROOT)
endif
	@echo
