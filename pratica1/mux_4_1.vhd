library IEEE;
use IEEE.std_logic_1164.all;

entity mux_4_1 is
    generic (N : positive := 2);
    port (
        in0, in1, in2, in3 : in  std_logic_vector(N - 1 downto 0);
        sel                : in  std_logic_vector(1 downto 0);
        ot                 : out std_logic_vector(N - 1 downto 0)
    );
end mux_4_1;

architecture rtl of mux_4_1 is
begin
    with sel select
        ot <= in0             when "00",
              in1             when "01",
              in2             when "10",
              in3             when "11",
              (others => '0') when others;
end rtl;
