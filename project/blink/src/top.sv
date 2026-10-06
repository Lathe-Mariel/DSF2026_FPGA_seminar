`default_nettype none

module top (
  input  wire       clk,
  output wire [5:0] led_output
);

  logic [5:0] led = 'd0;
  logic       overflow;

  assign led_output = ~led;

  always_ff @ (posedge clk) begin
    if (overflow) begin
      led <= led + 'd1;
    end
  end

  timer #(
    .COUNT_MAX (13500000)
  ) inst_0 (
    .clk      (clk),
    .overflow (overflow)
  );

endmodule

module timer #(
  parameter COUNT_MAX = 27000000
) (
  input  wire  clk,
  output logic overflow
);

  logic [$clog2(COUNT_MAX)-1:0] counter = 'd0;   // 0 〜 COUNT_MAX-1 を数える

  always_ff @ (posedge clk) begin
    if (counter == COUNT_MAX - 1) begin
      counter  <= 'd0;
      overflow <= 'd1;
    end else begin
      counter  <= counter + 'd1;
      overflow <= 'd0;
    end
  end

endmodule

`default_nettype wire
