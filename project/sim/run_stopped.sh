#!/bin/sh
# STOPPED 状態を追加したストップウォッチのシミュレーション（Linux / macOS）
# 使い方: ./run_stopped.sh            … 自分で変更した ../stopwatch/src/top.sv を検証する
#         ./run_stopped.sh answer     … 答えの answer/top.sv を検証する
set -e
case "$1" in
  answer) DUT=answer/top.sv ;;
  *)      DUT=../stopwatch/src/top.sv ;;
esac
iverilog -g2012 -o sim.vvp tb_top_stopped.sv "$DUT"   # 1. コンパイル
vvp sim.vvp                                            # 2. シミュレーション実行
echo "波形を見るには: gtkwave wave.vcd wave.gtkw"      # 3. 波形表示
