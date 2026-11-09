-- Conversor binario (4 bits) para decimal de 2 digitos - versao alternativa..
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY part2_alt IS
	PORT (
		SW         : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		HEX1, HEX0 : OUT STD_LOGIC_VECTOR(0 TO 6)
	);
END part2_alt;

ARCHITECTURE Structure OF part2_alt IS
	COMPONENT mux2to1_4bit_alt
		PORT (
			X, Y : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			s    : IN STD_LOGIC;
			M    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;
	-- bcd7seg_alt definido em part1_alt.vhd
	COMPONENT bcd7seg_alt
		PORT (
			B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			H : OUT STD_LOGIC_VECTOR(0 TO 6)
		);
	END COMPONENT;
	-- V: o número das chaves (uma cópia de SW)
	-- z: 1 se V > 9
	-- A: o valor V − 10, correto só quando V > 9
	-- M: o dígito das unidades (saída do mux)
	-- d1: o dígito das dezenas, que será 0 ou 1   
	SIGNAL V, A, M : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL z       : STD_LOGIC;
	SIGNAL d1      : STD_LOGIC_VECTOR(3 DOWNTO 0);
	
BEGIN
	V <= SW;

	-- Comparador: z = 1 para V > 9, tirado direto da tabela verdade.
	WITH V SELECT
		z <= '1' WHEN "1010" | "1011" | "1100" | "1101" | "1110" | "1111",
		     '0' WHEN OTHERS;

	-- Circuito A: para V > 9 entrega o digito das unidades (V - 10).
	-- Para V <= 9 a saida nao importa, pois o mux seleciona V.
	WITH V SELECT
		A <= "0000" WHEN "1010", -- 10 -> 0
		     "0001" WHEN "1011", -- 11 -> 1
		     "0010" WHEN "1100", -- 12 -> 2
		     "0011" WHEN "1101", -- 13 -> 3
		     "0100" WHEN "1110", -- 14 -> 4
		     "0101" WHEN "1111", -- 15 -> 5
		     "0000" WHEN OTHERS;

	U0 : mux2to1_4bit_alt PORT MAP (V, A, z, M);

	U1 : bcd7seg_alt PORT MAP (M, HEX0);
	d1 <= "000" & z;
	U2 : bcd7seg_alt PORT MAP (d1, HEX1);
END Structure;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Multiplexador 2:1 de 4 bits com atribuicao condicional.
ENTITY mux2to1_4bit_alt IS
	PORT (
		X, Y : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		s    : IN STD_LOGIC;
		M    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END mux2to1_4bit_alt;

ARCHITECTURE rtl OF mux2to1_4bit_alt IS
BEGIN
	M <= X WHEN s = '0' ELSE Y;
END rtl;


--  Exemplo completo: SW = 1101 (13)

--1. z = 1, porque 13 > 9.
--2. O WITH V SELECT dá A = 0011 (3).
--3. O mux, com z = 1, escolhe A, então M = 0011.
--4. HEX0 mostra 3.
--5. d1 = 0001, então HEX1 mostra 1.
--6. Resultado: 13.

--Exemplo com V ≤ 9: SW = 0111 (7)

--1. z = 0.
--2. A vale 0000, mas ninguém usa.
--3. O mux escolhe V, então M = 0111.
--4. HEX0 mostra 7.
--5. d1 = 0000, então HEX1 mostra 0.
--6. Resultado: 07.
