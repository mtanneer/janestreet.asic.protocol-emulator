#!/bin/sh
# Launches an interactive shell inside the full EDA container
# (yosys/openlane/klayout/gtkwave/iverilog/verilator/cocotb/fusesoc).
# Once inside, `make <target>` works the same as any project that assumes
# an already-running EDA container — fusesoc/iverilog/yosys are all on
# PATH there, not on the host. This script is the only thing that talks
# to Docker; nothing else in the repo does.
#
# --skip is required: without it the image tries to launch a VNC/X11 UI
# server instead of running the given command.
#
# Override the image with: IMAGE=hpretl/iic-osic-tools:<tag> ./scripts/dev-shell.sh
set -eu

IMAGE="${IMAGE:-hpretl/iic-osic-tools:2026.08}"

exec docker run --rm -it -v "$(pwd)":/work -w /work "$IMAGE" --skip bash
