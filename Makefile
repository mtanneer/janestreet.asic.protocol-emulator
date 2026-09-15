# Local dev convenience only. The canonical test path CI/Tiny Tapeout
# actually exercises is test/Makefile (cocotb + Icarus). This wraps
# fusesoc over the same src/ files for quick iteration.
#
# Assumes fusesoc/iverilog/yosys are already on PATH — run this from
# inside the full EDA container (see scripts/dev-shell.sh), not the host.

CORE = janestreet:asic:protocol_emulator

.PHONY: sim cocotb clean help

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

sim: ## Run the fusesoc sim target (Icarus)
	fusesoc --cores-root . run --target=sim $(CORE)

cocotb: ## Run the canonical cocotb+Icarus testbench (delegates to test/Makefile)
	$(MAKE) -C test

clean: ## Remove build artifacts
	fusesoc --cores-root . run --target=sim $(CORE) --build --clean || true
	rm -rf build sim_build test/sim_build
