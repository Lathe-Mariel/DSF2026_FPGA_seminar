@echo off
rem Stopwatch simulation (Windows)
rem Usage: run.bat
chcp 65001 > nul
rem 1. compile
iverilog -g2012 -o sim.vvp tb_top.sv ..\stopwatch\src\top.sv || exit /b 1
rem 2. run simulation
vvp sim.vvp || exit /b 1
rem 3. show waveform
echo To view the waveform: gtkwave wave.vcd wave.gtkw
