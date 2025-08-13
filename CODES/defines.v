// UART system configuration
`define CLOCK_RATE      25000000    // 25 MHz
`define BAUD_RATE       115200
`define RX_OVERSAMPLE   16

// UART mode selection
// Uncomment one of the following:
// `define UART_TX_ONLY
// `define UART_RX_ONLY
// If neither is defined, default is full-duplex (TX + RX)
