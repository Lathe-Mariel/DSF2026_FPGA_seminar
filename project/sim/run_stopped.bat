@echo off
rem Stopwatch with STOPPED state (Windows)
rem Usage: run_stopped.bat          ... check your modified ..\stopwatch\src\top.sv
rem        run_stopped.bat answer   ... check answer\top.sv
chcp 65001 > nul
if "%1"=="answer" (set DUT=answer\top.sv) else (set DUT=..\stopwatch\src\top.sv)
rem 1. compile
iverilog -g2012 -o sim.vvp tb_top_stopped.sv %DUT% || exit /b 1
rem 2. run simulation
vvp sim.vvp || exit /b 1
rem 3. show waveform
echo To view the waveform: gtkwave wave.vcd wave.gtkw
