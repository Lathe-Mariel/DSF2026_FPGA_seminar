#!/bin/sh
# ストップウォッチのシミュレーション（Linux / macOS）
# 使い方: ./run.sh
set -e
iverilog -g2012 -o sim.vvp tb_top.sv ../stopwatch/src/top.sv   # 1. コンパイル
vvp sim.vvp                                                    # 2. シミュレーション実行
echo "波形を見るには: gtkwave wave.vcd wave.gtkw"              # 3. 波形表示
