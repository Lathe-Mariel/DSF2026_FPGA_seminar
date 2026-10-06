`default_nettype none

// 第2章 STA 演習用デザイン
// 1クロックの間に STAGES 段の 32 ビット演算を続けて行う。
// STAGES を大きくすると組み合わせ回路が長くなり，タイミング違反が起きる。
module top #(
  parameter int STAGES = 2   // 1クロックで行う演算の段数
)(
  input  wire       clk,        // 27MHz クロック入力
  output wire [5:0] led_output  // LED 出力（負論理）
);

  // 始点の FF: 毎クロック +1 されるカウンタ
  logic [31:0] cnt = '0;
  always_ff @ (posedge clk) begin
    cnt <= cnt + 32'd1;
  end

  // 組み合わせ回路: 加算と XOR を STAGES 段つなげる
  logic [31:0] x [0:STAGES];
  always_comb begin
    x[0] = cnt;
    for (int i = 0; i < STAGES; i++) begin
      x[i+1] = (x[i] + (x[i] << (i % 7 + 1))) ^ (cnt >> i);
    end
  end

  // 終点の FF: 計算結果を受け取る
  logic [31:0] result = '0;
  always_ff @ (posedge clk) begin
    result <= x[STAGES];
  end

  // 上位 6 ビットを LED に表示（負論理）
  assign led_output = ~result[31:26];

endmodule

`default_nettype wire
