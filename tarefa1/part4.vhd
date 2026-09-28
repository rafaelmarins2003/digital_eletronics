library ieee;
use ieee.std_logic_1164.all;

-- Decodificador para display de 7 segmentos

entity part4 is
    port (
        SW   : in  std_logic_vector(1 downto 0);
        LEDG : out std_logic_vector(9 downto 0);
        HEX0 : out std_logic_vector(0 to 6)
    );
end part4;

-- Atribuicoes concorrentes com expressoes booleanas por segmento.

architecture rtl of part4 is
begin
    LEDG(1 downto 0) <= SW;
    LEDG(9 downto 2) <= (others => '0');

    HEX0(0) <= not (((not SW(1)) and SW(0)) or (SW(1) and (not SW(0))));
    HEX0(1) <= SW(0);
    HEX0(2) <= SW(0);
    HEX0(3) <= SW(1) and SW(0);
    HEX0(4) <= SW(1) and SW(0);
    HEX0(5) <= not (((not SW(1)) and SW(0)) or (SW(1) and (not SW(0))));
    HEX0(6) <= SW(1);
end rtl;
