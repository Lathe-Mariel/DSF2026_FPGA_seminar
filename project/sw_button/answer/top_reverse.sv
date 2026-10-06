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

  // スイッチ入力を2段のフリップフロップに記憶する
  logic [1:0] left_shift_acc_reg = '0;
  always_ff @ (posedge clk) begin
    left_shift_acc_reg[0] <= left_shift_reg[1];
    left_shift_acc_reg[1] <= left_shift_acc_reg[0];
  end

  // 2段のフリップフロップの値からスイッチ入力の立ち上がりエッジを検出する
  wire left_shift_posedge = ~left_shift_acc_reg[1] & left_shift_acc_reg[0];

  // ボタンを押した直後に、led の表示を右にシフトするロジック（演習の答え: 向きを逆にする）
  logic [5:0] led = 'd32;   // 一番左から始める
  assign led_output = ~led;
  always_ff @ (posedge clk) begin
    if (left_shift_posedge) begin
      // スイッチの立ち下がりエッジ入力時に、シフトを行う
      if (led[0]) begin
        // 一番右までシフトした次は、一番左に戻る
        led <= 'd32;
      end else begin
        // それ以外の場合は、右にシフトする
        led <= led >> 1;
      end
    end
  end

endmodule

`default_nettype wire
