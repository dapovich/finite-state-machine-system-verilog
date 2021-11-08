module fsm
  (
    input logic i_clk,        // Clock 50 MHz
    input logic [3:0] i_sw,   // Four switches to control behaviour
    output logic [7:0] o_led  // Output LEDs
  );

  // Additional stuff for logic implemention
  shortint unsigned index = 0;
  logic flag_even = 1'b1;
  logic flag_allow_blink = 1'b1;
  logic flag_allow_shifting = 1'b1;
  logic [1:0] flag_blinks_amount = 2'b00;
  logic [7:0] l_led = 8'b0000_0000;

  // Counter equals the time = (2^28 / 50 000 000) = 5,36 seconds
  logic [27:0] l_cnt = {28{1'b0}};

  always @(posedge i_clk)
    begin
      if (i_sw == 4'b0001)
      begin
        if (l_cnt == 2**2 - 1 && flag_allow_blink == 1'b1)
        begin
          flag_blinks_amount <= flag_blinks_amount + 1'b1;
          l_led <= ~l_led;
          l_cnt <= {28{1'b0}};
          if (flag_blinks_amount == 2'b01)
          begin
            flag_allow_blink <= 1'b0;
          end
        end
        else begin
          l_cnt <= l_cnt + 1'b1;
        end
      end
      else if (i_sw == 4'b0010)
      begin
        if (l_cnt == 2**2 - 1)
        begin
          l_led <= ~l_led;
          l_cnt <= {28{1'b0}};
        end
        else begin
          l_cnt <= l_cnt + 1'b1;
        end
      end
      else if (i_sw == 4'b0100)
      begin
        if (l_cnt == 2**2 - 1)
        begin
          if (flag_even)
          begin
            l_led <= 8'b0101_0101;
            flag_even <= 1'b0;
          end
          else begin
            l_led <= 8'b1010_1010;
            flag_even <= 1'b1;
          end
          l_cnt <= {28{1'b0}};
        end
        else begin
          l_cnt <= l_cnt + 1'b1;
        end
      end
      else if (i_sw == 4'b1000)
      begin
        if (l_cnt == 2**2 - 1)
        begin
          if (index == 0 && flag_allow_shifting == 1'b1)
          begin
            l_led[index] <= ~l_led[index];
            l_cnt <= {28{1'b0}};
            index++;
          end
          else if (index > 0 && index <= 7 && flag_allow_shifting == 1'b1)
          begin
            l_led <= l_led << 1;
            l_cnt <= {28{1'b0}};
            index++;
          end
          else
          begin
            l_led <= 8'b0000_0000;
            l_cnt <= {28{1'b0}};
            index = 0;
            flag_allow_shifting = 1'b0;
          end
        end
        else begin
          l_cnt <= l_cnt + 1'b1;
        end
      end
      else begin    // reset value to beginning
        l_cnt <= {28{1'b0}};
        l_led <= 8'b0000_0000;
        flag_even <= 1'b1;
        flag_allow_blink <= 1'b1;
        flag_blinks_amount <= 2'b00;
        flag_allow_shifting = 1'b1;
      end
    end

  // Update output signal
  assign o_led = l_led;

endmodule: fsm
