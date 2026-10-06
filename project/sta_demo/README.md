# sta_demo: STA 演習用プロジェクト

1クロックの間に `STAGES` 段の 32 ビット演算（加算と XOR）を続けて行うデザイン。
`src/top.sv` の `parameter int STAGES` を大きくすると組み合わせ回路が長くなり、27 MHz でタイミング違反が起きる。

- 始点の FF: `cnt`（毎クロック +1 するカウンタ）
- 組み合わせ回路: `x[0]` → `x[STAGES]`
- 終点の FF: `result`（上位 6 ビットを LED に表示）

## 使い方

1. Gowin EDA で `sta_demo.gprj` を開く
2. Run All（合成〜配置配線〜ビットストリーム生成）
3. Process タブの Place & Route → Timing Analysis Report を開く
4. `STAGES` を 2 → 12 に変えて 2〜3 を繰り返し、レポートを比較する

## レポート例の実行環境

`report/` のタイミングレポートは以下の環境で生成した（ファイル中のパスは相対パスに置き換えている）。

| 項目 | 内容 |
|------|------|
| ツール | Gowin EDA **V1.9.11.03 Education**（Linux 版、`gw_sh` によるバッチ実行） |
| 合成ツール | GowinSynthesis |
| デバイス | GW1NR-LV9QN88PC6/I5（GW1NR-9, Device Version C）＝ Tang Nano 9K |
| タイミング制約 | `create_clock -period 37.037`（27 MHz） |
| 遅延モデル | Setup: Slow 1.14V 85C C6/I5 / Hold: Fast 1.26V 0C C6/I5 |
| 実行日 | 2026-10-04 |

| ファイル | 内容 |
|------|------|
| `report/timing_stages2.tr` | `STAGES = 2`（タイミングを満たす） |
| `report/timing_stages12.tr` | `STAGES = 12`（タイミング違反） |

ツールのバージョンや配置配線の結果によって数値は多少変わる。

### STAGES と最大周波数（上記環境での結果）

| STAGES | Actual Fmax | Logic Level | ワーストスラック (ns) | セットアップ違反 |
|-------:|------------:|------------:|---------------------:|:----------------:|
| 2  | 74.900 MHz | 8  | 23.686  | なし |
| 3  | 52.393 MHz | 11 | 17.951  | なし |
| 4  | 40.348 MHz | 15 | 12.253  | なし |
| 5  | 35.884 MHz | 18 | 9.169   | なし |
| 6  | 33.342 MHz | 20 | 7.045   | なし |
| 8  | 27.106 MHz | 26 | 0.145   | なし（ぎりぎり） |
| 10 | 23.028 MHz | 32 | -6.388  | 6 エンドポイント |
| 12 | 19.769 MHz | 37 | -13.548 | 6 エンドポイント |
| 16 | 14.831 MHz | 48 | -30.390 | 6 エンドポイント |

### コマンドラインで再現する場合

以下の Tcl を `build.tcl` としてプロジェクトのディレクトリに保存し、`gw_sh build.tcl` で実行する。

```tcl
set_device GW1NR-LV9QN88PC6/I5 -device_version C
add_file src/top.sv
add_file src/top.cst
add_file src/top.sdc
set_option -top_module top -verilog_std sysv2017 -output_base_name sta_demo
set_option -synthesis_tool gowinsynthesis
run all
```

レポートは `impl/pnr/sta_demo.tr`（テキスト）と `impl/pnr/sta_demo.tr.html`（IDE で表示されるもの）に出力される。

## 注意: LED ピンの IO_TYPE

Tang Nano 9K の LED（pin 10〜16）は 1.8V のバンク（Bank 3）につながっているため、`top.cst` では `IO_TYPE=LVCMOS18` を指定している。
V1.9.11.03 Education では `LVCMOS33` を指定すると次のエラーで配置配線が止まる。

```
ERROR  (CT1136) : Bank 3 vccio(1.8) is locked by other constraint or embedded port, conflicting BANK_VCCIO set by 'led_output_5_obuf' : IO_TYPE = LVCMOS33 in the same bank
```
