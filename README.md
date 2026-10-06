# DSF2026 ハンズオン用資料

CQ出版＆DSF コラボ企画「低価格FPGAボードで体験するFPGA開発」（2026年10月6日）の資料一式。
このフォルダだけで完結するようにまとめてある。

| ファイル・フォルダ | 内容 |
|---|---|
| `dsf_slide.md` | スライド（Marp）。DSF 用のスライドはこのファイルを正とする |
| `img/` | スライドの図表。`*.drawio.svg` は draw.io で編集できる。`img/wk/` は図の元にしたスクリーンショット |
| `project/` | ハンズオンで使う Gowin EDA のプロジェクトと，シミュレーション用のファイル。[project/README.md](project/README.md) を参照 |
| `screenshot_list.md` | スライドに入れるスクリーンショットの一覧と，確認が必要な点 |
| `Makefile` | スライドの PDF を作る |

- 使用するツール: Gowin EDA V1.9.11.03 Education
- 使用するボード: Sipeed Tang Nano 9K
- ライセンス: CC BY 4.0

## スライドのビルド

[Marp CLI](https://github.com/marp-team/marp-cli) が必要。

```
make            # dsf_slide.pdf を生成
```

## 元の資料との関係

CQ セミナー用の資料（第1〜6章）を 1 つにまとめ，DSF 向けに構成と内容を直したもの。
セミナー終了後，必要な修正を元の各章のスライドへ反映する。
