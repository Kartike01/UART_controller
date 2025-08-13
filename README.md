# UART_controller
```markdown
# UART Controller

A Verilog-based UART (Universal Asynchronous Receiver/Transmitter) controller with separate transmit and receive modules, a baud rate generator, and a clean top-level design for Quartus integration.

## Features
- **Configurable baud rate** via `defines.v`
- **Separate TX and RX modules** for modular design
- **Baud counter** for precise timing
- **Oversampling in RX** for reliable data reception
- **Easily portable** across FPGA projects

## Repository Structure
```

/rtl
├── uart\_tx\_controller.v
├── uart\_rx\_controller.v
├── baud\_counter.v
├── UART\_controller.v (top-level)
└── defines.v (macros & parameters only)
/assets
├── diagram\_tx.jpg
└── diagram\_rx.jpg

```

## How to Add in Quartus
1. Add **all `.v` files** as separate source files (no `.v` `include` usage).
2. Keep `defines.v` for macros only (e.g., `CLOCK_RATE`, `BAUD_RATE`).
3. Make sure all source files are in the project file list.

## Build Instructions
- Set the top-level entity to `UART_controller`
- Synthesize and compile in Quartus
- Assign pins for `ip_tx_data`, `op_tx_data`, `ip_rx_data`, and clock/reset

## Known Fixes
- **Duplicate `assign`** in `uart_tx_controller` → separate signals for active flag and data
- **Baud counter parentheses** → use `CLOCK_RATE / (2 * BAUD_RATE)`
- **Reset naming consistency** (`resetn` vs `reset_n`)

## Frame Format
- 1 Start bit (`0`)
- 8 Data bits (LSB first)
- 1 Stop bit (`1`)

## Testing
- **Loopback test**: connect `op_tx_data` to `ip_rx_data`
- **Simulate** with ModelSim for functional verification

## License
MIT License
```
