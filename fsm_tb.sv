`include "fsm.sv"
`timescale 1ns/1ns

module fsm_tb();

  // Create logic variables
  logic l_clk = 1'b0;
  logic [3:0] l_sw = 4'b0000;
  logic [7:0] l_led = {8{1'b0}};

  // Instantiate a component for simulation
  fsm UUT(
    .i_clk(l_clk),
    .i_sw(l_sw),
    .o_led(l_led)
  );

  // Period of clock cycle: T = (1/50 000 000) = 20 ns
  parameter CLK_PERIOD = 20;

  // Generate clock
  always #(CLK_PERIOD/2) l_clk <= ~l_clk;

  // Simulating
  initial begin
    l_sw <= 4'b0001;
    #(25*CLK_PERIOD);
    l_sw <= 4'b0000;
    #(2*CLK_PERIOD);
    l_sw <= 4'b0010;
    #(25*CLK_PERIOD);
    l_sw <= 4'b0000;
    #(2*CLK_PERIOD);
    l_sw <= 4'b0100;
    #(25*CLK_PERIOD);
    l_sw <= 4'b0000;
    #(2*CLK_PERIOD);
    l_sw <= 4'b1000;
    #(40*CLK_PERIOD);
    l_sw <= 4'b0000;
    #(2*CLK_PERIOD);
    $display("That is the end of the simulation.");
  end

endmodule: fsm_tb
