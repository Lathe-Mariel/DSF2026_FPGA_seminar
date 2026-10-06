create_clock -name clk -period 37.037 -waveform {0 18.518} [get_ports {clk}] -add
create_clock -name tck -period 50 -waveform {0 25} [get_ports {tck_pad_i}] -add
set_clock_groups -asynchronous -group [get_clocks {clk}] -group [get_clocks {tck}]
