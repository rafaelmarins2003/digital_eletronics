library IEEE;
use IEEE.std_logic_1164.all;

entity demux_1_4 is
    generic (N : positive := 2);
    port (
        input          : in  std_logic_vector(N - 1 downto 0);
        sel            : in  std_logic_vector(1 downto 0);
        y0, y1, y2, y3 : out std_logic_vector(N - 1 downto 0)
    );
end demux_1_4;

architecture comportamental of demux_1_4 is
begin
    process (input, sel)
    begin
        y0 <= (others => '0');
        y1 <= (others => '0');
        y2 <= (others => '0');
        y3 <= (others => '0');

        case sel is
            when "00"   => y0 <= input;
            when "01"   => y1 <= input;
            when "10"   => y2 <= input;
            when "11"   => y3 <= input;
            when others => null;
        end case;
    end process;
end comportamental;
