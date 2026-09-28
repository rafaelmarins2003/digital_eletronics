library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity extra_tb is
end extra_tb;

architecture test of extra_tb is
    signal SW               : std_logic_vector(9 downto 0) := (others => '0');
    signal LEDG             : std_logic_vector(9 downto 0);
    signal HEX2, HEX1, HEX0 : std_logic_vector(0 to 6);

    type code_array is array (0 to 2) of std_logic_vector(1 downto 0);

    function decode(C : std_logic_vector(1 downto 0))
        return std_logic_vector is
    begin
        case C is
            when "00"   => return "1000010"; -- d
            when "01"   => return "0110000"; -- E
            when "10"   => return "0000001"; -- 0
            when others => return "1111111"; -- apagado
        end case;
    end function;
begin
    DUT : entity work.extra(structural)
        port map (SW, LEDG, HEX2, HEX1, HEX0);

    stimulus : process
        variable sw_value : std_logic_vector(9 downto 0);
        variable chars    : code_array;
        variable rotation : integer;
    begin
        for value in 0 to 1023 loop
            sw_value := std_logic_vector(to_unsigned(value, SW'length));
            SW <= sw_value;
            wait for 1 ns;

            chars(0) := sw_value(5 downto 4);
            chars(1) := sw_value(3 downto 2);
            chars(2) := sw_value(1 downto 0);
            rotation := to_integer(unsigned(sw_value(9 downto 8)));
            if rotation = 3 then
                rotation := 0;
            end if;

            assert LEDG = sw_value
                report "LEDG nao acompanha SW" severity failure;
            assert HEX2 = decode(chars((rotation + 0) mod 3))
                report "Rotacao incorreta em HEX2" severity failure;
            assert HEX1 = decode(chars((rotation + 1) mod 3))
                report "Rotacao incorreta em HEX1" severity failure;
            assert HEX0 = decode(chars((rotation + 2) mod 3))
                report "Rotacao incorreta em HEX0" severity failure;
        end loop;

        report "Atividade Extra: todas as 1024 combinacoes aprovadas"
            severity note;
        wait;
    end process;
end test;
