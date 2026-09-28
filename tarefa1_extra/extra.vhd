library ieee;
use ieee.std_logic_1164.all;

-- Multiplexador 3 para 1 de dois bits pedido na Atividade Extra.
entity mux3_2bit is
    port (
        S       : in  std_logic_vector(1 downto 0);
        U, V, W : in  std_logic_vector(1 downto 0);
        M       : out std_logic_vector(1 downto 0)
    );
end mux3_2bit;

architecture behavioral of mux3_2bit is
begin
    process (S, U, V, W)
    begin
        case S is
            when "00"   => M <= U;
            when "01"   => M <= V;
            when "10"   => M <= W;
            when others => M <= U;
        end case;
    end process;
end behavioral;

library ieee;
use ieee.std_logic_1164.all;

-- Mesmo decodificador da Parte 4, para os displays ativos em nivel baixo.
entity char_7seg is
    port (
        C       : in  std_logic_vector(1 downto 0);
        DISPLAY : out std_logic_vector(0 to 6)
    );
end char_7seg;

architecture rtl of char_7seg is
    constant CHAR_D     : std_logic_vector(0 to 6) := "1000010";
    constant CHAR_E     : std_logic_vector(0 to 6) := "0110000";
    constant CHAR_0     : std_logic_vector(0 to 6) := "0000001";
    constant CHAR_BLANK : std_logic_vector(0 to 6) := "1111111";
begin
    with C select
        DISPLAY <= CHAR_D     when "00",
                   CHAR_E     when "01",
                   CHAR_0     when "10",
                   CHAR_BLANK when others;
end rtl;

library ieee;
use ieee.std_logic_1164.all;

entity extra is
    port (
        SW               : in  std_logic_vector(9 downto 0);
        LEDG             : out std_logic_vector(9 downto 0);
        HEX2, HEX1, HEX0 : out std_logic_vector(0 to 6)
    );
end extra;

architecture structural of extra is
    signal SELECTOR                   : std_logic_vector(1 downto 0);
    signal CH0, CH1, CH2              : std_logic_vector(1 downto 0);
    signal H2_CHAR, H1_CHAR, H0_CHAR : std_logic_vector(1 downto 0);
begin
    LEDG <= SW;

    SELECTOR <= SW(9 downto 8);
    CH0 <= SW(5 downto 4);
    CH1 <= SW(3 downto 2);
    CH2 <= SW(1 downto 0);
	 
    MUX_HEX2 : entity work.mux3_2bit(behavioral)
        port map (SELECTOR, CH0, CH1, CH2, H2_CHAR);

    MUX_HEX1 : entity work.mux3_2bit(behavioral)
        port map (SELECTOR, CH1, CH2, CH0, H1_CHAR);

    MUX_HEX0 : entity work.mux3_2bit(behavioral)
        port map (SELECTOR, CH2, CH0, CH1, H0_CHAR);

    DEC_HEX2 : entity work.char_7seg(rtl) port map (H2_CHAR, HEX2);
    DEC_HEX1 : entity work.char_7seg(rtl) port map (H1_CHAR, HEX1);
    DEC_HEX0 : entity work.char_7seg(rtl) port map (H0_CHAR, HEX0);
end structural;
