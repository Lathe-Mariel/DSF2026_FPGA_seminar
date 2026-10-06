# DSF2026 用のプロジェクト

DSF2026 のハンズオンで使うプロジェクトとファイル。
スイッチを使うものは，Tang Nano 9K のボード上のボタン S2（pin 3，1.8 V のバンクなので `LVCMOS18`）を使う。

| フォルダ | 内容 | 使う場所 |
|---|---|---|
| `blink` | L チカ | 2-1 Gowin EDA の使い方，2-2 タイミングレポート |
| `sta_demo` | 段数を変えてタイミング違反を起こすデザイン。`report/` に 2 段と 12 段のレポートの例 | 2-2 STA の演習 |
| `sw_button` | ボタンで LED をシフトする回路。チャタリング対策なし。`answer/` は演習の答え（向きを逆にする，離したときに動かす） | 2-3 スイッチ入力 |
| `sw_fixed` | `sw_button` にチャタリング対策を入れたもの | 2-3 の説明 |
| `sw_ext_base` | `sw_button` のスイッチを外付け（pin 86，`LVCMOS18`）にしたもの。チャタリング対策なし | 2-3 の外付けスイッチでの確認 |
| `sw_ext_fixed` | `sw_fixed` のスイッチを外付け（pin 86，`LVCMOS18`）にしたもの。チャタリング対策あり | 同上 |
| `stopwatch` | ストップウォッチ | 2-4 |
| `gao_stopwatch` | `stopwatch` に GAO の設定 `src/stopwatch.rao` を追加したもの。GAO ウィンドウから接続できない場合は，Zadig で WinUSB ドライバを入れ，GAO のケーブルに Gowin USB Cable(WINUSB) を選ぶとつながることがある | 3-1 GAO の紹介 |
| `sim` | ストップウォッチのテストベンチ（`tb_top.sv`）と実行スクリプト。`tb_top_stopped.sv` と `answer/top.sv` は STOPPED 状態を追加する演習の答え合わせ用 | 3-1 シミュレーション |

## 確認した環境

- Gowin EDA V1.9.11.03 Education（Linux 版の `gw_sh`）で，8 つのプロジェクトのビットストリーム生成まで確認
- `sim` は Icarus Verilog 12.0 で確認。`run.bat` は Windows では未確認
- `sw_button` は Tang Nano 9K の実機で動作を確認。ボタン S2 を押すたびに LED が 1 つ移動し，チャタリングは起きなかった
- ほかのプロジェクトの実機での動作は未確認
