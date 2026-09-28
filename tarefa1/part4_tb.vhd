library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity part4_tb is
end part4_tb;

architecture test of part4_tb is
    type patterns_t is array (0 to 3) of std_logic_vector(0 to 6);
    constant expected_patterns : patterns_t := (
        "1000010", -- d
        "0110000", -- E
        "0000001", -- 0
        "1111111"  -- branco
    );

    signal SW   : std_logic_vector(1 downto 0) := (others => '0');
    signal LEDG : std_logic_vector(9 downto 0);
    signal HEX0 : std_logic_vector(0 to 6);
begin
    dut : entity work.part4(rtl)
        port map (
            SW   => SW,
            LEDG => LEDG,
            HEX0 => HEX0
        );

    stimulus : process
    begin
        for value in 0 to 3 loop
            SW <= std_logic_vector(to_unsigned(value, 2));
            wait for 1 ns;

            assert HEX0 = expected_patterns(value)
                report "Caractere incorreto no display" severity error;
            assert LEDG(1 downto 0) = SW and LEDG(9 downto 2) = "00000000"
                report "Indicacao das chaves nos LEDs esta incorreta" severity error;
        end loop;

        report "Parte 4: quatro caracteres aprovados" severity note;
        wait;
    end process;
end test;
