-- Somador completo de 4 bits - versao alternativa.
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY part3_alt IS
	PORT (
		SW   : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		LEDG : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END part3_alt;

ARCHITECTURE Structure OF part3_alt IS
	COMPONENT fa_alt
		PORT (
			a, b, ci : IN STD_LOGIC;
			s, co    : OUT STD_LOGIC
		);
	END COMPONENT;
	SIGNAL A, B, S : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL C       : STD_LOGIC_VECTOR(4 DOWNTO 0);
BEGIN
	A <= SW(7 DOWNTO 4);
	B <= SW(3 DOWNTO 0);
	C(0) <= SW(8);

	-- o carry de saida do bit i alimenta o carry de entrada do bit i+1
	adders : FOR i IN 0 TO 3 GENERATE
		fa_i : fa_alt PORT MAP (A(i), B(i), C(i), S(i), C(i + 1));
	END GENERATE;

	LEDG(4 DOWNTO 0) <= C(4) & S;
	LEDG(9 DOWNTO 5) <= "00000";
END Structure;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Somador completo a partir da tabela verdade da Figura 2c: co s = a + b + ci.
ENTITY fa_alt IS
	PORT (
		a, b, ci : IN STD_LOGIC;
		s, co    : OUT STD_LOGIC
	);
END fa_alt;

ARCHITECTURE rtl OF fa_alt IS
	SIGNAL entrada : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL saida   : STD_LOGIC_VECTOR(1 DOWNTO 0);
BEGIN
	entrada <= a & b & ci;

	--  a b ci | co s
	WITH entrada SELECT
		saida <= "00" WHEN "000",
		         "01" WHEN "001",
		         "01" WHEN "010",
		         "10" WHEN "011",
		         "01" WHEN "100",
		         "10" WHEN "101",
		         "10" WHEN "110",
		         "11" WHEN "111",
		         "00" WHEN OTHERS;

	co <= saida(1);
	s  <= saida(0);
END rtl;
