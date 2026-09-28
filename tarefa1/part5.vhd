library ieee;
use ieee.std_logic_1164.all;

-- Rotação de caracteres em quatro displays

-- Multiplexador 4 para 1 de dois bits, equivalente ao circuito da Parte 3.
entity mux4_2bit is
    port (
        S          : in  std_logic_vector(1 downto 0);
        U, V, W, X : in  std_logic_vector(1 downto 0);
        M          : out std_logic_vector(1 downto 0)
    );
end mux4_2bit;

architecture behavioral of mux4_2bit is
begin
    process (S, U, V, W, X)
    begin
        case S is
            when "00"   => M <= U;
            when "01"   => M <= V;
            when "10"   => M <= W;
            when "11"   => M <= X;
            when others => M <= (others => '0');
        end case;
    end process;
end behavioral;

library ieee;
use ieee.std_logic_1164.all;

-- Decodificador da Parte 4. Os segmentos da DE0 sao ativos em nivel 0.
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

entity part5 is
    port (
        SW                   : in  std_logic_vector(9 downto 0);
        LEDG                 : out std_logic_vector(9 downto 0);
        HEX3, HEX2, HEX1, HEX0 : out std_logic_vector(0 to 6)
    );
end part5;

-- arquitetura estrutural, conectando instancias

architecture structural of part5 is
    signal SELECTOR                   : std_logic_vector(1 downto 0);
    signal CH0, CH1, CH2, CH3         : std_logic_vector(1 downto 0);
    signal H3_CHAR, H2_CHAR, H1_CHAR, H0_CHAR : std_logic_vector(1 downto 0);
begin
    LEDG <= SW;

    SELECTOR <= SW(9 downto 8);
    CH0 <= SW(7 downto 6);
    CH1 <= SW(5 downto 4);
    CH2 <= SW(3 downto 2);
    CH3 <= SW(1 downto 0);

    MUX_HEX3 : entity work.mux4_2bit(behavioral)
        port map (SELECTOR, CH0, CH1, CH2, CH3, H3_CHAR);

    MUX_HEX2 : entity work.mux4_2bit(behavioral)
        port map (SELECTOR, CH1, CH2, CH3, CH0, H2_CHAR);

    MUX_HEX1 : entity work.mux4_2bit(behavioral)
        port map (SELECTOR, CH2, CH3, CH0, CH1, H1_CHAR);

    MUX_HEX0 : entity work.mux4_2bit(behavioral)
        port map (SELECTOR, CH3, CH0, CH1, CH2, H0_CHAR);

    DEC_HEX3 : entity work.char_7seg(rtl) port map (H3_CHAR, HEX3);
    DEC_HEX2 : entity work.char_7seg(rtl) port map (H2_CHAR, HEX2);
    DEC_HEX1 : entity work.char_7seg(rtl) port map (H1_CHAR, HEX1);
    DEC_HEX0 : entity work.char_7seg(rtl) port map (H0_CHAR, HEX0);
end structural;
