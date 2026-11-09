LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY part1_alt IS

	PORT ( 
		SW		:	IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		LEDG	:	OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX1, HEX0 : OUT STD_LOGIC_VECTOR(0 TO 6)
	);
END part1_alt;

ARCHITECTURE Structure OF part1_alt IS
	COMPONENT bcd7seg_alt
		PORT ( 
			B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			H : OUT STD_LOGIC_VECTOR(0 TO 6)
		);
	END COMPONENT;
BEGIN
	LEDG <= SW;
	
	digit1 : bcd7seg_alt PORT MAP (SW(7 DOWNTO 4), HEX1);
	digit0 : bcd7seg_alt PORT MAP (SW(3 DOWNTO 0), HEX0);
END Structure;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY bcd7seg_alt IS
	PORT ( 
		B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		H : OUT STD_LOGIC_VECTOR(0 TO 6)
	);
END bcd7seg_alt;

ARCHITECTURE rtl OF bcd7seg_alt IS
BEGIN
	-- Segmentos ativos em 0: H(0) = topo, H(6) = centro.
	WITH B SELECT
		H <= "0000001" WHEN "0000", -- 0
		     "1001111" WHEN "0001", -- 1
		     "0010010" WHEN "0010", -- 2
		     "0000110" WHEN "0011", -- 3
		     "1001100" WHEN "0100", -- 4
		     "0100100" WHEN "0101", -- 5
		     "0100000" WHEN "0110", -- 6
		     "0001111" WHEN "0111", -- 7
		     "0000000" WHEN "1000", -- 8
		     "0000100" WHEN "1001", -- 9
		     "1111111" WHEN OTHERS;
END rtl;
