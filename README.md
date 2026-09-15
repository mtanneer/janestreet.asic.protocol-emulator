![](../../workflows/ci/badge.svg) ![](../../workflows/tt-gds/badge.svg)

> **Status: scaffold.** `src/project.v` is a dummy placeholder (from the
> Tiny Tapeout template) used to validate the sim/build/CI pipeline before
> real RTL exists. See [SPEC.md](SPEC.md) for the competition requirements.
>
> Two CI workflows: `ci.yaml` is our own (lint, sim, synth-check, runs on
> every push), using our own slim toolchain image (`ci/Dockerfile`,
> ~830MB vs. the 3.76GB `hpretl/iic-osic-tools` it's derived from) —
> that's the fast feedback loop. `tt-gds.yaml` is Tiny Tapeout's
> LibreLane/GDS build, manual-trigger only (`workflow_dispatch`) since
> it's slow and PDK-heavy — run it explicitly when checking
> submission-readiness, not on every WIP push. Local dev also supports
> fusesoc (`Makefile`, `protocol_emulator.core`) layered over the same
> `src/` files.
>
> `ci.yaml`'s first job (`ensure-image`) pulls the GHCR image and builds
> it inline as a fallback if the pull fails (e.g. first run ever, before
> `ci-image.yaml` has published anything) — no manual sequencing needed.

# Tiny Tapeout Verilog Project Template

- [Read the documentation for project](docs/info.md)

## What is Tiny Tapeout?

Tiny Tapeout is an educational project that aims to make it easier and cheaper than ever to get your digital and analog designs manufactured on a real chip.

To learn more and get started, visit https://tinytapeout.com.

## Set up your Verilog project

1. Add your Verilog files to the `src` folder.
2. Edit the [info.yaml](info.yaml) and update information about your project, paying special attention to the `source_files` and `top_module` properties. If you are upgrading an existing Tiny Tapeout project, check out our [online info.yaml migration tool](https://tinytapeout.github.io/tt-yaml-upgrade-tool/).
3. Edit [docs/info.md](docs/info.md) and add a description of your project.
4. Adapt the testbench to your design. See [test/README.md](test/README.md) for more information.

The GitHub action will automatically build the ASIC files using [LibreLane](https://www.zerotoasiccourse.com/terminology/librelane/).

## Enable GitHub actions to build the results page

- [Enabling GitHub Pages](https://tinytapeout.com/faq/#my-github-action-is-failing-on-the-pages-part)

## Resources

- [FAQ](https://tinytapeout.com/faq/)
- [Digital design lessons](https://tinytapeout.com/digital_design/)
- [Learn how semiconductors work](https://tinytapeout.com/siliwiz/)
- [Join the community](https://tinytapeout.com/discord)
- [Build your design locally](https://www.tinytapeout.com/guides/local-hardening/)

## What next?

- [Submit your design to the next shuttle](https://app.tinytapeout.com/).
- Edit [this README](README.md) and explain your design, how it works, and how to test it.
- Share your project on your social network of choice:
  - LinkedIn [#tinytapeout](https://www.linkedin.com/search/results/content/?keywords=%23tinytapeout) [@TinyTapeout](https://www.linkedin.com/company/100708654/)
  - Mastodon [#tinytapeout](https://chaos.social/tags/tinytapeout) [@matthewvenn](https://chaos.social/@matthewvenn)
  - X (formerly Twitter) [#tinytapeout](https://twitter.com/hashtag/tinytapeout) [@tinytapeout](https://twitter.com/tinytapeout)
  - Bluesky [@tinytapeout.com](https://bsky.app/profile/tinytapeout.com)
