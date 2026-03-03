class uart_monitor;

    virtual interface uart_if vif;
    mailbox #(byte) mon_mb;

    function new(virtual interface uart_if vif,
                 mailbox #(byte) mon_mb);
        this.vif = vif;
        this.mon_mb = mon_mb;
    endfunction

    task run();
        forever begin
            @(posedge vif.clk);
            if (vif.rx_valid)
                mon_mb.put(vif.rx_data);
        end
    endtask

endclass
