LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

-- entrada de 6-bits usando as chaves SW, e converte para decimal (2-digitos bcd)
-- O bcd7seg desta solucao (igual ao da Parte 5) e o bcd7seg_case de part5.vhd.
ENTITY part6 IS
	PORT ( SW : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
	       HEX3, HEX2, HEX1, HEX0 : OUT STD_LOGIC_VECTOR(0 TO 6));   -- 7-segmentos
END part6;

ARCHITECTURE Behavior OF part6 IS
	COMPONENT bcd7seg_case
		PORT ( bcd     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		       display : OUT STD_LOGIC_VECTOR(0 TO 6));
	END COMPONENT;

	SIGNAL bcd_h       : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL bin6, bcd_l : STD_LOGIC_VECTOR(5 DOWNTO 0);
BEGIN
	bin6 <= SW;

	-- Check various ranges and ajusta para digits bcd.
	PROCESS (bin6)
	BEGIN
		IF (bin6 < "001010") THEN
			bcd_h <= "0000";
			bcd_l <= bin6;
		ELSIF (bin6 < "010100") THEN
			bcd_h <= "0001";
			bcd_l <= bin6 - "001010";
		ELSIF (bin6 < "011110") THEN
			bcd_h <= "0010";
			bcd_l <= bin6 - "010100";
		ELSIF (bin6 < "101000") THEN
			bcd_h <= "0011";
			bcd_l <= bin6 - "011110";
		ELSIF (bin6 < "110010") THEN
			bcd_h <= "0100";
			bcd_l <= bin6 - "101000";
		ELSIF (bin6 < "111100") THEN
			bcd_h <= "0101";
			bcd_l <= bin6 - "110010";
		ELSE
			bcd_h <= "0110";
			bcd_l <= bin6 - "111100";
		END IF;
	END PROCESS;

	-- alimenta os displays
	digit1: bcd7seg_case PORT MAP (bcd_h, HEX1);
	digit0: bcd7seg_case PORT MAP (bcd_l(3 DOWNTO 0), HEX0);

	-- apaga os displays adjacentes
	digit3: bcd7seg_case PORT MAP ("1111", HEX3);
	digit2: bcd7seg_case PORT MAP ("1111", HEX2);

END Behavior;
