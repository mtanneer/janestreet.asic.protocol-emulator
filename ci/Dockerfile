# Slim CI image: iverilog + yosys + verilator + cocotb + fusesoc only.
# Built from source at pinned tags, not apt (Ubuntu's packaged versions are
# stale — yosys 0.33 / iverilog 12.0 vs the tool versions we test against).
# Not a copy of hpretl/iic-osic-tools — that image is fine for full local
# EDA work (openlane, klayout, spice, etc) but far bigger than CI needs.
FROM ubuntu:24.04 AS build

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential git ca-certificates cmake ninja-build \
    bison flex gperf readline-common libreadline-dev autoconf \
    tcl-dev libffi-dev pkg-config zlib1g-dev python3 python3-dev python3-pip \
    && rm -rf /var/lib/apt/lists/*

# iverilog v13_0
RUN git clone --depth 1 --branch v13_0 https://github.com/steveicarus/iverilog.git /src/iverilog \
    && cd /src/iverilog && sh autoconf.sh && ./configure && make -j"$(nproc)" && make install DESTDIR=/out

# yosys v0.69 (CMake build)
RUN git clone --depth 1 --recurse-submodules --shallow-submodules --branch v0.69 https://github.com/YosysHQ/yosys.git /src/yosys \
    && cmake -S /src/yosys -B /src/yosys/build -G Ninja -DCMAKE_INSTALL_PREFIX=/usr/local \
    && cmake --build /src/yosys/build -j"$(nproc)" \
    && cmake --install /src/yosys/build --prefix /out/usr/local

# verilator v5.052 — build only the "opt" target (skips the debug variant,
# which the default `make` target also builds and roughly doubles build
# time for a binary we never use in CI).
RUN apt-get update && apt-get install -y --no-install-recommends help2man perl libfl-dev \
    && rm -rf /var/lib/apt/lists/* \
    && git clone --depth 1 --branch v5.052 https://github.com/verilator/verilator.git /src/verilator \
    && cd /src/verilator && autoconf && ./configure \
    && make -C src opt -j"$(nproc)" \
    && make install DESTDIR=/out 'VL_INST_PUBLIC_BIN_FILES=verilator_bin$(EXEEXT)'

# cocotb has no prebuilt wheel (sdist only, compiles a C extension) —
# build the wheel here where build-essential already exists.
RUN pip wheel --no-cache-dir --wheel-dir /wheels \
    cocotb==2.0.1 fusesoc==2.4.6 pytest==8.4.2

FROM ubuntu:24.04
# g++ is required at runtime, not just build time: Verilator compiles the
# generated C++ model per test run, unlike iverilog which just interprets.
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip libpython3.12 tcl libreadline8t64 make perl g++ \
    && rm -rf /var/lib/apt/lists/*
COPY --from=build /out/usr/local /usr/local
COPY --from=build /wheels /wheels
RUN pip install --no-cache-dir --break-system-packages --no-index --find-links=/wheels \
    cocotb==2.0.1 fusesoc==2.4.6 pytest==8.4.2 \
    && rm -rf /wheels

WORKDIR /work
