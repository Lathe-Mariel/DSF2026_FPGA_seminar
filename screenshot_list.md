# DSF セミナー用 スクリーンショット一覧

`dsf_slide.md` の点線の枠「スクリーンショット SS-x-y」の位置に入れる画像。
基準環境: **Gowin EDA V1.9.11.03 Education**（Windows 推奨），Tang Nano 9K。

撮影した画像は `img/` の各フォルダに `ss_x_y.png` の名前で保存し，スライドの点線枠を `![h:400 center](img/chN/ss_x_y.png)` に置き換える。

## 第2章 静的タイミング解析

使うプロジェクト: `project/blink/blink.gprj`，`project/sta_demo/sta_demo.gprj`

| ID | 内容 | 準備 |
|---|---|---|
| （撮影済み） | Timing Analysis Report の位置，L チカの Max Frequency Summary と Setup Paths Table | 元の画像は `img/wk/`。説明を入れた図は `img/ch2/fig_sta_*.drawio.svg` |
| （撮影済み） | `STAGES = 12` のときの Setup Paths Table。違反が赤字で表示されている | 元の画像は `img/wk/GOWIN_EDA_STA_STAGES_12_Error.png`。説明を入れた図は `img/ch2/fig_sta_violation.drawio.svg` |

- メニューの位置と数値は，スクリーンショットで確認済み。L チカの Actual Fmax は 150.776 MHz，`STAGES = 12` のスラックは -13.548 ns

## 2-1 Gowin EDA の使い方（第4章）

| ID | 内容 | 準備 |
|---|---|---|
| （撮影済み） | Programmer の位置，ケーブルの設定画面，書き込み中の画面 | 元の画像は `img/wk/`。説明を入れた図は `img/ch4/fig_programmer_*.drawio.svg` |


## 第3章 今回使う FPGA

| ID | 内容 | 準備 |
|---|---|---|
| （任意）SS-3-1 | Tang Nano 9K の写真（LED，ボタン，USB-C の位置が分かるもの） | ボード |

- ボタンのピン番号（3, 4）は記憶に基づく。回路図で確認する

## 第6章 GAO とシミュレーション

### シミュレーション

使うファイル: `project/sim/`（Windows に Icarus Verilog をインストールしておく）

| ID | 内容 | 準備 |
|---|---|---|

- GTKWave の波形（`img/sim_wave_fixed.png`，`img/sim_wave_base.png`）は Linux 版で撮影済み。Windows 版の見た目に揃えたい場合は `gtkwave wave.vcd wave.gtkw` で撮り直す
- `run.bat` は Windows で未実行。日本語の表示が化ける場合は報告すること（`chcp 65001` を入れてある）

### GAO

プロジェクト: `project/gao_stopwatch/gao_stopwatch.gprj`

GAO は紹介のみ（ドライバの入れ替えと操作は当日行わない）なので，スクリーンショットは必須ではない。撮れれば手順 3・4 のスライドに載せる。

- ある Windows 環境では，GAO ウィンドウから接続できず，Zadig で JTAG Debugger (Interface 0) のドライバを WinUSB に入れ替えて Gowin USB Cable(WINUSB) を選ぶと動いた。環境固有の可能性がある。Linux は未確認
- WinUSB に入れ替えたあとに Gowin Programmer から書き込めるか（ケーブルの種類）は未確認
- 制約ファイルには TCK の定義と非同期の指定を足してある。足す前は `clk` と TCK をまたぐ経路に違反が 107 件出ていた
