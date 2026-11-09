-- conversor bcd-para-decimal

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY part2 IS
	PORT ( SW         : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
	       HEX1, HEX0 : OUT STD_LOGIC_VECTOR(0 TO 6));        -- 7-segs
END part2;

ARCHITECTURE Structure OF part2 IS
	COMPONENT mux2to1_4bit
		PORT ( X, Y : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		       s    : IN  STD_LOGIC;
		       M    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
	END COMPONENT;
	-- bcd7seg definido em part1.vhd
	COMPONENT bcd7seg
		PORT ( B : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		       H : OUT STD_LOGIC_VECTOR(0 TO 6));
	END COMPONENT;
	SIGNAL V, M : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL A    : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL z    : STD_LOGIC;
	SIGNAL d1   : STD_LOGIC_VECTOR(3 DOWNTO 0);  -- VHDL-93 nao aceita expressao no PORT MAP
BEGIN
	V <= SW;

	-- circuito comparador para V > 9
	z <= (V(3) AND V(2)) OR (V(3) AND V(1));

	-- Circuito A: when V > 9, este circuito permite o display0 - d0 mostrar os valores
	-- de 0 - 5 (para V = 10 até V = 15). Note que V3 = 1 para todos esses valores
	-- e V3 não é necessário para o circuito A. O circuito implementa a seguinte tabela
	-- verdade:
	--
	-- V2 V1 V0 | A2 A1 A0
	-- -------------------
	-- 0  1  0  | 0  0  0   (V = 1010 -> 0)
	-- 0  1  1  | 0  0  1   (V = 1011 -> 1)
	-- 1  0  0  | 0  1  0   (V = 1100 -> 2)
	-- 1  0  1  | 0  1  1   (V = 1101 -> 3)
	-- 1  1  0  | 1  0  0   (V = 1110 -> 4)
	-- 1  1  1  | 1  0  1   (V = 1111 -> 5)
	A(3) <= '0';
	A(2) <= V(2) AND V(1);
	A(1) <= V(2) AND NOT(V(1));
	A(0) <= (V(1) AND V(0)) OR (V(2) AND V(0));

	-- multiplexadores
	U0: mux2to1_4bit PORT MAP (V, A, z, M);

	U1: bcd7seg PORT MAP (M, HEX0);
	d1 <= "000" & z;
	U2: bcd7seg PORT MAP (d1, HEX1);
END Structure;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Implementa um multiplexador de 4 bits de 2-para-1.
ENTITY mux2to1_4bit IS
	PORT ( X, Y : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
	       s    : IN  STD_LOGIC;
	       M    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END mux2to1_4bit;

ARCHITECTURE Structure OF mux2to1_4bit IS
BEGIN
	M(0) <= (NOT(s) AND X(0)) OR (s AND Y(0));
	M(1) <= (NOT(s) AND X(1)) OR (s AND Y(1));
	M(2) <= (NOT(s) AND X(2)) OR (s AND Y(2));
	M(3) <= (NOT(s) AND X(3)) OR (s AND Y(3));
END Structure;
