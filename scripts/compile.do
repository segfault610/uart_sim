vlib work

vlog design/uart_tx.v
vlog design/uart_rx.v
vlog design/uart_top.v

vlog -sv tb/driver.sv
vlog -sv tb/monitor.sv
vlog -sv tb/scoreboard.sv
vlog -sv tb/tb_uart.sv
