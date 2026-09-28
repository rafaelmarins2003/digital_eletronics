library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity part3_tb is
end part3_tb;

architecture test of part3_tb is
    signal SW   : std_logic_vector(9 downto 0) := (others => '0');
    signal LEDG : std_logic_vector(9 downto 0);
begin
    dut : entity work.part3(behavioral)
        port map (
            SW   => SW,
            LEDG => LEDG
        );

    stimulus : process
        variable switches : std_logic_vector(9 downto 0);
        variable expected : std_logic_vector(1 downto 0);
    begin
        for selector in 0 to 3 loop
            for inputs in 0 to 255 loop
                switches := (others => '0');
                switches(9 downto 8) := std_logic_vector(to_unsigned(selector, 2));
                switches(7 downto 0) := std_logic_vector(to_unsigned(inputs, 8));

                case selector is
                    when 0      => expected := switches(1 downto 0);
                    when 1      => expected := switches(3 downto 2);
                    when 2      => expected := switches(5 downto 4);
                    when others => expected := switches(7 downto 6);
                end case;

                SW <= switches;
                wait for 1 ns;

                assert LEDG(1 downto 0) = expected
                    report "MUX selecionou a entrada incorreta" severity error;
                assert LEDG(9 downto 2) = "00000000"
                    report "LEDs nao utilizados deveriam estar apagados" severity error;
            end loop;
        end loop;

        report "Parte 3: 1024 casos aprovados" severity note;
        wait;
    end process;
end test;
