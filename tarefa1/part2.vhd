library ieee;
use ieee.std_logic_1164.all;

-- Multiplexador 2:1 de 4 bits

entity part2 is
    port (
        SW   : in  std_logic_vector(9 downto 0);
        LEDG : out std_logic_vector(9 downto 0)
    );
end part2;

architecture rtl of part2 is
begin
    LEDG(3 downto 0) <= SW(3 downto 0) when SW(9) = '0' else SW(7 downto 4);
    LEDG(8 downto 4) <= (others => '0');
    LEDG(9)          <= SW(9);
end rtl;
