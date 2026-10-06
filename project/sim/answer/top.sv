`default_nettype none

module top #(
  parameter int CLK_FREQ = 27_000_000  // クロック周波数。シミュレーションでは小さくして時間を短縮する
) (
  input  wire       clk,        // 27MHz クロック入力
  input  wire       sw_in,      // スイッチ入力
  output wire [5:0] led_output  // LED 出力
);

  // ---- 状態の定義 ----
  typedef enum logic [1:0] {
    IDLE,     // 待機中（カウント値 = 0）
    BUSY,     // 計測中（毎秒カウントアップ）
    STOPPED   // 停止中（計測値を表示したまま）
  } state_t;

  state_t state = IDLE;

  // ---- スイッチ入力処理（回路1で学んだ内容の流用） ----

  // 使用するスイッチは負論理のため反転
  wire sw = ~sw_in;

  // メタステーブル防止のため、スイッチからの入力を2段のフリップフロップで受ける
  logic [1:0] sw_sync = '0;
  always_ff @ (posedge clk) begin
    sw_sync[0] <= sw;
    sw_sync[1] <= sw_sync[0];
  end

  // デバウンス: 10ミリ秒に1回キャプチャする
  localparam CAPTURE_FREQ   = 100;
  localparam CAPTURE_LIMIT  = CLK_FREQ / CAPTURE_FREQ;
  logic [$clog2(CAPTURE_LIMIT)-1:0] capture_cnt = 'd0;
  wire capture_en = (capture_cnt == CAPTURE_LIMIT - 1);

  always_ff @ (posedge clk) begin
    if (capture_cnt == CAPTURE_LIMIT - 1) begin
      capture_cnt <= 'd0;
    end else begin
      capture_cnt <= capture_cnt + 'd1;
    end
  end

  // エッジ検出
  logic [1:0] sw_edge_reg = '0;
  always_ff @ (posedge clk) begin
    if (capture_en) begin
      sw_edge_reg[0] <= sw_sync[1];
      sw_edge_reg[1] <= sw_edge_reg[0];
    end
  end

  // キャプチャのタイミングでだけ判定し，1回のボタン操作で1クロックだけ 1 にする
  wire sw_posedge = capture_en & ~sw_edge_reg[1] & sw_edge_reg[0];

  // ---- 1秒タイマー（4章で学んだ内容の流用） ----
  localparam ONE_SEC = CLK_FREQ - 1;
  logic [$clog2(ONE_SEC+1)-1:0] sec_cnt = 'd0;
  logic sec_tick = '0;

  always_ff @ (posedge clk) begin
    if (state == BUSY) begin
      if (sec_cnt == ONE_SEC) begin
        sec_cnt  <= 'd0;
        sec_tick <= 1'b1;
      end else begin
        sec_cnt  <= sec_cnt + 'd1;
        sec_tick <= 1'b0;
      end
    end else begin
      sec_cnt  <= 'd0;
      sec_tick <= 1'b0;
    end
  end

  // ---- カウンタ（0〜63秒） ----
  logic [5:0] count = 'd0;

  // ---- ステートマシン ----
  always_ff @ (posedge clk) begin
    case (state)
      IDLE: begin
        if (sw_posedge) begin
          count <= 'd0;
          state <= BUSY;
        end
      end

      BUSY: begin
        if (sw_posedge) begin
          state <= STOPPED;
        end else if (sec_tick) begin
          count <= count + 'd1;
        end
      end

      STOPPED: begin
        if (sw_posedge) begin
          state <= IDLE;
        end
      end

      default: begin
        state <= IDLE;
      end
    endcase
  end

  // ---- LED 出力（負論理） ----
  assign led_output = ~count;

endmodule

`default_nettype wire
