![](../../workflows/ci/badge.svg) ![](../../workflows/tt-gds/badge.svg)

# Protocol Emulator ASIC

Entry for the [Jane Street protocol emulator ASIC competition](https://blog.janestreet.com/protocol-emulator-asic-competition/).
See [SPEC.md](SPEC.md) for the full competition requirements (protocols,
process/area constraints, deadlines).

**Status: scaffold.** `src/project.v` is a dummy placeholder (from the
[Tiny Tapeout](https://tinytapeout.com) cmos5l template) used to validate
the sim/build/CI pipeline before real RTL exists. No ISA, CPU
architecture, or protocol implementation has been designed yet.

## CI

Two workflows:

- **`ci.yaml`** — ours. Lint (verilator), sim (cocotb + fusesoc), synth
  check (yosys). Runs on every push/PR; a `changes` job detects docs-only
  diffs and the three checks no-op (fast success) rather than being
  skipped outright — required status checks must always resolve, or a
  docs-only PR blocks merge forever. Uses a slim custom toolchain image
  (`ci/Dockerfile`, ~830MB vs. the 3.76GB `hpretl/iic-osic-tools` it's
  derived from), published to GHCR by `ci-image.yaml`. `ci.yaml`'s
  `ensure-image` job pulls that image and builds it inline as a fallback
  if the pull fails, so it's never blocked on `ci-image.yaml` having
  already run.
- **`ci-image.yaml`** — builds/publishes the slim image, only when
  `ci/Dockerfile` changes.
- **`tt-gds.yaml`** — Tiny Tapeout's LibreLane/GDS build. Manual-trigger
  only (`workflow_dispatch`) since it's slow and PDK-heavy — run it
  explicitly when checking submission-readiness, not on every WIP push.
- **`secret-scan.yaml`** — gitleaks, full-history scan on every push/PR.
  Not a required status check (would block merge on any pre-existing
  history match); review findings manually if it fails.

`main` is protected: PRs required, `lint`/`sim`/`synth-check` must pass to
merge, no direct pushes or force-pushes, squash/rebase only (no merge
commits), branches auto-delete on merge.

## Local dev

Full setup instructions live in the [wiki](../../wiki) — start at
[Setup: macOS](../../wiki/Setup-macOS). Short version: everything
(fusesoc, iverilog, yosys, verilator) runs inside a Docker container, not
on the host. `./scripts/dev-shell.sh` drops you into it.

Run `git config core.hooksPath .githooks` once after cloning (inside the
container) to enable the pre-commit secret scan (gitleaks on staged
changes). Not automatic — git doesn't track hook activation, only the
hook files themselves.

Fusesoc is layered on top of the same `src/` files as a convenience
(`Makefile`, `protocol_emulator.core`) — `make sim` / `make cocotb`. This
is separate from `test/Makefile`, which is the canonical cocotb+Icarus
path CI and Tiny Tapeout's own gate-level check both use.

## Tiny Tapeout project files

This repo is built on the [cmos5l Verilog template](https://github.com/TinyTapeOut/ttihp-verilog-template/tree/cmos5l).
Reference, not marketing copy:

- [`info.yaml`](info.yaml) — the actual submission manifest: title,
  top_module, source file list, pinout. LibreLane and Tiny Tapeout's CI
  read this directly; keep it in sync with `src/`.
- [`src/config.json`](src/config.json) — LibreLane place-and-route config
  (clock period, density). Don't touch unless you know why.
- [`docs/info.md`](docs/info.md) — project description for Tiny Tapeout's
  site/datasheet.
- [`test/README.md`](test/README.md) — cocotb testbench notes.
- [Tiny Tapeout FAQ](https://tinytapeout.com/faq/) ·
  [Digital design lessons](https://tinytapeout.com/digital_design/) ·
  [Local hardening guide](https://www.tinytapeout.com/guides/local-hardening/)
