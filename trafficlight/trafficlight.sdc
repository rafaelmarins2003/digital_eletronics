# Clock de 50 MHz da DE0
create_clock -name CLOCK_50 -period 20.000 [get_ports {CLOCK_50}]
# clk_1s sai do divisor (1 Hz). O TimeQuest nao aceita um periodo de 1 s
# (limite de ~2 ms), entao ele e declarado como CLOCK_50/2: uma restricao bem
# mais apertada que a real, que o contador de 5 bits cumpre com folga.
create_generated_clock -name clk_1s -source [get_ports {CLOCK_50}] -divide_by 2 [get_registers {clk_1s}]
derive_clock_uncertainty
