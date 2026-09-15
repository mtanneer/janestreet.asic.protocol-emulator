# Protocol Emulator ASIC Competition — Spec

Source: https://blog.janestreet.com/protocol-emulator-asic-competition/

## Challenge

Design an open-source, general-purpose protocol emulator ASIC: a tiny CPU
with specialized instructions for reading pins, writing pins, and precise
cycle counting — so protocols are implemented in firmware, not fixed logic.

- **Primary protocols:** UART, SPI, I2C
- **Stretch goals:** Low-speed USB, 10Mbit Ethernet; also consider JTAG,
  SWD, PS/2, CAN bus
- **Key constraint:** chip must be reprogrammable enough to support new
  protocols after fabrication, within its timing and I/O constraints.

## Technical specifications

**Process & area:**
- IHP 130nm CMOS5L process, via Tiny Tapeout
- Standard allocation: 6×4 tiles (~0.7 mm² nominal area)
- Potential expansion: 8×4 tiles (~30% more area, pending approval)
- Budget: ~1K logic cells per tile
- Must use CMOS5L Verilog template as starting point:
  https://github.com/TinyTapeOut/ttihp-verilog-template/tree/cmos5l

**Design considerations:**
- Synthesis must show mapped cell area early
- Leave room for clock-tree buffers and routing
- Run full place-and-route before final submission
- SRAM preferred over flip-flops for instruction memory

## Rules & deadlines

- Submission deadline: January 18, 2027
- Target tapeout: March 2027 CMOS5L shuttle
- Open source requirement mandatory
- Team participation strongly encouraged
- Sign-up form required for updates:
  https://docs.google.com/forms/d/e/1FAIpQLSeF7fq756MegxZRQxotBwUJYZx-cL9MrGjxV0z4uD_J0sADxQ/viewform

## Prizes

Jane Street will pay to tape out the most novel designs on a Tiny Tapeout
shuttle. Winners receive fabricated chips mounted on dev boards for silicon
testing.

## Related links (from the post)

- Tiny Tapeout: https://www.tinytapeout.com/
- Hardcaml: https://hardcaml.org/
- SRAM example (Tiny Tapeout chip): https://www.tinytapeout.com/chips/ttihp0p2/tt_um_urish_sram_test
- Contact: asic-competition@janestreet.com
