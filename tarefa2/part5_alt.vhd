-- Somador BCD de 1 digito S1 S0 = A + B + cin - versao alternativa.
-- Totalmente concorrente e aritmetico: sem PROCESS, sem IF e sem comparacao
-- com 9. A soma vira um inteiro e os digitos saem direto de T / 10 e T MOD 10.
-- Entradas: SW7-4 = A, SW3-0 = B, SW8 = cin
-- Saidas:   A em HEX3, B em HEX2 (a DE0 nao tem HEX5/HEX4), S1 S0 em HEX1 HEX0

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY part5_alt IS
	PORT (
		SW                     : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		HEX3, HEX2, HEX1, HEX0 : OUT STD_LOGIC_VECTOR(0 TO 6)
	);
END part5_alt;

ARCHITECTURE Behavior OF part5_alt IS
	-- bcd7seg_alt definido em part1_alt.vhd
	COMPONENT bcd7seg_alt
		PORT (
			B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			H : OUT STD_LOGIC_VECTOR(0 TO 6)
		);
	END COMPONENT;
	SIGNAL A, B, S1, S0 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL ci           : UNSIGNED(0 DOWNTO 0);
	SIGNAL T            : INTEGER RANGE 0 TO 31;
BEGIN
	A <= SW(7 DOWNTO 4);
	B <= SW(3 DOWNTO 0);
	ci(0) <= SW(8);

	-- soma de 5 bits (0 a 31) convertida para inteiro
	T <= TO_INTEGER(('0' & UNSIGNED(A)) + UNSIGNED(B) + ci);

	-- dezenas e unidades por divisao inteira e resto
	S1 <= STD_LOGIC_VECTOR(TO_UNSIGNED(T / 10, 4));
	S0 <= STD_LOGIC_VECTOR(TO_UNSIGNED(T MOD 10, 4));

	H3 : bcd7seg_alt PORT MAP (A, HEX3);
	H2 : bcd7seg_alt PORT MAP (B, HEX2);
	H1 : bcd7seg_alt PORT MAP (S1, HEX1);
	H0 : bcd7seg_alt PORT MAP (S0, HEX0);
END Behavior;
