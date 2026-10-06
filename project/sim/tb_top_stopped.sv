`timescale 1ns / 1ps
`default_nettype none

// STOPPED 状態を追加したストップウォッチのテストベンチ（2-4 の応用の答え合わせ用）
// ボタンを押すたびに，IDLE → BUSY → STOPPED → IDLE と移ることを確かめる。
// 時間を短縮するため，DUT の CLK_FREQ を 27,000 にして「1 秒」を 27,000 クロック（1 ms）にする。
module tb_top;

  localparam int CLK_FREQ = 27_000;            // 27 MHz の 1/1000
  localparam realtime ONE_SEC = 1ms;           // CLK_FREQ クロック分の時間

  // ---- クロック生成: 27MHz（周期 37.037ns）----
  logic clk = 1'b0;
  always #18.518 clk = ~clk;

  // ---- ボタン入力（負論理: 押すと 0）----
  logic sw_in = 1'b1;

  // ---- 検証対象（DUT）----
  wire [5:0] led_output;
  top #(.CLK_FREQ(CLK_FREQ)) dut (
    .clk        (clk),
    .sw_in      (sw_in),
    .led_output (led_output)
  );

  // ---- ボタンを押して離す。押す時間はデバウンス回路の間隔（10 ms 相当）より長くする ----
  task automatic push_button();
    sw_in = 1'b0;
    #(ONE_SEC / 20);     // 50 ms 相当
    sw_in = 1'b1;
    #(ONE_SEC / 20);
  endtask

  // ---- 判定 ----
  int errors = 0;
`define CHECK(msg, cond) \
  if (cond) $display(" OK   ", msg); \
  else begin $display(" NG   ", msg); errors++; end

  // ---- テストの手順 ----
  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_top.sw_in, tb_top.dut.sw_posedge, tb_top.dut.state,
                 tb_top.dut.sec_tick, tb_top.dut.count, tb_top.led_output);

    #(ONE_SEC / 2);
    `CHECK("最初は停止中（IDLE）で，カウンタは 0", dut.state == dut.IDLE && dut.count == 0)

    push_button();                                          // 1 回目: 計測開始
    `CHECK("1 回目: 計測中（BUSY）になる", dut.state == dut.BUSY && dut.count == 0)

    #(ONE_SEC * 3);                                         // 3 秒待つ
    `CHECK("3 秒後にカウンタが 3 になる", dut.count == 3)

    push_button();                                          // 2 回目: 計測停止
    `CHECK("2 回目: 計測値を保持した停止（STOPPED = 2）になる", dut.state == 2)
    #(ONE_SEC * 2);                                         // 2 秒待つ
    `CHECK("STOPPED ではカウンタが変わらない", dut.count == 3)

    push_button();                                          // 3 回目: 待機に戻る
    `CHECK("3 回目: 待機（IDLE）に戻る", dut.state == dut.IDLE)
    `CHECK("IDLE に戻ってもカウンタはまだ 3 のまま", dut.count == 3)

    push_button();                                          // 4 回目: 再び計測開始
    `CHECK("4 回目: カウンタが 0 に戻って計測中になる", dut.state == dut.BUSY && dut.count == 0)

    $display("------------------------------------------");
    if (errors == 0) $display(" PASS: すべての確認に合格");
    else             $display(" FAIL: %0d 件の確認に失敗", errors);
    $display("------------------------------------------");
    $finish;
  end

endmodule

`default_nettype wire
