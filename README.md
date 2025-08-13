# UART (Universal Asynchronous Receiver/Transmitter)

## Overview
UART is a hardware communication protocol used for **asynchronous serial communication** between two devices. It converts **parallel data** (inside a CPU/system) into **serial data** for transmission and reconverts it back to parallel data on reception.  
Unlike synchronous protocols, UART does **not** require a clock line; instead, both devices agree beforehand on a **baud rate** (bits per second) to determine bit timing.

---

## How It Works
1. **Transmitter (TX)**:
   - Takes parallel data, adds a **start bit** (0), optional **parity bit**, and one or more **stop bits** (1).
   - Sends the data bits **LSB first** at the agreed baud rate.

2. **Receiver (RX)**:
   - Continuously monitors the line (idle = 1).
   - Detects **start bit** (falling edge), waits half a bit period, then samples each bit in the middle to avoid edge errors.
   - Uses **oversampling** (commonly 16×) for accurate sampling.
   - Removes start/parity/stop bits and outputs the parallel data.

---

## UART Frame Format
Idle | Start | b0 b1 b2 b3 b4 b5 b6 b7 | Parity(opt) | Stop
1 | 0 | LSB .......... MSB | bit | 1

- **Start bit**: Always `0`.
- **Data bits**: Typically 8 bits (LSB first).
- **Parity bit**: Optional error detection (even/odd).
- **Stop bits**: 1 or 2 bits at logic `1`.

---

## Key Points
- **Baud Rate**: Defines how long each bit stays on the line (e.g., 9600, 115200 bps).
- **Asynchronous**: No shared clock; timing agreement is essential.
- **Point-to-point**: One TX → One RX (full-duplex uses separate TX and RX lines).
- **Error Handling**: Optional parity check, framing error detection via stop bit.

---

## Applications
- Serial ports on computers (RS-232, USB-to-UART adapters).
- Communication between microcontrollers and peripherals.
- Debugging/logging interfaces.
- GPS modules, Bluetooth modules, sensors, etc.

---
