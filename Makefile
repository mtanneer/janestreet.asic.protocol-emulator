# Local dev convenience only. The canonical test path CI/Tiny Tapeout
# actually exercises is test/Makefile (cocotb + Icarus). This wraps
# fusesoc over the same src/ files for quick iteration.

CORE = janestreet:asic:protocol_emulator

.PHONY: sim cocotb clean

sim:
	fusesoc --cores-root . run --target=sim $(CORE)

cocotb:
	$(MAKE) -C test

clean:
	fusesoc --cores-root . run --target=sim $(CORE) --build --clean || true
	rm -rf build sim_build test/sim_build
