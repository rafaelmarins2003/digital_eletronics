library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ula_full_de0 is
    port (
        SW       : in  std_logic_vector(9 downto 0);   -- chaves da DE0
        KEY      : in  std_logic_vector(2 downto 0);   -- botoes (ativos em '0')
        CLOCK_50 : in  std_logic;                      -- clock de 50 MHz da DE0
        HEX0     : out std_logic_vector(7 downto 0);   -- displays 7 seg (ativos em '0')
        HEX1     : out std_logic_vector(7 downto 0);
        HEX2     : out std_logic_vector(7 downto 0);
        HEX3     : out std_logic_vector(7 downto 0);
        LEDG     : out std_logic_vector(9 downto 0)   -- leds verdes
    );
end ula_full_de0;

architecture hardware of ula_full_de0 is

    -- ULA original como componente
    component ula_full
        port (
        A, B: in integer range 0 to 255;
        operacao: in std_logic_vector(2 downto 0);
        resultadoL, resultadoH: out std_logic_vector(7 downto 0);
        overflow: out std_logic
        );
    end component;

    -- decodificador hex -> 7 segmentos, ativo em nivel baixo (DP apagado)
    -- bits: [7]=DP [6]=g [5]=f [4]=e [3]=d [2]=c [1]=b [0]=a
    function hex7seg(nibble: std_logic_vector(3 downto 0)) return std_logic_vector is
    begin
        case nibble is
        when "0000" => return "11000000"; -- 0
        when "0001" => return "11111001"; -- 1
        when "0010" => return "10100100"; -- 2
        when "0011" => return "10110000"; -- 3
        when "0100" => return "10011001"; -- 4
        when "0101" => return "10010010"; -- 5
        when "0110" => return "10000010"; -- 6
        when "0111" => return "11111000"; -- 7
        when "1000" => return "10000000"; -- 8
        when "1001" => return "10010000"; -- 9
        when "1010" => return "10001000"; -- A
        when "1011" => return "10000011"; -- b
        when "1100" => return "11000110"; -- C
        when "1101" => return "10100001"; -- d
        when "1110" => return "10000110"; -- E
        when others => return "10001110"; -- F
        end case;
    end function;

    -- valores gravados de A e B (congelam ao soltar o botao)
    signal regA, regB : unsigned(7 downto 0) := (others => '0');
    signal op         : unsigned(2 downto 0) := (others => '0');

    -- sincronizadores de entradas assincronas (2 flip-flops)
    signal key_sync1, key_sync2 : std_logic_vector(2 downto 0) := (others => '1');
    signal sw_sync1,  sw_sync2  : std_logic_vector(7 downto 0) := (others => '0');

    signal resL, resH : std_logic_vector(7 downto 0);
    signal ovf        : std_logic;

    signal tickcnt : integer range 0 to 25_000_000 := 0; -- 0,5 s a 50 MHz

begin
    process(CLOCK_50)
    begin
        if rising_edge(CLOCK_50) then
        -- sincroniza botoes e chaves antes de usar
        key_sync2 <= key_sync1;
        key_sync1 <= KEY;
        sw_sync2  <= sw_sync1;
        sw_sync1  <= SW(7 downto 0);

        -- segurar o botao = valor acompanha as chaves; soltar = congela
        if key_sync2(0) = '0' then
            regA <= unsigned(sw_sync2);
        end if;
        if key_sync2(1) = '0' then
            regB <= unsigned(sw_sync2);
        end if;

        -- segurar KEY2 cicla a operacao a cada 0,5 s
        if key_sync2(2) = '0' then
            if tickcnt = 25_000_000 then
                tickcnt <= 0;
                op <= op + 1;
            else
                tickcnt <= tickcnt + 1;
            end if;
        else
            tickcnt <= 0;
        end if;
        end if;
    end process;

    ula: ula_full port map (
        A => to_integer(regA),
        B => to_integer(regB),
        operacao => std_logic_vector(op),
        resultadoL => resL,
        resultadoH => resH,
        overflow => ovf
    );

    -- resultado em hex: HEX1 HEX0 = resultadoL, HEX3 HEX2 = resultadoH
    HEX0 <= hex7seg(resL(3 downto 0));
    HEX1 <= hex7seg(resL(7 downto 4));
    HEX2 <= hex7seg(resH(3 downto 0));
    HEX3 <= hex7seg(resH(7 downto 4));

    LEDG(0) <= ovf;                            -- overflow
    LEDG(3 downto 1) <= std_logic_vector(op); -- operacao atual em binario
    LEDG(9 downto 4) <= (others => '0');

end hardware;
