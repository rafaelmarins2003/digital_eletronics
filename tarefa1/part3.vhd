library ieee;
use ieee.std_logic_1164.all;

-- MUX 4:1 de 2 bits

entity part3 is
    port (
        SW   : in  std_logic_vector(9 downto 0);
        LEDG : out std_logic_vector(9 downto 0)
    );
end part3;

-- process combinacional com case

architecture behavioral of part3 is
begin
    process (SW)
    begin
        LEDG <= (others => '0');

        case SW(9 downto 8) is
            when "00"   => LEDG(1 downto 0) <= SW(1 downto 0);
            when "01"   => LEDG(1 downto 0) <= SW(3 downto 2);
            when "10"   => LEDG(1 downto 0) <= SW(5 downto 4);
            when "11"   => LEDG(1 downto 0) <= SW(7 downto 6);
            when others => null;
        end case;
    end process;
end behavioral;
