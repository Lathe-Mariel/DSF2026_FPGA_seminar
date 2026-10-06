# ビルド済みビットストリーム

各プロジェクトを Gowin EDA V1.9.11.03 Education でビルドしたビットストリーム（`.fs`）。
自分でビルドできない場合や，動作を先に確かめたいときに，Gowin Programmer や openFPGALoader でそのまま書き込める。
書き込み先は SRAM（電源を切ると消える）。

| ファイル | 元のプロジェクト | 内容 |
|---|---|---|
| `blink.fs` | `project/blink` | L チカ。0.5 秒ごとに LED がカウントアップする |
| `sta_demo_stages2.fs` | `project/sta_demo` | `STAGES = 2`。タイミングを満たす |
| `sta_demo_stages12.fs` | `project/sta_demo` の `STAGES` を 12 にしたもの | タイミング違反あり。演習の結果の例 |
| `sw_button.fs` | `project/sw_button` | ボタン S2 を押すと LED が 1 つ移動する |
| `sw_button_reverse.fs` | `project/sw_button/answer/top_reverse.sv` | 2-3 の演習の正解例。LED が右に移動する |
| `sw_button_release.fs` | `project/sw_button/answer/top_release.sv` | 2-3 の演習の正解例。ボタンを離したときに移動する |
| `sw_fixed.fs` | `project/sw_fixed` | `sw_button` にデバウンス回路を入れたもの |
| `sw_ext_base.fs` | `project/sw_ext_base` | 外付けスイッチ（pin 86）。チャタリング対策なし |
| `sw_ext_fixed.fs` | `project/sw_ext_fixed` | 外付けスイッチ（pin 86）。チャタリング対策あり |
| `stopwatch.fs` | `project/stopwatch` | ストップウォッチ |
| `stopwatch_stopped.fs` | `project/stopwatch` に `project/sim/answer/top.sv` を適用したもの | STOPPED 状態を追加する応用の正解例 |
| `gao_stopwatch.fs` | `project/gao_stopwatch` | ストップウォッチに GAO コアを入れたもの。GAO ウィンドウから書き込む |

## 書き込み方

- Gowin Programmer: スライドの「実機操作 1〜3」の手順で，FS File にこのファイルを指定する
- openFPGALoader: `openFPGALoader -b tangnano9k <ファイル名>.fs`
