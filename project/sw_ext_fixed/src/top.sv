`default_nettype none

module top (
  input  wire       clk,        // 27MHz クロック入力
  input  wire       sw_in,      // スイッチ入力
  output wire [5:0] led_output  // LED 出力
);

  // 使用するスイッチは負論理のため反転
  wire left_shift = ~sw_in;

  // メタステーブル防止のため、スイッチからの入力を2段のフリップフロップで受ける
  logic [1:0] left_shift_reg = '0;
  always_ff @ (posedge clk) begin
    left_shift_reg[0] <= left_shift;
    left_shift_reg[1] <= left_shift_reg[0];
  end

  // タイマーロジック
  // 10ミリ秒に1回sw_in_captureがHiになる
  localparam CLK_FREQ = 27_000_000;
  localparam CAPTURE_FREQ_HZ = 100;
  localparam COUNT_LIMIT = CLK_FREQ/CAPTURE_FREQ_HZ;
  logic [$clog2(COUNT_LIMIT)-1:0] counter = 'd0;
  wire sw_in_capture = (counter == COUNT_LIMIT - 1)? 1'b1: 1'b0;
  always_ff @ (posedge clk) begin
    if (counter == COUNT_LIMIT - 1) begin
      counter <= 'd0;
    end else begin
      counter <= counter + 'd1;
    end
  end

  // スイッチ入力を2段のフリップフロップに記憶する
  logic [1:0] left_shift_acc_reg = '0;
  always_ff @ (posedge clk) begin
    if (sw_in_capture) begin  // 10ミリ秒に一度だけスイッチ入力をキャプチャする
      left_shift_acc_reg[0] <= left_shift_reg[1];
      left_shift_acc_reg[1] <= left_shift_acc_reg[0];
    end
  end

  // 2段のフリップフロップの値からスイッチ入力の立ち上がりエッジを検出する
  // キャプチャのタイミングでだけ判定し，1回のスイッチ操作で1クロックだけ 1 にする
  wire left_shift_posedge = sw_in_capture & ~left_shift_acc_reg[1] & left_shift_acc_reg[0];

  // スイッチの立ち下がりエッジ入力時に、led の表示を左にシフトするロジック
  logic [5:0] led = 'd1;
  assign led_output = ~led;
  always_ff @ (posedge clk) begin
    if (left_shift_posedge) begin
      // スイッチの立ち下がりエッジ入力時に、シフトを行う
      if (led[5]) begin
        // 一番左までシフトした次は、最初に戻る
        led <= 'd1;
      end else begin
        // それ以外の場合は、左にシフトする
        led <= led << 1;
      end
    end
  end

endmodule

`default_nettype wire
