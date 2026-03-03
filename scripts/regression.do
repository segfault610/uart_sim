set baud_list {9600 19200 115200}

foreach baud $baud_list {
    puts "Running test with BAUD = $baud"
    vsim -c -gBAUD_RATE=$baud work.tb_uart -do "run -all; quit -f"
}
