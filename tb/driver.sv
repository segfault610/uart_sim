class uart_driver;

    virtual interface uart_if vif;

    function new(virtual interface uart_if vif);
        this.vif = vif;
    endfunction

    task send_byte(byte data);
        @(posedge vif.clk);
        vif.data_in <= data;
        vif.start   <= 1;
        @(posedge vif.clk);
        vif.start   <= 0;
    endtask

endclass
