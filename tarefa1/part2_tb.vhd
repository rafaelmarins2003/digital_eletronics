library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity part2_tb is
end part2_tb;

architecture test of part2_tb is
    signal SW   : std_logic_vector(9 downto 0) := (others => '0');
    signal LEDG : std_logic_vector(9 downto 0);
begin
    dut : entity work.part2(rtl)
        port map (
            SW   => SW,
            LEDG => LEDG
        );

    stimulus : process
        variable switches : std_logic_vector(9 downto 0);
    begin
        for selector in 0 to 1 loop
            for x in 0 to 15 loop
                for y in 0 to 15 loop
                    switches := (others => '0');
                    switches(9)          := '0';
                    switches(3 downto 0) := std_logic_vector(to_unsigned(x, 4));
                    switches(7 downto 4) := std_logic_vector(to_unsigned(y, 4));

                    if selector = 1 then
                        switches(9) := '1';
                    end if;

                    SW <= switches;
                    wait for 1 ns;

                    if selector = 0 then
                        assert LEDG(3 downto 0) = switches(3 downto 0)
                            report "MUX deveria selecionar X" severity error;
                    else
                        assert LEDG(3 downto 0) = switches(7 downto 4)
                            report "MUX deveria selecionar Y" severity error;
                    end if;

                    assert LEDG(9) = switches(9) and LEDG(8 downto 4) = "00000"
                        report "Indicadores LEDG incorretos" severity error;
                end loop;
            end loop;
        end loop;

        report "Parte 2: 512 casos aprovados" severity note;
        wait;
    end process;
end test;
