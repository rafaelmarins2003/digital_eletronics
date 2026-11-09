-- Conversor binario de 6 bits para BCD de 2 digitos - versao alternativa.
-- Algoritmo double dabble (shift-and-add-3): os bits entram da esquerda para a
-- direita e, antes de cada deslocamento, todo digito BCD >= 5 recebe +3.
-- Para 6 bits so tres celulas add3 sao necessarias; nas demais posicoes do
-- arranjo a entrada e sempre < 5 e a celula vira um fio.
-- Entradas: SW5-0 = numero binario (0 a 63)
-- Saidas:   dezenas em HEX1, unidades em HEX0, HEX3 e HEX2 apagados

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY part6_alt IS
	PORT (
		SW                     : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		HEX3, HEX2, HEX1, HEX0 : OUT STD_LOGIC_VECTOR(0 TO 6)
	);
END part6_alt;

ARCHITECTURE Structure OF part6_alt IS
	COMPONENT add3
		PORT (
			x : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			y : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;
	-- bcd7seg_alt definido em part1_alt.vhd
	COMPONENT bcd7seg_alt
		PORT (
			B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			H : OUT STD_LOGIC_VECTOR(0 TO 6)
		);
	END COMPONENT;
	SIGNAL e3, e5, e7    : STD_LOGIC_VECTOR(3 DOWNTO 0);   -- entradas das celulas
	SIGNAL c3, c5, c7    : STD_LOGIC_VECTOR(3 DOWNTO 0);   -- saidas das celulas
	SIGNAL dezena, unid  : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
	-- 1a celula: os tres bits mais significativos (b5 b4 b3)
	e3 <= '0' & SW(5 DOWNTO 3);
	U3 : add3 PORT MAP (e3, c3);

	-- 2a celula: resultado deslocado + b2
	-- Desloca: descarta o bit mais alto de c3 (que vai para a dezena), e entra o bit SW(2) na direita.
	e5 <= c3(2 DOWNTO 0) & SW(2);
	U5 : add3 PORT MAP (e5, c5);

	-- 3a celula: resultado deslocado + b1
	e7 <= c5(2 DOWNTO 0) & SW(1);
	U7 : add3 PORT MAP (e7, c7);

	-- o bit que "transborda" de cada celula forma o digito das dezenas;
	-- o ultimo deslocamento traz b0 para as unidades
	dezena <= '0' & c3(3) & c5(3) & c7(3);
	unid   <= c7(2 DOWNTO 0) & SW(0);

	H1 : bcd7seg_alt PORT MAP (dezena, HEX1);
	H0 : bcd7seg_alt PORT MAP (unid, HEX0);

	HEX3 <= "1111111";
	HEX2 <= "1111111";
END Structure;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Celula add3: y = x + 3 se x >= 5, senao y = x.
-- Entradas 10-15 nunca ocorrem no double dabble.
ENTITY add3 IS
	PORT (
		x : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		y : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END add3;

ARCHITECTURE rtl OF add3 IS
BEGIN
	WITH x SELECT
		y <= "1000" WHEN "0101", -- 5 -> 8
		     "1001" WHEN "0110", -- 6 -> 9
		     "1010" WHEN "0111", -- 7 -> 10
		     "1011" WHEN "1000", -- 8 -> 11
		     "1100" WHEN "1001", -- 9 -> 12
		     x      WHEN OTHERS;
END rtl;
