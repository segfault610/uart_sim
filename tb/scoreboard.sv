class uart_scoreboard;

    mailbox #(byte) mon_mb;
    byte expected;

    function new(mailbox #(byte) mon_mb);
        this.mon_mb = mon_mb;
    endfunction

    task check();
        byte received;
        mon_mb.get(received);

        if (received == expected)
            $display("PASS: %h", received);
        else
            $display("FAIL: expected %h got %h",
                      expected, received);
    endtask

endclass
